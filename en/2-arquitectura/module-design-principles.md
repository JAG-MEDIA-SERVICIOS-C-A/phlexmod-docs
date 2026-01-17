# Module Design Principles

*Last updated: January 2026*

Beyond the technical structure of a module, it is crucial to follow design principles that ensure maintainability and scalability. This guide explains the recommended philosophy for organizing business logic in PHLEXMOD.

---

## The Problem: The "Container" Module

A common anti-pattern in software development is the "container module" (sometimes called a "junk drawer" or "catch-all" module). This is a large module, such as `settings` or `administration`, that groups together features which are not truly related.

**Example of a `settings` container module:**

```text
settings/
├── ui/
│   ├── gestion_usuarios.php
│   ├── configuracion_email.php
│   └── gestion_roles.php
└── endpoints/
    ├── guardar_usuario.api.php
    ├── probar_smtp.api.php
    └── asignar_rol.api.php
```

### Drawbacks

- **Low Isolation:** A bug in `configuracion_email.php` could block user management
- **Strong Coupling:** Code becomes interdependent and hard to maintain
- **Complex Permissions:** If a user can access `settings` but only the user section, you need complex sub-permission logic
- **Poor Scalability:** The module grows until it becomes unmanageable

This pattern directly violates the **Strict Isolation Principle** of the MIA architecture.

---

## The Solution: Normalization with Namespaces

The recommended strategy in PHLEXMOD is **normalization**: each business capability should live in its own sovereign module.

To group related modules logically, we use directories as **namespaces**. The namespace directory does not contain logic; it only organizes other modules.

**Normalized structure:**

```text
backend/modules/
└── admin/                 # Namespace (grouping directory)
    ├── users/             # Sovereign, independent module
    │   ├── users.php
    │   ├── ui/
    │   ├── endpoints/
    │   └── js/
    ├── menu/              # Sovereign, independent module
    │   ├── menu.php
    │   ├── ui/
    │   ├── endpoints/
    │   └── js/
    └── companies/         # Sovereign, independent module
        └── ...
```

### Benefits of Normalization

| Aspect | Benefit |
| ------ | ------- |
| **Real Isolation** | An error in `users` cannot affect `companies` |
| **Granular Permissions** | It is trivial to assign permissions to a full module such as `admin/users` |
| **High Cohesion** | Each module focuses on a single responsibility |
| **Maintainability** | Clearer navigation, smaller files |
| **Scalability** | The `admin` namespace can grow indefinitely |

---

## Golden Rule

> ⚠️ **DO NOT CREATE CONTAINER MODULES.**
>
> Use a "container" pattern only when absolutely necessary to migrate legacy code. For all new development in PHLEXMOD, **always use the namespace structure**.

---

## Layer Separation

Each module must keep a clear separation of responsibilities:

| Layer | Location | Responsibility |
| ----- | -------- | -------------- |
| **Interface** | `ui/` | Pure inert HTML templates. No PHP, no JS and no inline CSS |
| **Communication** | `endpoints/*.api.php` | AJAX entry point. Validates input and returns JSON |
| **Logic** | `endpoints/*.logic.php` | Processes data and applies business rules |
| **Data** | `endpoints/*.db.php` | DB abstraction. SQL and CRUD operations |

---

## Key Principles

1. **One module = One folder:** Everything needed lives inside it
2. **Consistent names:** The main file has the same name as the folder
3. **Automatic loading:** JS and CSS with the module name are auto-loaded by the engine
4. **Independence:** A module does not depend on another module's internal implementation
5. **Portability:** Moving a module to another PHLEXMOD instance should be trivial

---

## Scaffolding and Code Generation

Use the Phlexmod CLI to generate the initial structure of your modules. This ensures that naming and structure conventions are followed from the beginning.

- [Module creation with the CLI](../6-guias/desarrollo/scaffolding-modulos.md)
