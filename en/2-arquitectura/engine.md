# The Engine: Metadata Interpreter

The `engine.php` file is not a traditional router or a front controller. In the C4I architecture, it acts as the **Metadata Interpreter** connecting the Kernel's will (Database) with the passive hardware (PHP Files).

## 1. Operating Philosophy

The Engine does not "decide"; the Engine "consults".
Its function is purely topological: verifying if a requested coordinate (Navigation Token) has a valid correspondence in the database privilege space.

### Context Injection Cycle
1.  **Reception:** The client sends an Encrypted Token (Coordinate).
2.  **Decryption:** The Engine reveals `menu_id` and `user_id`.
3.  **Existential Query (C4I):**
    *   Asks the Kernel: "Does an intersection exist between this User and this Menu in `setting_privilege_user`?"
    *   If **NO**: The process stops. The requested file is not loaded. For the user, it does not exist.
    *   If **YES**: The Engine injects the context (`$Path_UI`, `$Path_Endpoints`) and materializes the file via `include`.

## 2. Differences with an MVC Router

| Traditional MVC Router | PHLEXMOD Engine (C4I) |
| :--- | :--- |
| Maps URL `/users/edit/1` to `UserController::edit` | Maps Encrypted Token to `menu_id` |
| Defines routes in files (`routes.php`) | Defines routes in Database (`setting_menu`) |
| Loads middleware chains | Executes a single binary SQL validation |
| Manages session state | Reconstructs state on every request (Stateless) |

## 3. Environment Variable Injection

Once the module is "materialized", the Engine injects its operational reality:

```php
// The module doesn't know where it is until the Engine tells it
$Path_UI = ".../modules/admin/usuarios/ui/";
$Path_Endpoints = ".../modules/admin/usuarios/endpoints/";
```

This allows the module to be **Sovereign** (MIA). It does not need to know the global system structure; it only needs to know its own borders, which are dynamically defined by the Engine.

## 4. Error Management as "Non-Existence"

In PHLEXMOD, a permission error is not an exception; it is an existential void.
*   If a user attempts to access an Admin module without permissions, the system does not throw an "Access Denied"; it simply does not find the route. Security is by omission.
