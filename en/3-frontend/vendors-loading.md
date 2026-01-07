> ⚠️ **TRANSLATION PENDING:** This document is currently in Spanish. Contributions to translate it to English are welcome.

# Gestión de Dependencias Frontend (Vendor Loader)

PHLEXMOD utiliza un sistema centralizado para la carga de bibliotecas JavaScript y CSS, gestionado por el archivo `vendor_loader.php` en la raíz del proyecto. Este enfoque elimina la necesidad de rutas "hardcodeadas" en las vistas y facilita la gestión de versiones.

## Uso Básico

Para cargar una librería en cualquier vista o plantilla (por ejemplo, en `header.php` o dentro de un módulo), utiliza la función `load_vendor_scripts()`:

```php
<?php
// Cargar jQuery
echo load_vendor_scripts('jquery');

// Cargar Bootstrap
echo load_vendor_scripts('bootstrap');

// Cargar Leaflet (Mapas)
echo load_vendor_scripts('leaflet');
?>
```

Esta función devolverá las etiquetas HTML necesarias (`<script>` o `<link>`) con las rutas correctas preconfiguradas.

## Ubicación de Archivos

- **Definición del Loader:** `/var/www/html/phlexmod/vendor_loader.php`
- **Archivos Físicos:** `frontend/vendors/` (librerías de terceros) y `frontend/assets/` (recursos propios).
- **Constantes:** Se basa en `PHLEXMOD_VENDOR_PATH` y `PHLEXMOD_ASSETS_PATH` definidas en `core-config.php`.

## Política para librerías pesadas (TinyMCE)

- Carga preferente desde CDN con fallback local:
  - Si existe `frontend/vendors/tinymce/tinymce.min.js`, se usa local.
  - Si no existe, se sirve desde CDN (`jsdelivr`) automáticamente.
- Implementación en `vendor_loader.php:154`.
- Beneficio: reduce conflictos de licencia al no redistribuir por defecto y mantiene portabilidad en entornos air‑gapped.

## Librerías Disponibles

## Ejemplo de uso de TinyMCE

```php
<?php
require_once __DIR__ . '/../../vendor_loader.php';

// Cargar TinyMCE (CDN por defecto, fallback local si existe en frontend/vendors/tinymce)
echo load_vendor_scripts('tinymce');
?>
<textarea id="editor"></textarea>
<script>
  document.addEventListener('DOMContentLoaded', function() {
    if (typeof tinymce !== 'undefined') {
      tinymce.init({
        selector: '#editor',
        plugins: 'link table lists code',
        toolbar: 'undo redo | bold italic | alignleft aligncenter alignright | bullist numlist | link table | code',
        menubar: false
      });
    }
  });
  </script>
```

Algunas de las librerías preconfiguradas incluyen:

- **Core:** `jquery`, `popper`, `bootstrap`, `lodash`
- **UI:** `fontawesome`, `unicons`, `feather-icons`, `sweetalert2`, `simplebar-js`
- **Datos:** `datatables`, `echarts`
- **Mapas:** `leaflet`, `leaflet-markercluster`, `leaflet-colorfilter`
- **Utilidades:** `dayjs`, `imask`, `typed-js`

## Agregar una Nueva Librería

Actualmente, el registro de nuevas librerías es manual. Para agregar una:

1. Coloca los archivos de la librería en `frontend/vendors/<nombre_libreria>/`.
2. Edita `vendor_loader.php`.
3. Agrega una entrada al array `$scripts`:

```php
'mi-nueva-lib' => [
    "<link rel='stylesheet' href='" . PHLEXMOD_VENDOR_PATH . "mi-nueva-lib/style.css'>",
    "<script src='" . PHLEXMOD_VENDOR_PATH . "mi-nueva-lib/script.js'></script>"
]
```

4. Úsala en tus vistas: `echo load_vendor_scripts('mi-nueva-lib');`
