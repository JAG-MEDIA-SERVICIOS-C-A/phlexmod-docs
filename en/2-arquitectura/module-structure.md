# Module Structure (MIA Hardware)

## Anatomy of a Sovereign Module

In the MIA-C4I architecture, a module is not just a folder; it is an interchangeable "Logical Hardware" component. Each module lives under `backend/modules/<namespace>/<module>/` and must be capable of functioning (or failing) without bringing down the rest of the system.

### Directory Structure (Physical Standard)

```text
backend/modules/
└── <namespace>/            # Ex: admin, hr (Territory)
    └── <module>/           # Ex: users, employees (Sovereign Unit)
        ├── <module>.php    # ENTRY POINT (Hardware Interface)
        ├── endpoints/      # Module APIs (Business Logic)
        │   ├── *.api.php   # HTTP Controllers
        │   └── ...
        ├── ui/             # Views (User Interface)
        │   ├── *.form.php
        │   ├── *.modal.php
        │   └── principal.php
        ├── js/             # Frontend Brain (Isolated)
        │   └── <module>.js
        ├── css/            # Specific Styles
        │   └── <module>.css
        └── tests/          # Quality Control
```

### The Entry Point File (`<module>.php`)

This is the physical connector that `engine.php` (Kernel) uses to "power on" the module.

1.  **Power Validation:** Checks `defined('PHLEXMOD_CORE_PATH')`.
2.  **Initialization:** Loads the main UI.

```php
// Example: backend/modules/admin/users/users.php
if (!defined('PHLEXMOD_CORE_PATH')) die('Hardware access denied');
?>
<div class="tab-content">
    <?php include PHLEXMOD_ROUTE_SPECIFIES_MODULES_UI . 'principal.php'; ?>
</div>
```

## Registration and Loading (C4I)

The module exists on disk (MIA), but its logical existence is dictated by C4I (Database):

1.  **Table `setting_modules`**: Defines the component.
2.  **Table `setting_menu`**: Defines access coordinates.
    - `directorio`: Physical location.
    - `enlace`: Boot file.

## Sovereignty Conventions

- **Endpoints:** Must validate permissions independently. Do not assume the user was already validated by the Engine.
- **UI:** Must not contain business logic. Rendering only.
- **JS:** Must use injected environment variables (`PATH_ENDPOINTS`) and not hardcode absolute paths.

## Route Resolution (Context Injection)

The Engine injects reality into the module at load time:

```javascript
// The module "wakes up" knowing where its limbs are
window.PATH_UI = pathDesencriptado.replace('js/', 'ui/');
window.PATH_ENDPOINTS = pathDesencriptado.replace('js/', 'endpoints/');
```

## Administrative vs. Client Modules

- **System Space (Admin):** System governance tools (`settings/`).
- **User Space (Business):** Productive functionalities (HR, Inventory).

## Isolation Best Practices

- **Zero Cross-Dependencies:** A module MUST NEVER `include('../other_module/file.php')`. If it needs data from another module, it must do so via DB or internal API.
- **Local Vendors:** If a module needs a very specific library, consider including it within its structure or loading it conditionally.
