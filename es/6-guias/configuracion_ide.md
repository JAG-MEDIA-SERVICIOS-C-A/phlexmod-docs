# Configuración del Entorno de Desarrollo (IDE)

Para garantizar un flujo de trabajo eficiente y un código consistente en **PHLEXMOD**, hemos estandarizado la configuración para editores de código modernos como **VS Code**, **Windsurf** y **Trae**.

## 1. Configuración Automática (.vscode)

El repositorio incluye una carpeta `.vscode/` con configuraciones predefinidas que tu editor debería reconocer automáticamente.

### Archivos incluidos:
- **`settings.json`**: Configura el estándar de PHP (8.4), formato automático y exclusión de archivos.
- **`extensions.json`**: Recomienda extensiones esenciales.
- **`phlexmod.code-snippets`**: Atajos de código para estructuras comunes del framework.

## 2. Extensiones Recomendadas

Al abrir el proyecto, tu editor te sugerirá instalar las siguientes extensiones (si no lo hace, instálalas manualmente):

- **PHP Intelephense** (`bmewburn.vscode-intelephense-client`): Inteligencia de código PHP esencial.
- **PHP DocBlocker** (`neilbrayfield.php-docblocker`): Ayuda a documentar clases y métodos rápidamente.
- **PHP Debug** (`xdebug.php-debug`): Para depuración con Xdebug.
- **Prettier** (`esbenp.prettier-vscode`): Para formateo de código frontend (JS/CSS/HTML).

## 3. Helper de Autocompletado (_ide_helper.php)

Hemos generado un archivo `_ide_helper.php` en la raíz del proyecto. **NO LO MODIFIQUES NI LO USES EN PRODUCCIÓN.**

### ¿Para qué sirve?
Este archivo define constantes globales (`PHLEXMOD_CORE_PATH`, `PHLEXMOD_DB_HOST`, etc.) y variables globales (`$conexion`) de forma que el IDE pueda entenderlas y ofrecer autocompletado, aunque se definan dinámicamente en tiempo de ejecución.

> **Nota:** Este archivo es solo para desarrollo y no afecta la ejecución del código real.

## 4. Snippets (Atajos de Código)

Para acelerar el desarrollo, usa los siguientes prefijos en tu editor:

| Prefijo | Descripción |
|---------|-------------|
| `mia-api` | Genera la estructura base de un **Endpoint API** seguro (incluye headers, try-catch, sanitización). |
| `mia-ui` | Genera la estructura base de una **Vista UI** (HTML/PHP). |
| `san-post` | Inserta `Sanitizer::post(...)` rápidamente. |
| `pg-query` | Inserta un bloque de consulta `pg_query_params` con manejo de errores. |

### Ejemplo de uso:
Escribe `mia-api` en un archivo PHP vacío y presiona `Tab` para generar todo el esqueleto del archivo.

## 5. Configuración de Windsurf / Trae

Estos editores basados en la tecnología de VS Code heredarán automáticamente la configuración de `.vscode`. Asegúrate de que el modo de "Espacio de Trabajo" (Workspace) esté activo en la raíz del proyecto (`/var/www/html/phlexmod`).
