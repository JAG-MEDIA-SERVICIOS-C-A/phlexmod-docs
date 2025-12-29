# Creación de Módulos con la CLI

**Última actualización:** Diciembre 2024

En PHLEXMOD, un módulo es una unidad funcional autocontenida. La forma recomendada y más eficiente de crear módulos es utilizando la herramienta de línea de comandos `phlex`.

## El Comando `make:module`

El comando `make:module` se encarga de todo el trabajo pesado:

1. Crea la estructura de directorios completa (`ui/`, `js/`, `endpoints/`, `css/`)
2. Genera los archivos base (entry-point, JS, CSS)
3. **Registra automáticamente el nuevo módulo** en la base de datos (`setting_menu`), haciéndolo inmediatamente disponible en el sistema

### Uso Básico

```bash
php phlex make:module <nombre_modulo> --scope=<scope>
```

- `<nombre_modulo>`: El nombre de tu módulo en snake_case (ej. `gestion_clientes`)
- `--scope`: Define dónde se creará el módulo
  - `user`: Para módulos de negocio estándar (en `backend/modules/`)
  - `admin`: Para módulos de administración (en `backend/modules/admin/`)

---

## Tutorial: Creando un Módulo "Hola Mundo"

Vamos a crear un módulo de prueba llamado `hola_mundo`.

### Paso 1: Generar el módulo

Desde la raíz de tu proyecto, ejecuta:

```bash
php phlex make:module hola_mundo --scope=user
```

La CLI confirmará que se crearon los archivos y que el módulo fue registrado en la base de datos. ¡No necesitas hacer `mkdir` ni `INSERT` manuales!

### Paso 2: Editar la Vista

La CLI ya creó el archivo. Ve a `backend/modules/hola_mundo/ui/hola_mundo.main.ui.php` y añade tu HTML:

```php
<?php
// El guardián de seguridad ya está incluido por la CLI
if (!defined('PHLEXMOD_CORE_PATH')) die('Acceso denegado');
?>

<div class="card">
    <div class="card-header">
        <h3>Módulo Hola Mundo</h3>
    </div>
    <div class="card-body">
        <p>Este módulo fue generado usando la CLI de PHLEXMOD.</p>
        <button id="btnSaludar" class="btn btn-primary">Saludar desde API</button>
        <div id="resultado" class="mt-3"></div>
    </div>
</div>
```

### Paso 3: Crear un Endpoint

Para que el botón "Saludar" funcione, necesitamos un endpoint. Usa la CLI de nuevo:

```bash
php phlex make:endpoint hola_mundo saludo --scope=user
```

Esto creará `backend/modules/hola_mundo/endpoints/saludo.api.php`. Edítalo:

```php
<?php
header('Content-Type: application/json');

$respuesta = [
    'status' => 'success',
    'mensaje' => '¡Hola desde el servidor PHLEXMOD! La hora es: ' . date('H:i:s')
];

echo json_encode($respuesta);
```

### Paso 4: Conectar con JavaScript

Edita `backend/modules/hola_mundo/js/hola_mundo.js`:

```javascript
// Este código se ejecuta automáticamente cuando el módulo se carga
console.log('Módulo Hola Mundo cargado y listo.');

document.getElementById('btnSaludar')?.addEventListener('click', function() {
    // La variable global PATH_ENDPOINTS apunta a la carpeta de endpoints del módulo
    fetch(window.PATH_ENDPOINTS + 'saludo.api.php')
        .then(response => response.json())
        .then(data => {
            document.getElementById('resultado').innerHTML =
                `<div class="alert alert-success">${data.mensaje}</div>`;
        })
        .catch(error => console.error('Error al llamar a la API:', error));
});
```

### Paso 5: Asignar Permisos

Para ver tu módulo, ve al panel de administración y asigna el permiso `hola_mundo` al rol de usuario correspondiente. Una vez hecho, podrás navegar a tu nuevo módulo.

---

## Variables Globales Disponibles

El engine inyecta automáticamente estas variables en JavaScript:

| Variable | Descripción |
| -------- | ----------- |
| `window.PATH_ENDPOINTS` | Ruta a la carpeta `endpoints/` del módulo |
| `window.PATH_UI` | Ruta a la carpeta `ui/` del módulo |
| `window.MODULE_NAME` | Nombre del módulo actual |
| `window.IDENTIDAD` | ID del usuario autenticado |

---

Para principios de diseño avanzados, consulta [Principios de Diseño de Módulos](../../2-arquitectura/module-design-principles.md).
