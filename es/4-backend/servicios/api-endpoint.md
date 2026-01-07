# Servicio de Resolución de Recursos Dinámicos (`api-endpoint.php`)

Este servicio actúa como un puente seguro entre el frontend y el sistema de archivos del servidor, permitiendo la carga dinámica de recursos (scripts JS) de módulos sin exponer la estructura interna de directorios.

## 📍 Archivo Fuente
`backend/core/api-endpoint.php`

## 🛡️ Propósito
Recibir rutas encriptadas desde el cliente, desencriptarlas, validarlas y generar un **Token de Acceso Único** para ser utilizado por el Proxy de Carga (`load_resource.php`).

## ⚙️ Flujo de Trabajo

1.  **Solicitud**: El cliente (frontend) envía un POST con `datosEncriptados` (ruta del recurso) y `dirMod`.
2.  **Desencriptación**: El servidor desencripta el payload usando la clave de sesión.
3.  **Validación**:
    *   Verifica que la ruta resuelta apunte a un directorio permitido (`backend/modules/` o `modules/admin/js/`).
    *   Verifica que el archivo sea de tipo `.js`.
4.  **Generación de Token**:
    *   Crea un hash **SHA-256** (anteriormente MD5, actualizado por seguridad) combinando:
        *   Ruta desencriptada.
        *   ID de Sesión.
        *   Salt fijo (`phlexmod_secure_resource`).
5.  **Almacenamiento**:
    *   Intenta guardar el mapeo `Token -> Ruta Real` en **Redis** (TTL 2 horas).
    *   Fallback: Guarda en `$_SESSION['resource_map']`.
6.  **Respuesta**: Devuelve una URL relativa para el proxy:
    ```json
    {
      "url": "load_resource.php?r=<TOKEN>&f="
    }
    ```

## 🔒 Seguridad
*   **SHA-256**: Se utiliza para la generación de tokens, evitando colisiones de MD5.
*   **Validación de Rutas**: Previene Path Traversal asegurando que el archivo esté dentro de directorios permitidos.
*   **Sesión Vinculada**: Los tokens están atados a la sesión del usuario; si la sesión expira, el recurso no carga.

## 📝 Ejemplo de Uso (Frontend)
Este endpoint es consumido internamente por `module-loader.js`:

```javascript
$.post('backend/core/api-endpoint.php', {
    datosEncriptados: encryptedPath
}, function(response) {
    if (response.url) {
        // Cargar script dinámicamente
        loadScript(response.url + fileName);
    }
});
```
