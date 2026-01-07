> ⚠️ **TRANSLATION PENDING:** This document is currently in Spanish. Contributions to translate it to English are welcome.

# PhlexMod Framework

PhlexMod es un framework modular basado en la arquitectura MIA (Modular Isolation Architecture), diseñado para crear soluciones web escalables, mantenibles y altamente adaptables.

## Acerca de PhlexMod

PhlexMod implementa el modelo arquitectónico MIA, un enfoque conceptual que trasciende las modas tecnológicas y proporciona una base sólida para el desarrollo de aplicaciones web. A diferencia de los frameworks tradicionales que dependen de tecnologías específicas, MIA se centra en principios fundamentales duraderos que permiten adaptarse a cualquier solución.

### Características Principales

- **Modularidad Total**: Cada módulo es independiente y puede funcionar de manera aislada.
- **Escalabilidad Natural**: Crece orgánicamente según las necesidades del proyecto.
- **Mantenibilidad Superior**: Estructura predecible y consistente en todo el proyecto.
- **Adaptabilidad**: Evoluciona sin obsolescencia y se adapta a nuevas tecnologías.
- **Independencia Tecnológica**: No está atado a versiones específicas de tecnologías.

## Estructura del Framework

```text
/phlexmod/
├── backend/
│   ├── core/                  # Componentes fundamentales
│   │   ├── entities/         # Entidades base del sistema
│   │   └── repositories/     # Acceso a datos core
│   │
│   ├── lib/                  # Librerías y servicios globales
│   │   ├── helpers/         # Funciones auxiliares
│   │   ├── interfaces/      # Interfaces comunes
│   │   ├── traits/         # Traits reutilizables
│   │   └── [servicios]/    # Servicios específicos (PDF, email, etc.)
│   │
│   └── modules/            # Módulos del sistema
│       └── [modulo]/       # Estructura estándar de módulos
│
├── docs/                   # Documentación
│   ├── mia/               # Documentación de la arquitectura
│   └── phlexmod/          # Documentación del framework
│
└── frontend/              # Recursos y componentes frontend
```

### Estructura de Módulos

Cada módulo sigue una estructura consistente:

```text
/modules/[nombre_modulo]/
├── controller/
│   ├── get_[accion].php    # Endpoints para obtener datos
│   └── set_[accion].php    # Endpoints para modificar datos
├── js/
│   └── [modulo].js         # Módulo JavaScript independiente
├── view/
│   └── from_[modulo].php   # Template de renderizado
└── assets/                 # Recursos estáticos (opcional)
    ├── css/
    ├── img/
    └── libs/
```

## Patrones de Implementación

### JavaScript

```javascript
window.modNombre = window.modNombre || {};
modNombre = {
    config: {
        endpoint: {
            // Endpoints centralizados
        }
    },
    init: function() {
        // Inicialización
    }
};
```

### Require.js Integration

```javascript
define(['jquery', 'sweetalert2'], function($, Swal) {
    const modProfile = {
        config: { ... },
        init: function() { ... },
        methods: { ... }
    };
    return modProfile;
});
```

### AJAX Pattern

```javascript
function nombreFuncion() {
    return $.ajax({
        url: modProfile.config.endpoint.nombreEndpoint,
        type: 'GET/POST',
        dataType: 'json'
    })
    .done(function(response) {
        if (response.status) {
            // Success handling
        } else {
            // Business error handling
        }
    })
    .fail(function(jqXHR, textStatus, errorThrown) {
        // Network/server error handling
    });
}
```

## Filosofía MIA: "One Framework, Infinite Solutions"

MIA no es simplemente un framework, sino un modelo arquitectónico que permite:

1. **Productos Independientes**: Soluciones específicas que funcionan de manera autónoma.
2. **Integración Escalable**: Productos individuales que pueden crecer e integrarse en soluciones más grandes.
3. **Niveles de Implementación**: Desde productos individuales hasta ERP/CRM completos.

### Niveles de Implementación

- **Nivel Básico**: Productos individuales y soluciones específicas.
- **Nivel Intermedio**: Combinación de productos e integraciones parciales.
- **Nivel Avanzado**: ERP completo, CRM integrado y soluciones empresariales completas.

## Documentación

Para documentación detallada sobre la arquitectura MIA y la implementación de PhlexMod, consulte el directorio `/docs`.

## Desarrollo

### Requisitos

- PHP 7.4 o superior
- PostgreSQL
- Servidor web compatible (Apache/Nginx)

### Instalación

1. Clone el repositorio
2. Configure su servidor web para apuntar al directorio raíz
3. Importe la estructura de base de datos (si está disponible)
4. Configure los parámetros en `core-config.php`

```php
include_once 'core-config.php';

// Inicializar el framework
$app = new \PhlexMod\Core\Application();
$app->run();
```

## Contribución

Para contribuir al proyecto, por favor siga las directrices de contribución en `/docs/contributing.md`.

## Seguridad

Para información sobre nuestra política de seguridad y cómo reportar vulnerabilidades, consulte [SECURITY.md](/docs/SECURITY.md).

## Licencia

Este proyecto está licenciado bajo la licencia MIT. Consulte el archivo [LICENSE](/LICENSE) para más detalles.

---

*PhlexMod: El framework que evoluciona contigo.*