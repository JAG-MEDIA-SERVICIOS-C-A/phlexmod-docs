# Estructura de Módulos en PHLEXMOD

## Visión general
Los módulos en PHLEXMOD siguen una anatomía estándar para mantener consistencia, escalabilidad y mantenibilidad. Cada módulo vive bajo `backend/modules/<modulo>/` (o opcionalmente `backend/modules/<namespace>/<modulo>/`) y se compone de carpetas bien definidas para `ui/`, `endpoints/`, `js/`, `css/` y `tests/`.

```text
backend/modules/
└── <modulo>/               # Ej: settings, binance, payments
    ├── endpoints/          # APIs del módulo (comunicación AJAX)
    │   ├── *.api.php       # Controladores HTTP (entrada/salida JSON)
    │   ├── *.db.php        # Acceso a datos (opcional)
    │   └── *.logic.php     # Reglas de negocio (opcional)
    ├── ui/                 # Vistas del módulo (solo HTML/PHP)
    │   ├── *.form.php      # Formularios
    │   ├── *.table.php     # Tablas/Listados
    │   └── *.modal.php     # Modales
    ├── js/                 # JavaScript del módulo
    ├── css/                # Estilos del módulo
    ├── tests/              # Pruebas (Feature/Unit)
    ├── module.json         # Manifiesto del módulo (roadmap)
    └── README.md           # Documentación local del módulo
```

## Convenciones de nomenclatura
- **Endpoints**
  - `.api.php`: entrada/salida HTTP (JSON). Ej: `empleados.getUnidades.api.php`.
  - `.db.php`: consultas y operaciones de datos encapsuladas.
  - `.logic.php`: reglas de negocio reutilizables.
- **UI**
  - `.form.php`, `.table.php`, `.modal.php`: responsabilidades claras por tipo de vista.
- **JS/CSS**
  - Un archivo principal por módulo (`js/index.js`), más fragmentos según funcionalidad.

## Resolución de rutas y carga dinámica
- `backend/engine.php` resuelve navegación y determina las rutas base.
- `ModuleLoader` (en `frontend/assets/js/module-loader.js`) configura el entorno JS dinámicamente:
```javascript
// Ejemplo de configuración automática por ModuleLoader
window.PATH_UI = pathDesencriptado.replace('js/', 'ui/');
window.PATH_ENDPOINTS = pathDesencriptado.replace('js/', 'endpoints/');
```
- Las vistas usan `PATH_ENDPOINTS` para AJAX y `PATH_UI` para incluir fragmentos.

## Módulos administrativos vs. cliente
- **Administrativos** (ej. `settings/`): contienen herramientas de gestión, configuración global (SMTP, usuarios, menús, TOTP, etc.).
- **Cliente/Negocio**: funcionalidades de dominio específico (RRHH, Finanzas, Inventario, etc.).

## Buenas prácticas
- **Separación estricta**: UI ≠ lógica ≠ acceso a datos.
- **No scripts inline** en vistas: los vendors se cargan por `vendor_loader.php` o helpers; el JS del módulo vive en `js/`.
- **Eventos y asincronía**: manejar dependencias con eventos encadenados y considerar Promesas para mejor manejo de errores/flujo.
- **Mensajes de error consistentes**: feedback claro al usuario, logs en servidor para diagnóstico.
- **Pruebas**: agregar pruebas de endpoints críticos en `tests/`.

## Manifiesto del módulo (roadmap)
En el roadmap se introduce `module.json` para que el engine descubra y registre módulos automáticamente.

Ejemplo:
```json
{
  "name": "rrhh/empleados",
  "displayName": "Gestión de Empleados",
  "version": "1.0.0",
  "entry": {
    "ui": "ui/ficha_registro.from.php",
    "routes": [{ "path": "/rrhh/empleados", "ui": "ui/ficha_registro.from.php" }]
  },
  "endpoints": [
    { "name": "getUnidades", "file": "endpoints/empleados.getUnidades.api.php", "method": "POST", "permission": "rrhh.empleados.view" }
  ],
  "assets": { "js": ["js/index.js"], "css": ["css/index.css"] },
  "vendors": ["jquery", "sweetalert2"],
  "permissions": ["rrhh.empleados.view", "rrhh.empleados.edit"],
  "dependencies": { "php": ">=8.1", "phlexmod": ">=1.0.0" }
}
```

## Integración con vendors
- Catálogo maestro en `vendor_loader.php` y carga transversal en `frontend/templates/sistema/header.php`.
- Recomendación: vendors pesados (editores, exportadores, mapas) cargarlos en la vista del módulo que los necesita (lazy/condicional) o declararlos en el manifiesto.

## Ejemplo de flujo en un módulo (RRHH > Empleados)
1. Usuario selecciona `Ente` → evento `change`.
2. JS `getDependencias()` llama a `endpoints/empleados.getDependencias.api.php`.
3. Selección de `Dependencia` dispara carga de `Departamentos` → `getDepartamentos()`.
4. Selección de `Departamento` dispara carga de `Unidades` → `getUnidades()`.
5. Selección de `Unidad` dispara carga de `Cargos` → `getCargos()`.
6. Guardado vía `empleados.save.api.php` con validaciones y feedback.

## Checklist de calidad por módulo
- Endpoints con validación de entrada y manejo de errores.
- Vistas sin lógica de negocio (solo presentación).
- JS sin dependencias globales innecesarias, con eventos claros.
- Vendors cargados solo cuando se usan.
- Documentación mínima en `README.md` del módulo.
