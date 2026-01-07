# Sistema de Seguridad y Proxy de Recursos (Phlexmod)

## Descripción General

El sistema de seguridad de Phlexmod implementa un mecanismo de "Proxy de Recursos" para ocultar la estructura física de archivos del servidor (`/var/www/html/...`) a los usuarios finales.

Esto previene ataques de enumeración de directorios y oculta la lógica de negocio interna.

## Componentes

### 1. `backend/core/api-endpoint.php` (Generador de Tokens)
Este archivo es responsable de:
- Recibir una ruta real del servidor (ej: `/var/www/html/phlexmod/backend/modules/admin/menu/js/`).
- Generar un **Token Único** (hash) asociado a esa ruta.
- Almacenar el mapeo `Token -> Ruta Real` en `$_SESSION['resource_map']`.
- Retornar al frontend la URL del proxy con el token (ej: `../frontend/load_resource.php?r=TOKEN`).

**Nota:** La respuesta JSON de este endpoint **NO** contiene la ruta real (`rutaReal` está comentada/oculta).

### 2. `frontend/load_resource.php` (El Proxy)
Este script actúa como intermediario para servir archivos.
- **Validación:** Verifica que el token exista en la sesión.
- **Mapeo:** Recupera la ruta base real desde `$_SESSION['resource_map']`.
- **Seguridad:** 
  - Limpia buffers de salida (`ob_end_clean`) para evitar corrupción de datos.
  - Impide navegación profunda (`../../`).
  - Solo sirve extensiones permitidas (js, css, png, jpg, svg, php).
- **Ejecución PHP:**
  - Para archivos `.php`, cambia el directorio de trabajo (`chdir`) al directorio del script para asegurar que los `include` relativos funcionen.
  - Soporta parámetros GET dinámicos (ej: `script.php?id=1`).

### 3. `frontend/assets/js/module-loader.js` (Cliente)
El cargador de módulos ha sido actualizado para usar **exclusivamente** el proxy.
- **PATH_ENDPOINTS:** Se configura automáticamente apuntando al proxy.
- **Carga de Scripts:** Transforma las rutas de scripts JS para pasar por el proxy.

## Flujo de Trabajo

1. **Frontend:** Solicita cargar un módulo.
2. **Backend:** `engine.php` determina la ruta del módulo y llama a `api-endpoint.php` (o lógica similar) para obtener la URL encriptada.
3. **Frontend:** Recibe `../frontend/load_resource.php?r=ABC123XYZ`.
4. **Frontend (ModuleLoader):**
   - Carga el JS principal usando esa URL.
   - Configura `PATH_ENDPOINTS` = `../frontend/load_resource.php?r=ABC123XYZ&f=../endpoints/`.
5. **Módulo (JS):**
   - Hace una petición a `PATH_ENDPOINTS + 'listar.api.php'`.
   - La URL final es `../frontend/load_resource.php?r=ABC123XYZ&f=../endpoints/listar.api.php`.
6. **Proxy:**
   - Resuelve el token `ABC123XYZ` a `/backend/modules/admin/modulo/js/`.
   - Concatena `../endpoints/listar.api.php`.
   - Ruta final: `/backend/modules/admin/modulo/endpoints/listar.api.php`.
   - Ejecuta el script PHP y devuelve la respuesta.

## Consideraciones para Desarrolladores

- **NUNCA** hardcodear rutas tipo `/backend/...` en el Javascript.
- Usar siempre `PATH_ENDPOINTS` para peticiones AJAX.
- Para incluir archivos en PHP, usar `__DIR__` o `dirname(__FILE__)`.
- El proxy maneja automáticamente `$_POST` y `$_GET`, por lo que los endpoints funcionan igual que si fueran llamados directamente.
