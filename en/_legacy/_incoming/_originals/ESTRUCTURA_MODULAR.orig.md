> ⚠️ **TRANSLATION PENDING:** This document is currently in Spanish. Contributions to translate it to English are welcome.

# Estructura Modular de PHLEXMOD Framework

## Organización General del Sistema

El sistema PHLEXMOD Framework está organizado siguiendo una arquitectura modular que separa claramente los módulos administrativos de los módulos de cliente, permitiendo un mantenimiento más sencillo y una mejor escalabilidad.

### Estructura de Directorios Principal

```
/backend/
├── modules/             # Módulos de cliente (funcionalidades específicas del negocio)
└── modules/settings/    # Módulos administrativos (configuración y administración del sistema)
```

## Módulos Administrativos (`/modules/settings/`)

Los módulos ubicados en `/modules/settings/` están destinados a la administración y configuración del sistema. Estos módulos son accesibles únicamente para usuarios con privilegios de administrador (root).

### Estructura Interna de un Módulo Administrativo

Cada módulo administrativo sigue esta estructura:

```
/modules/settings/[nombre_modulo]/
├── js/                  # JavaScript específico del módulo
├── endpoints/           # Endpoints para operaciones de backend
│   └── [modulo]_api/    # Subdirectorio específico para APIs del módulo
└── ui/                  # Interfaces de usuario
    └── [modulo]_ui/     # Subdirectorio específico para componentes UI del módulo
```

### Ejemplo: Módulo de Correo Electrónico

```
/modules/settings/
├── email.php            # Controlador principal del módulo de correo
├── js/
│   └── email.js         # Lógica JavaScript centralizada
├── endpoints/
│   └── mail_api/        # APIs específicas para el módulo de correo
│       ├── get_smtp_config.api.php
│       ├── save_smtp_config.api.php
│       └── ...
└── ui/
    └── mail_ui/         # Componentes UI específicos para el módulo de correo
        ├── mail_config.form.php
        ├── mail_template.table.php
        └── ...
```

#### Convención de Nomenclatura para Módulos Administrativos

- **Archivos principales**: Utilizan nombres descriptivos directos (ej: `email.php`)
- **Subdirectorios de API**: Utilizan el prefijo del módulo seguido de `_api` (ej: `mail_api/`)
- **Subdirectorios de UI**: Utilizan el prefijo del módulo seguido de `_ui` (ej: `mail_ui/`)
- **Archivos de componentes**: Utilizan el prefijo del módulo seguido del tipo de componente (ej: `mail_config.form.php`)

## Módulos de Cliente (`/modules/`)

Los módulos ubicados en `/modules/` contienen funcionalidades específicas del negocio y están destinados a ser utilizados por los usuarios finales del sistema.

### Estructura Interna de un Módulo de Cliente

```
/modules/[nombre_modulo]/
├── js/                  # JavaScript específico del módulo
├── endpoints/           # Endpoints para operaciones de backend
└── ui/                  # Interfaces de usuario
```

## Convenciones de Nomenclatura

### Contra-Extensiones

Para mejorar la organización y claridad del código, se utilizan contra-extensiones que indican el propósito de cada archivo:

#### Para Endpoints

| Contra-Extensión | Propósito | Ejemplo |
|------------------|-----------|---------|
| `.api.php` | Endpoints para comunicación AJAX | `get_smtp_config.api.php` |
| `.db.php` | Operaciones directas con la base de datos | `usuarios.db.php` |
| `.logic.php` | Lógica de negocio y procesamiento | `autenticacion.logic.php` |

#### Para Interfaces de Usuario

| Contra-Extensión | Propósito | Ejemplo |
|------------------|-----------|---------|
| `.form.php` | Formularios | `mail_config.form.php` |
| `.table.php` | Tablas y listados | `mail_template.table.php` |
| `.modal.php` | Ventanas modales | `mail_createTemplate.modal.php` |
| `.manual.php` | Documentación o manuales | `mail.manual.php` |

## Carga Dinámica de Módulos

El sistema utiliza un mecanismo de carga dinámica definido en `engine.php` que:

1. Determina el módulo y contenido solicitado
2. Carga el archivo PHP principal del módulo
3. Carga dinámicamente el archivo JavaScript correspondiente
4. Define variables globales para las rutas de endpoints y UI

```javascript
// Variables globales definidas en engine.php
window.PATH_ENDPOINTS = rutaOriginal.replace('js/', 'endpoints/');
window.PATH_UI = rutaOriginal.replace('js/', 'ui/');
```

## Buenas Prácticas

1. **Encapsulamiento**: Mantener todos los recursos de un módulo agrupados en su directorio correspondiente
2. **Nomenclatura Consistente**: Seguir las convenciones de nomenclatura establecidas
3. **Organización Modular**: Separar claramente los componentes de UI, lógica de negocio y endpoints
4. **Prefijos Descriptivos**: Utilizar prefijos que indiquen claramente la pertenencia al módulo

## Refactorización y Mantenimiento

Al refactorizar o crear nuevos módulos:

1. Mantener la estructura de directorios establecida
2. Seguir las convenciones de nomenclatura
3. Actualizar las referencias en los archivos JavaScript
4. Verificar que las rutas en los archivos PHP sean correctas
5. Documentar cualquier cambio en la estructura o convenciones
