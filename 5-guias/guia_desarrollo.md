# Guía de Desarrollo

## Creación de Archivos JavaScript

Cada módulo debe tener una carpeta `js/` que contenga los archivos JavaScript. El sistema cargará automáticamente un archivo JavaScript si sigue la convención de nombres:

- Para un archivo PHP en el menú (por ejemplo: `usuarios.php`), el sistema cargará automáticamente:
  - `usuarios.js` (si existe)
  - `usuarios.css` (si existe)

Los archivos JavaScript tienen acceso a las siguientes variables globales:

- `window.IDENTIDAD` - ID del usuario
- `window.TIPOROL` - Tipo de usuario
- `window.PATH_ENDPOINTS` - Ruta a endpoints del módulo
- `window.PATH_UI` - Ruta a vistas del módulo
- `window.PATH_CSS` - Ruta a CSS del módulo
- `window.PATH_JS` - Ruta a JS del módulo
- `window.MODULE_NAME` - Nombre del módulo actual

## Creación de Endpoints

Los endpoints deben ubicarse en la carpeta `backend/modules/[nombre_modulo]/endpoints/`. 

### Tipos de endpoints

- **Endpoints AJAX**: Usar el sufijo `.api.php`. Estos endpoints son llamados desde el frontend y devuelven JSON.
- **Endpoints de base de datos**: Usar el sufijo `.db.php`. Contienen operaciones directas con la base de datos.
- **Endpoints de lógica de negocio**: Usar el sufijo `.logic.php`. Contienen la lógica de negocio.

### Ejemplo de endpoint AJAX

```php
<?php
// usuarios.api.php

// Incluir dependencias necesarias

$app->post('/usuarios/crear', function (Request $request, Response $response, array $args) {
    // Lógica para crear un usuario
    $data = $request->getParsedBody();

    // Validar y procesar

    return $response->withJson([
        'success' => true,
        'message' => 'Usuario creado',
        'data' => $newUser
    ]);
});
```

## Módulos con Múltiples Entradas y Submódulos Aislados

En PhlexMod, es posible crear módulos que contienen múltiples puntos de entrada (archivos PHP independientes) y submódulos aislados. Esto permite organizar funcionalidades complejas en unidades independientes.

### Estructura de Directorios

Un módulo con múltiples entradas y submódulos tendría una estructura como:

```
backend/modules/[nombre_modulo]/
├── endpoints/
│   ├── submodulo1.api.php
│   ├── submodulo1.db.php
│   ├── submodulo2.api.php
│   └── ...
├── ui/
│   ├── submodulo1.form.php
│   ├── submodulo1.table.php
│   ├── submodulo2.form.php
│   └── ...
├── js/
│   ├── submodulo1.js
│   ├── submodulo2.js
│   └── ...
└── css/
    ├── submodulo1.css
    ├── submodulo2.css
    └── ...
```

### Puntos de Entrada

Cada punto de entrada es un archivo PHP en el directorio raíz del módulo. Por ejemplo:

- `submodulo1.php`: Punto de entrada para el submódulo 1.
- `submodulo2.php`: Punto de entrada para el submódulo 2.

Estos archivos deben incluir la lógica para cargar los recursos específicos del submódulo (JS y CSS) y la vista inicial.

### Ejemplo de Punto de Entrada

```php
<?php
// submodulo1.php

// Cargar configuración y entorno
require_once __DIR__ . '/../../config.php';

// Establecer variable global para el nombre del submódulo
$currentSubmodule = 'submodulo1';

// Cargar la vista inicial
include PHLEXMOD_ROUTE_SPECIFIES_MODULES_UI . 'submodulo1.view.php';
```

### Aislamiento de Submódulos

Cada submódulo debe ser independiente. Para lograr esto:

1. **JavaScript**: Cada submódulo debe tener su propio archivo JS. El sistema cargará automáticamente `submodulo1.js` cuando se acceda a `submodulo1.php`.
2. **CSS**: De igual manera, se cargará `submodulo1.css`.
3. **Endpoints**: Los endpoints del submódulo deben tener un prefijo en la ruta para evitar colisiones, por ejemplo: `/api/[nombre_modulo]/submodulo1/...`.

### Registro en el Menú

Para agregar los submódulos al menú, editar el archivo de configuración del menú:

```php
// En el archivo de configuración del menú
$menuItems[] = [
    'text' => 'Submódulo 1',
    'href' => '/modulo/submodulo1.php',
    'icon' => 'fa-puzzle-piece',
    'module' => 'nombre_modulo',
    'submodule' => 'submodulo1'
];
```

## Cabecera Informativa

Cada documento debe comenzar con:

1. Título principal con `#`
2. Línea de confidencialidad si aplica
3. Fecha en formato: `Fecha: [fecha completa]`

Ejemplo real de sistema_licencias_propuesta.md:


```markdown
# Propuesta de Sistema de Gestión de Licencias para PhlexMod
**DOCUMENTO CONFIDENCIAL - NO COMPARTIR**
Fecha: 11 de julio de 2025
```

Optionally, after the header, you can include a table of contents and a summary.


```php
// Aquí puedes agregar código PHP adicional si es necesario

```

```markdown
# Propuesta de Sistema de Gestión de Licencias para PhlexMod
**DOCUMENTO CONFIDENCIAL - NO COMPARTIR**
Fecha: 11 de julio de 2025

 
