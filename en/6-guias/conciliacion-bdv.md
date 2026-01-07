> ⚠️ **TRANSLATION PENDING:** This document is currently in Spanish. Contributions to translate it to English are welcome.

# Módulo de Conciliación BDV (PHLEXMOD)

## Objetivo
Conciliar pagos móviles (BDV) para empresas registradas: registrar pendientes, listar y validar contra la API oficial.

## Ubicación del módulo
- Endpoints: `backend/modules/settings/endpoints/conciliacion/*`
  - `register_pending.api.php`
  - `list_pending.api.php`
  - `validate_bdv.api.php`

## Configuración
- `PHLEXMOD_BDV_API_KEY`: clave por defecto en `core-config.php:126`
- `PHLEXMOD_BDV_API_URL`: URL del servicio
- `PHLEXMOD_BDV_API_TIMEOUT`: tiempo de espera
- La API Key por empresa (`setting_conciliacion_empresas.api_key_bdv`) tiene prioridad sobre la global.

## Base de datos (prefijo MCP `setting_`)
- `setting_conciliacion_empresas`
  - `id_empresa`, `rif`, `nombre`, `telefono`, `cuenta_bancaria`, `api_key_bdv`, `config_json`, `estado`, `created_at`, `updated_at`, `created_by`, `updated_by`
- `setting_conciliacion_pendientes`
  - `id_pendiente`, `id_empresa`, `cedula_pagador`, `telefono_pagador`, `telefono_destino`, `referencia`, `fecha_pago`, `importe`, `banco_origen`, `estado`, `intentos`, `created_at`, `created_by`
- `setting_conciliacion_transacciones`
  - `id_transaccion`, `id_empresa`, `id_pendiente`, `cedula_pagador`, `telefono_pagador`, `telefono_destino`, `referencia`, `fecha_pago`, `importe`, `banco_origen`, `codigo_respuesta`, `mensaje_respuesta`, `estado_conciliacion`, `created_at`, `validated_by`
- Vista sugerida: `vw_setting_conciliacion_traza` (resumen pendientes/conciliadas/errores por empresa)

## Trazabilidad de usuario
- Pendientes: guarda `created_by` desde `$_SESSION['idLogin']` (`register_pending.api.php`)
- Conciliaciones: guarda `validated_by` desde `$_SESSION['idLogin']` (`validate_bdv.api.php`)

## Especificación de Endpoints

### Registrar pendiente
- Método: `POST`
- Ruta: `backend/modules/settings/endpoints/conciliacion/register_pending.api.php`
- Parámetros:
  - `id_empresa`, `cedula_pagador`, `telefono_pagador`, `telefono_destino`, `referencia`, `fecha_pago` (YYYY-MM-DD), `importe` (ej. 120.00), `banco_origen`
- Respuesta:
  - `{ status: 'success', success: true, data: { id_pendiente } }`

Ejemplo:
```
curl -X POST \
  -d "id_empresa=1&cedula_pagador=V27037606&telefono_pagador=04127141363&telefono_destino=04127141363&referencia=123112313&fecha_pago=2023-02-12&importe=120.00&banco_origen=0102" \
  http://HOST/backend/modules/settings/endpoints/conciliacion/register_pending.api.php
```

### Listar pendientes
- Método: `POST`
- Ruta: `backend/modules/settings/endpoints/conciliacion/list_pending.api.php`
- Parámetros:
  - `id_empresa`, `desde`, `hasta` (YYYY-MM-DD)
- Respuesta:
  - `{ status: 'success', success: true, data: [ ... ] }`

### Validar contra BDV
- Método: `POST`
- Ruta: `backend/modules/settings/endpoints/conciliacion/validate_bdv.api.php`
- Parámetros:
  - `id_pendiente`
- Proceso:
  - Construye JSON según BDV
  - Header `X-API-Key`: usa la de la empresa o `PHLEXMOD_BDV_API_KEY`
  - Persiste en `setting_conciliacion_transacciones` y actualiza estado de la pendiente
- Respuesta:
  - `{ status: 'success', success: true, data: { id_transaccion, code, message, http } }`

Ejemplo:
```
curl -X POST -d "id_pendiente=123" \
  http://HOST/backend/modules/settings/endpoints/conciliacion/validate_bdv.api.php
```

## Formatos requeridos (BDV)
- `fechaPago`: `YYYY-MM-DD` (no usar `/`)
- `importe`: `120.00` (no usar `,`)

## Códigos de respuesta (BDV)
- `1000`: Transacción realizada
- `1010`: Registro no existe / datos mandatorios nulos
- `HTTP 400`: Contrato JSON inválido

## Consultas útiles
- Pendientes por empresa y fechas:
```
SELECT id_pendiente, referencia, fecha_pago, importe, banco_origen, created_at
FROM setting_conciliacion_pendientes
WHERE id_empresa = $1 AND estado = 'pendiente'
  AND fecha_pago BETWEEN $2::date AND $3::date
ORDER BY created_at DESC;
```
- Conciliadas con validador:
```
SELECT t.id_transaccion, t.referencia, t.fecha_pago, t.importe, t.estado_conciliacion,
       t.codigo_respuesta, t.mensaje_respuesta, t.created_at,
       u.usuario AS validado_por
FROM setting_conciliacion_transacciones t
LEFT JOIN setting_user u ON u.uid = t.validated_by
WHERE t.id_empresa = $1
ORDER BY t.created_at DESC;
```

## Seguridad
- No exponer claves en respuestas
- Validar y sanitizar entradas
- Usar `CURLOPT_SSL_VERIFYPEER` activo y `timeout` configurado

## Notas
- Este módulo es administrativo (perfil empresa/contabilidad)
- Integración de interfaz y JS se recomienda bajo `backend/modules/settings/js/` y `backend/modules/settings/ui/`
