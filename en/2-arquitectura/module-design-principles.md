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

## The Concept: JS-Defined Modularity (MIA-C4I)

Unlike the traditional MVC pattern where the Controller orchestrates the View, in PHLEXMOD **modularity and namespace are defined exclusively by the JavaScript layer** in conjunction with data communication.

The structure is not "Model-View-Controller", but **Command-Resource-Data**:

1.  **Command (JS):** The JS file (`modAdminUsuarios`) is the "Driver". It defines the namespace, configuration, and orchestrates everything.
2.  **Data (Endpoints):** The communication and query layer. Responds to JS.
3.  **Resource (UI):** Inert templates. **They have no namespace**. They are simple HTML files loaded on demand by the JS.

### Why "The UI has no Namespace"

Files in `ui/` are passive resources. They don't know who they are or where they are. It is the JS file that decides:
*"Load the resource `modal.create.ui.php` from `PATH_UI` and inject it into the DOM".*

This ensures that the interface is **100% inert** and decoupled from logic.

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
| **Driver (Namespace)** | `js/*.js` | **Defines the Module**. Orchestrates UI and Data. |
| **Resource (Inert)** | `ui/` | Dumb HTML templates. Loaded by JS. |
| **Communication** | `endpoints/*.api.php` | JSON API. Query and Transaction. |
| **Logic/Data** | `endpoints/*.php` | Business rules and SQL. |

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
