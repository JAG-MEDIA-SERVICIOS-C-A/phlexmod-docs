# Estructura de Módulos (Hardware MIA)

## Anatomía de un Módulo Soberano

En la arquitectura MIA-C4I, un módulo no es solo una carpeta; es un componente de "Hardware Lógico" intercambiable. Cada módulo vive bajo `backend/modules/<namespace>/<modulo>/` y debe ser capaz de funcionar (o fallar) sin derribar el resto del sistema.

### Estructura de Directorios (Estándar Físico)

```text
backend/modules/
└── <namespace>/            # Ej: admin, rrhh (Territorio)
    └── <modulo>/           # Ej: usuarios, empleados (Unidad Soberana)
        ├── <modulo>.php    # ENTRY POINT (Interfaz de Hardware)
        ├── endpoints/      # APIs del módulo (Lógica de Negocio)
        │   ├── *.api.php   # Controladores HTTP
        │   └── ...
        ├── ui/             # Vistas (Interfaz de Usuario)
        │   ├── *.form.php
        │   ├── *.modal.php
        │   └── principal.php
        ├── js/             # Cerebro Frontend (Aislado)
        │   └── <modulo>.js
        ├── css/            # Estilos Específicos
        │   └── <modulo>.css
        └── tests/          # Control de Calidad
```

### El Archivo Entry Point (`<modulo>.php`)
Es el conector físico que el `engine.php` (Kernel) utiliza para "encender" el módulo.
1.  **Validación de Energía:** Verifica `defined('PHLEXMOD_CORE_PATH')`.
2.  **Inicialización:** Carga la UI principal.

```php
// Ejemplo: backend/modules/admin/usuarios/usuarios.php
if (!defined('PHLEXMOD_CORE_PATH')) die('Hardware access denied');
?>
<div class="tab-content">
    <?php include PHLEXMOD_ROUTE_SPECIFIES_MODULES_UI . 'principal.php'; ?>
</div>
```

## Registro y Carga (C4I)

El módulo existe en disco (MIA), pero su existencia lógica es dictada por el C4I (Base de Datos):

1.  **Tabla `setting_modules`**: Define el componente.
2.  **Tabla `setting_menu`**: Define las coordenadas de acceso.
    *   `directorio`: Ubicación física.
    *   `enlace`: Archivo de arranque.

## Convenciones de Soberanía
- **Endpoints:** Deben validar permisos independientemente. No asumir que el usuario ya fue validado por el Engine.
- **UI:** No debe contener lógica de negocio. Solo renderizado.
- **JS:** Debe usar las variables de entorno inyectadas (`PATH_ENDPOINTS`) y no hardcodear rutas absolutas.

## Resolución de Rutas (Inyección de Contexto)
El Engine inyecta la realidad al módulo al momento de cargarlo:
```javascript
// El módulo "despierta" sabiendo dónde están sus extremidades
window.PATH_UI = pathDesencriptado.replace('js/', 'ui/');
window.PATH_ENDPOINTS = pathDesencriptado.replace('js/', 'endpoints/');
```

## Módulos Administrativos vs. Cliente
- **System Space (Admin):** Herramientas de gobierno del sistema (`settings/`).
- **User Space (Negocio):** Funcionalidades productivas (RRHH, Inventario).

## Buenas Prácticas de Aislamiento
- **Cero Dependencias Cruzadas:** Un módulo NUNCA debe hacer `include('../otro_modulo/archivo.php')`. Si necesita datos de otro módulo, debe hacerlo vía BD o API interna.
- **Vendors Locales:** Si un módulo necesita una librería muy específica, considere incluirla dentro de su estructura o cargarla condicionalmente.
