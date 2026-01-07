![ref1]

**API Vuelto (Calidad) ![](Aspose.Words.7a49f626-3396-4660-95e8-5686288653e1.002.png)**



|**Documentación técnica** **Control de versiones** |**Fecha: 26/03/25** ||||||
| :-: | - | :- | :- | :- | :- | :- |
|**Nombre del Servicio** |**Versión** |**Fecha** |**Nueva Versión** |**Descripción del cambio** |||
||||||||
**Documentación API Vuelto Descripción**

Permite  realizar  operaciones  de  “Dar  Vuelto”  (monto  en  Bolívares  que  el  vendedor  devuelve  al comprador cuando éste entregó más efectivo del que era necesario para pagar un producto o un servicio)  a  través  de  PagomóvilBDV  con  débito  en  la  cuenta  jurídica,  p ermite  integrarse  en  su plataforma o usado a través de los diferentes canales del Banco de Venezuela (Merchant, Puntos de Venta BDV y BiopagoBDV).  

Características Principales / Ventajas: 

- Promueve la adopción de métodos de pago digitales en la economía a ctual. 
- Capacidad de realizar el pago del vuelto de forma eficiente, rápida y conveniente. 
- Integración sencilla a los sistemas y aplicativos existentes. 
- Mejora la experiencia del usuario.

**Método**

POST 

**URL [https://bdvconciliacionqa.banvenez.com:444/api/vuelto/v2 ](https://bdvconciliacionqa.banvenez.com:444/api/vuelto/v2)Header**  



|**Servicio** |API VUELTO |
| - | - |
|**Tipo** |Post |
|**Header** |X-API-Key    256D0FDD36F1B1B3F1208A9B6EC693 (api key de prueba – calidad ) |
|**Content-Type** |Application/json |

**Av. Universidad, esquina Sociedad, Edificio Banco de Venezuela, Caracas, Distrito Capital                                                                                                              Rif: G-20009997-6      ![ref2]**

![ref3] ![ref4]
![ref1]

**Parámetros de la solicitud** 

- numeroReferencia:  "6111121716",     enviar de forma automática 
- montoOperacion:   "1.21",  
- nacionalidadDestino: "V",   
- cedulaDestino: "15404774",    
- telefonoDestino:  "04123963208",     
- bancoDestino: "0102",     
- moneda:  "VES",      
- conceptoPago:  "Prueba Api Vuelto”  

**Respuesta Exitosa (JSON) Respuesta** 

- code: 1000,     

Es un número que el cliente debe generar y 

Importe del pago 

Tipo de documento  

Número de cédula receptor Número de teléfono receptor  Banco destino  

Tipo de moneda “VES” Descripción del pago 

Código de respuesta exitosa 

**Av. Universidad, esquina Sociedad, Edificio Banco de Venezuela, Caracas, Distrito Capital                                                                                                              Rif: G-20009997-6      ![ref2]**

![ref3] ![ref4]
![ref1]

- message: "Transaccion realizada", 
- referencia: "6111121716" 

**Ejemplo de solicitud** 

{ ![](Aspose.Words.7a49f626-3396-4660-95e8-5686288653e1.006.png)![](Aspose.Words.7a49f626-3396-4660-95e8-5686288653e1.007.png)"numeroReferencia":"6111121716", "montoOperacion":"1.21", "nacionalidadDestino":"V", "cedulaDestino":"15404774", "telefonoDestino":"04123963208", "bancoDestino":"0102", "moneda":"VES", "conceptoPago":"Prueba Api Vuelto" } 

**Ejemplo de respuesta** 

{ ![](Aspose.Words.7a49f626-3396-4660-95e8-5686288653e1.008.png)![](Aspose.Words.7a49f626-3396-4660-95e8-5686288653e1.009.png)

`    `"code": 1000, 

`    `"message": "Transaccion realizada",     "referencia": "6111121716" 

} 
**Av. Universidad, esquina Sociedad, Edificio Banco de Venezuela, Caracas, Distrito Capital                                                                                                              Rif: G-20009997-6      ![ref2]**

![ref3] ![ref4]

[ref1]: Aspose.Words.7a49f626-3396-4660-95e8-5686288653e1.001.png
[ref2]: Aspose.Words.7a49f626-3396-4660-95e8-5686288653e1.003.png
[ref3]: Aspose.Words.7a49f626-3396-4660-95e8-5686288653e1.004.png
[ref4]: Aspose.Words.7a49f626-3396-4660-95e8-5686288653e1.005.png
