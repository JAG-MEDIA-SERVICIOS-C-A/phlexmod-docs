> ⚠️ **TRANSLATION PENDING:** This document is currently in Spanish. Contributions to translate it to English are welcome.

﻿![](Aspose.Words.47f0c0cf-ba9b-4d46-825a-db44c7b8c475.001.png)

**API Conciliación DUMMY (Calidad) ![](Aspose.Words.47f0c0cf-ba9b-4d46-825a-db44c7b8c475.002.png)**



|**Documentación técnica** **Control de versiones** |**Fecha: 17/11/25** ||||
| :-: | - | :- | :- | :- |
|**Nombre del Servicio** |**Versión** |**Fecha** |**Nueva Versión** |**Descripción del cambio** |
|API Conciliación |1 ||2 |Modificación URL / Calidad  |
|API Conciliación |2 |18/10/2024 |3 |Tabla de errores  |
|API Conciliación |3 |13/11/2024 |4 |Modificación del json de entrada “reqCed” |
|API Conciliación |4 |17/03/2025 |5 |Cambio de URL  |
|API Conciliación |5 |17/11/2025 |6 |<p>- Ajuste de mensaje para pagos conciliados anteriormente </p><p>- Adición de respuestas faltantes del servicio </p>|

**Documentación  Descripción**

Permite conciliar los pagos realizados por un cliente.   Características Principales / Ventajas: 

- Conciliar el pago móvil recibido en línea y en tiempo real. 
- Integración sencilla a los sistemas. 

**Método**

POST 

**URL** 

[https://bdvconciliacionqa.banvenez.com:444/getMovement/v2 ](https://bdvconciliacionqa.banvenez.com:444/getMovement/v2)

**Header (se debe indicar los datos exactamente como se muestra en el cuadro)** 



|**Servicio** |Conciliación de Movimientos|Nombre del Servicio. |
| - | - | - |
|**Tipo** |POST |Tipo de petición. |
|**Header** |X-API-Key 96R7T1T5J2134T5YFC2GF15SDFG4BD1Z |Api Key único generado por el cliente. |
|**Content-Type** |Application/json |Tipo de entrada.  |
|**EndPoint** |/getMovement/v2 |Url para el consumo del api. |

**Parámetros de la solicitud ![](Aspose.Words.47f0c0cf-ba9b-4d46-825a-db44c7b8c475.003.png)**



|"cedulaPagador": " V27037606", |Número de cédula del pagador |
| - | - |
|"telefonoPagador": "04127141363", |Número de teléfono de quien ejecuta el pago |
|"telefonoDestino": "04127141363", |Número de teléfono de quien recibe el pago |
|"referencia": "12345678", |Número de referencia resultado de la operación |
|"fechaPago": "2023-02-12", |Fecha del pago |
|"importe": "120.00", |Importe del pago, debe colocar los decimales con “.” |
|"bancoOrigen": "0102" |Banco origen |
|"reqCed": |Si  el  cliente  desea  validar  el  número  de  cédula  desde  su aplicación  debe  colocar  este  campo  como  “true”  y  esto  solo ![](Aspose.Words.47f0c0cf-ba9b-4d46-825a-db44c7b8c475.004.png)puede ocurrir con operaciones BDV  – BDV, en caso contrario debe permanecer en “false”, para operaciones de otros bancos no se valida la cédula |

**Parámetros de la Respuesta Exitosa (JSON)**  

**Code**: código de respuesta (**1000)** ![](Aspose.Words.47f0c0cf-ba9b-4d46-825a-db44c7b8c475.005.png)

**Message**: detalle de la acción (**monto : 1.00 - estatus : Transacción realizada**) **Data**: Detalle de la transacción (**{** 

`        `**"status": "**1000**",** 

`        `**"amount": "**1.00**",** 

`        `**"reason": "**Transacción realizada**",** 

`        `**"referencia": "**12345678**"** 

`    `**}** 

) 

**Status**: Estado de la operación (**200**) 

![](Aspose.Words.47f0c0cf-ba9b-4d46-825a-db44c7b8c475.006.png)**Importante:** En caso de ejecutar una nueva consulta e invocar nuevamente el API (30 segundos después de la primera llamada), la respuesta será la siguiente: 

Mensaje de respuesta: El pago ya fue conciliado previamente. 

**Json de entrada (se debe colocar la data exactamente como se indica en el ejemplo) ![](Aspose.Words.47f0c0cf-ba9b-4d46-825a-db44c7b8c475.007.png)**

{ 

`    `"cedulaPagador": "V27037606", 

`    `"telefonoPagador": "04127141363",     "telefonoDestino": "04127141363",     "referencia": "12345678", 

`    `"fechaPago": "2023-02-12", 

`    `"importe": "120.00", 

`    `"bancoOrigen": "0102", 

`    `"reqCed": false 

} 

**Json de salida (exitoso)** 

**{** 

**"**code**":** 1000**,** 

**"**message**": "**Monto: 120.00 - estatus: Transacción realizada**", "**data**": {** 

**"**status**": "**1000**",** 

**"**amount**": "**120.00**",** 

**"**reason**": "**Transacción realizada**",** 

**"**referencia**": "**12345678**",** 

**"**status**":** 200** 

**}** 

**Json de salida (con datos errados excepto el monto/importe)** 

**{** 

**"code":** 1010**,** 

**"message**": "No se pudo validar el movimiento : Registro solicitado no 

existe"**,** 

**"data":** null**,** 

**"status":** 200** 

**}** 

**Json de salida (con monto/importe errado)** 

**{** 

**"code":** 1010**,** 

**"message": "**monto : 120.00 - estatus : Transacción realizada", **"data":** null**,** 

**"status":** 200** 

**}** 

**Json de salida (pago móvil ya procesado correctamente por el servicio pero que ya ha sido conciliado anteriormente)** 

**Nota: para esta validación solo cambiamos el importe de 120.00 a 123.00, el resto de datos continua igual** 

**{** 

`    `**"code":** 1010**,** 

`    `**"message**": "Pago Móvil procesado exitosamente en el BDV. El movimiento ya fue conciliado anteriormente."**,** 

`    `**"data":** null**,** 

`    `**"status":** 200** 

**}** 

**Json de salida (ApiKey errado)** 

**{** 

`    `**"code": 1010,** 

`    `**"message": "Cliente no afiliado al producto",     "data": null,** 

`    `**"status": 200** 

**}** 

**Nota: Por favor es importante tomar en consideración los códigos de respuestas que retorna el servicio.** 

Código de pagos conciliados exitosamente  Code: **1000 ![](Aspose.Words.47f0c0cf-ba9b-4d46-825a-db44c7b8c475.008.png)**Código de pagos no conciliados exitosamente  Code: **1010**

**Importante:** 

En operaciones interbancarias, la red **Suiche 7B** no suministra el número de documento del ordenante. Por esta razón, el Banco sustituye dicho valor en el campo **ci\_ordenante** por el identificador **“V” + RIF del comercio receptor**. Este comportamiento es intencional, en este caso debe usar el número de teléfono pagador para identificar a su cliente.  

![](Aspose.Words.47f0c0cf-ba9b-4d46-825a-db44c7b8c475.009.png)
**Av. Universidad, esquina Sociedad, Edificio Banco de Venezuela, Caracas, Distrito Capital                                                                                                              Rif: G-20009997-6      ![](Aspose.Words.47f0c0cf-ba9b-4d46-825a-db44c7b8c475.010.png)**

![](Aspose.Words.47f0c0cf-ba9b-4d46-825a-db44c7b8c475.011.png)
