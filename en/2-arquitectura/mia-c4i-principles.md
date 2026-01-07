# MIA-C4I Principles (Body and Soul)

The PHLEXMOD architecture is a hybrid between physical sovereignty (**MIA**) and centralized data governance (**C4I**).

## 1. MIA (Modular Isolation Architecture) - The Body

MIA defines the physics of the system. It is based on the premise that robustness comes from isolation, not interconnection.

- **Territorial Sovereignty:** A module (`/backend/modules/sales`) is a physical territory. If you delete its folder, it disappears from the physical universe.
- **Execution Independence:** No module can block the execution of another due to a syntax error. The Engine loads modules in isolation.
- **Self-Containment:** Everything the module needs (UI, API, JS) is within its territory.

## 2. C4I (Command, Control, Intelligence) - The Soul

C4I defines the metaphysics of the system. Physical files are inert without the will of the database.

- **Command (Will):** The database is the Kernel. It decides which modules are "active". A file on disk without a record in `setting_modules` is **Dark Matter** (it exists but doesn't matter).
- **Control (Authority):** Security is topological (numeric IDs) and declarative (SQL). Security is not programmed in the controller; it is declared in the `setting_privilege_user` table.
- **Intelligence (Truth):** Code is ephemeral; data is eternal. Critical business logic must reside close to the data (SQL or PHP logic very close to the data layer).

## 3. Principles of Survival

### Dark Matter
Files not registered in the database are invisible to the Engine. This allows for "beta" versions of modules in production that no one can see or execute until they are granted a "breath of life" (DB registration).

### Context Injection
The module does not "seek" its configuration. The Engine "injects" reality into the module at load time. The module is born knowing who the user is and what permissions they have.

### Zero Magic
- No global Autoloaders scanning the entire disk.
- No reflective Dependency Injection consuming unnecessary CPU.
- Everything is explicit. If a file is loaded, it is because a line of code or a database record specifically ordered it.
