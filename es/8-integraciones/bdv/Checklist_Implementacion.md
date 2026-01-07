# Checklist de Implementación API BDV

Este documento detalla el estado actual de la integración con las APIs del Banco de Venezuela y propone la implementación de los servicios faltantes, asegurando una arquitectura modular donde cada API cuenta con su propia clase de servicio independiente.

## 1. Estado Actual (Checklist)

| API (Documentación) | Estado | Servicio Implementado | Endpoint Utilizado | Notas |
| :--- | :---: | :--- | :--- | :--- |
| **API Conciliación DUMMY (Calidad) 112025 (1)** | ✅ Implementado | `BdvConciliacionService.php` | `/getMovement/v2` | Método `validarPago`. |
| **API CONCILIACION-MULTIPLE – DUMMY (Calidad)** | ✅ Implementado | `BdvConciliacionService.php` | `/api/consulta/consultaMultiple/v2` | Método `consultarConciliacionMasiva`. Incluye log de respuesta completa para soporte. |
| **API Consulta de Movimiento Dummy 1908** | ✅ Implementado | `BdvConsultaMovimientosService.php` | `/apis/bdv/consulta/movimientos/v2` | Método `consultarMovimientos`. |
| **API Consulta de Saldo Dummy - 1908** | ✅ Implementado | `BdvConsultaSaldoService.php` | `/account/balances/v2` | Método `consultarSaldo`. |
| **API Notificación de Pago (Calidad) 112025** | 🚧 En Desarrollo | `BdvNotificacionPagoService.php` | (Webhook Entrada) | Requiere endpoint para recibir notificaciones POST del banco. |
| **API Vuelto (Calidad) 112025** | 🚧 En Desarrollo | `BdvVueltoService.php` | `/api/vuelto/v2` | Operación "Dar Vuelto". |
| **Doc-API C2P Cuentas Multiples PRODUCCIÓN** | 🚧 En Desarrollo | `BdvC2PCuentasMultiplesService.php` | `/BankMobilePaymentC2P/MultipleAccounts/...` | Incluye Solicitud de OTP y Ejecución de Cobro. |
| **API Consulta de Operaciones Salientes** | 🚧 En Desarrollo | `BdvOperacionesSalientesService.php` | `/getOutMovement/v2` | Conciliación de pagos realizados por el jurídico. |
| **Botón de Pago** | ⏸️ Excluido | N/A | N/A | Excluido del alcance actual por solicitud del usuario. |

---

## 2. Propuesta de Implementación de APIs Faltantes

Para mantener la consistencia y modularidad del sistema, se crearán los siguientes servicios independientes en `/var/www/html/phlexmod/backend/modules/admin/bdv_portal/classes/`. Todos heredarán de `BdvBaseService`.

### A. Servicio de Notificación de Pago
**Clase Propuesta:** `BdvNotificacionPagoService.php`
*   **Descripción:** Maneja la recepción de webhooks enviados por el banco cuando se reciben fondos.
*   **Funcionalidad:**
    *   Método `procesarNotificacion($payload)`: Recibe el JSON del banco.
    *   Validación de estructura (bancoOrdenante, referencia, monto, etc.).
    *   Registro en base de datos local (tabla `bdv_conciliacion_pagos` o similar).
    *   Retorno de respuesta estandarizada al banco (JSON con status 200).

### B. Servicio de Vuelto (Dar Vuelto)
**Clase Propuesta:** `BdvVueltoService.php`
*   **Descripción:** Permite realizar operaciones de devolución de cambio a través de PagoMóvilBDV.
*   **Métodos:**
    *   `ejecutarVuelto($params)`: Consume `/api/vuelto/v2`.
    *   Parámetros: referencia, monto, cedulaDestino, telefonoDestino, bancoDestino.

### C. Servicio C2P Cuentas Múltiples
**Clase Propuesta:** `BdvC2PCuentasMultiplesService.php`
*   **Descripción:** Gestión de cobros C2P (Comercio a Persona) con soporte para cuentas múltiples.
*   **Métodos:**
    *   `solicitarOTP($cedula, $telefono)`: Consume `/BankMobilePaymentC2P/MultipleAccounts/paymentkey`.
    *   `procesarCobro($params)`: Consume `/BankMobilePaymentC2P/MultipleAccounts/process`. Requiere OTP, monto, concepto, etc.

### D. Servicio de Operaciones Salientes
**Clase Propuesta:** `BdvOperacionesSalientesService.php`
*   **Descripción:** Permite conciliar/verificar pagos que la empresa ha realizado (débitos).
*   **Métodos:**
    *   `consultarOperacionSaliente($params)`: Consume `/getOutMovement/v2`.
    *   Parámetros: cedulaPagador, telefonoPagador, referencia, fechaPago, importe, bancoDestino.

---

## 3. Acciones Inmediatas
1.  Aprobar esta propuesta.
2.  Crear los archivos de servicio vacíos o con estructura base en `classes/`.
3.  Implementar la lógica específica de cada uno según la documentación adjunta en `docs/API BDV`.
