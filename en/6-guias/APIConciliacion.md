> ⚠️ **TRANSLATION PENDING:** This document is currently in Spanish. Contributions to translate it to English are welcome.

# API Conciliación BDV

## Datos de Producción

| Campo         | Valor                                                                 |
|---------------|-------------------------------------------------------------------------|
| Servicio      | Conciliación de Movimientos                                            |
| Tipo          | `POST`                                                                  |
| Authorization | `X-API-Key` (API generado desde BDVenLínea Empresa)                    |
| Content-Type  | `application/json`                                                     |
| EndPoint      | `https://bdvconciliacion.banvenez.com:443/getMovement`                 |

### JSON de Entrada
```json
{
  "cedulaPagador": "",
  "telefonoPagador": "",
  "telefonoDestino": "",
  "referencia": "",
  "fechaPago": "",
  "importe": "",
  "bancoOrigen": ""
}
```

### JSON de Salida
```json
{
  "code": 1000,
  "message": "monto : 10 - estatus : Transaccionrealizada",
  "data": {
    "status": "1000",
    "amount": "10.00",
    "reason": "Transaccionrealizada"
  },
  "status": 200
}
```

### Descripción de campos de entrada

| Campo            | Tipo     | Descripción                         |
|------------------|----------|-------------------------------------|
| `cedulaPagador`  | string   | Cédula del cliente pagador          |
| `telefonoPagador`| string   | Teléfono del cliente pagador        |
| `telefonoDestino`| string   | Teléfono del cliente receptor       |
| `referencia`     | string   | Referencia del pago                 |
| `fechaPago`      | string   | Fecha del pago (formato `YYYY-MM-DD`) |
| `importe`        | string   | Monto de pago (ej. `10.00`)         |
| `bancoOrigen`    | string   | Banco Origen                        |

### Ejemplo `curl`

```bash
curl -X POST \
  'https://bdvconciliacion.banvenez.com:443/getMovement' \
  -H 'Content-Type: application/json' \
  -H 'X-API-Key: <TU_API_KEY>' \
  -d '{
    "cedulaPagador": "V12345678",
    "telefonoPagador": "04140000000",
    "telefonoDestino": "04140000001",
    "referencia": "ABC123",
    "fechaPago": "2023-12-21",
    "importe": "10.00",
    "bancoOrigen": "BDV"
  }'
```

## Posibles errores de integración
Cuando el contrato JSON no se cumple:

- Servicio: Conciliación de Movimientos
- Tipo: `POST`
- Authorization: `X-API-Key 96R7T1T5J2134T5YFC2GF15SDFG4BD1Z`
- Content-Type: `application/json`
- EndPoint (ambiente previo / pruebas): `http://200.11.243.176:444/getMovement`

### Ejemplo de respuesta de error
```json
{
  "timestamp": "2023-07-27T15:35:58.751+00:00",
  "path": "/getMovement",
  "status": 400,
  "error": "Bad Request",
  "requestId": "c7ebcb1c-9"
}
```

## Metadatos del Documento
- Manual de usuario: API Conciliación BDV
- Codificación: MDU-006
- Versión: 1
- Fecha de emisión: 21/12/2023
- Fecha de actualización: 17/01/2024

## Códigos de respuesta

| code  | status | Descripción                         |
|------:|-------:|-------------------------------------|
| 1000  | 200    | Transacción realizada                |
| 1001  | 400    | Parámetros inválidos                 |
| 1002  | 404    | Movimiento no encontrado             |
| 1099  | 500    | Error interno del servicio           |

## Consideraciones de seguridad

- No exponer ni registrar valores reales de `X-API-Key`.
- Usar `https` en producción (`443`).
- Validar formato de `importe` y normalizar decimales.
- Validar longitud y formato de teléfonos y cédula.

## Ejemplo de integración en PHLEXMOD

Ruta de endpoint: `backend/modules/settings/endpoints/conciliacion/validate_bdv.api.php`
Referencia de código: `backend/modules/settings/endpoints/conciliacion/validate_bdv.api.php:54`

- Acepta ambos formatos de éxito: `status === 'success'` y `success === true`.
- Usa selector de ente vía `id_ente` siguiendo `ente.id` y `ente.nombre`.
- Realiza `$.ajax({ data: { id_pendiente } })` con parámetros simples.
- Cierra conexión cURL y persiste resultados en `setting_conciliacion_transacciones`.
