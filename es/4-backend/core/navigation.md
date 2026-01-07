# Sistema de Menú y Navegación (`navigation-menu.php`)

Componente encargado de renderizar el menú lateral de la aplicación basándose en los permisos del usuario y la estructura jerárquica definida en la base de datos.

## 📍 Archivo Fuente
`backend/core/navigation-menu.php`

## 🧠 Lógica de Funcionamiento

1.  **Identificación del Usuario**: Obtiene el ID de usuario de la sesión actual (`$_SESSION['idLogin']`).
2.  **Consulta de Permisos**:
    *   Ejecuta una consulta SQL compleja (`WITH RECURSIVE` o similar) para obtener los módulos a los que el usuario tiene acceso.
    *   Filtra por `setting_privilege_user` y grupos asignados.
    *   Ordena por `orden` definido en la tabla de menús.
3.  **Encriptación de Rutas**:
    *   Genera los parámetros `modulo` y `contenido` encriptados para los enlaces.
    *   Usa `encryption.php` para asegurar que las URLs no expongan IDs o nombres internos de archivos.
4.  **Renderizado HTML**:
    *   Genera una lista no ordenada (`<ul>`, `<li>`) con clases CSS para el framework de UI (Bootstrap/AdminLTE/Custom).
    *   Maneja menús anidados (submenús) si la estructura lo define.

## 🔍 Consulta SQL Clave
El sistema une las tablas:
*   `setting_menu`: Definición de ítems de menú.
*   `setting_modules`: Definición de módulos del sistema.
*   `setting_privilege_user`: Permisos directos de usuario.
*   `setting_user` / `setting_grupos`: Relación de usuario y grupos (departamentos).

## 🛡️ Seguridad
*   **Visibilidad != Acceso**: Este archivo solo controla la *visibilidad* de los enlaces. La seguridad real es aplicada por `engine.php` al intentar acceder a la ruta.
*   **Ofuscación**: Todos los enlaces generados (`href`) contienen parámetros encriptados, impidiendo la enumeración de módulos por URL.

## 🎨 Personalización
El HTML generado depende de las clases CSS definidas en el archivo. Para cambiar la apariencia del menú, se debe modificar este archivo o ajustar las hojas de estilo del tema en `frontend/assets/css/`.
