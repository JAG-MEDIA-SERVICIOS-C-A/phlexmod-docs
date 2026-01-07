# Technical and Development Documentation - PHLEXMOD

This document consolidates technical information, development guidelines, and changelogs for the PHLEXMOD framework.

## 1. Core Architecture (`backend/core/`)

The core manages fundamental logic, security, and cross-cutting utilities.

### MIA Principle (Self-Contained Core)

- **Critical Security** does **not depend on session state** (cookies/`$_SESSION`).
- Sensitive controls (e.g., anti-brute force) are **stateless** from the client's perspective.
- The source of truth for attempts, locks, and audits is **persistence** (PostgreSQL).
- Session is used only for **application state** (UX) once authenticated.

#### Anti-Brute Force (Stateless)
- **Location**: `backend/core/auth-manager.php`
- **Mechanism**:
  - `adaptiveDelay()` calculates delay based on recent failures in `security_login_attempts` (5-minute window).
  - Locks are persisted in `security_login_locks` and queried by IP.
  - The client cannot "reset" the delay by clearing cookies.

### `proxy-helper.php`

- **Location:** `backend/core/proxy-helper.php`
- **Function:** Generates secure, obfuscated URLs for static resources (JS, CSS, images).
- **Usage:** Instead of linking directly, use `get_proxied_asset_url($path)`. This generates a link pointing to `load_resource.php` with an encrypted token.
- **Security:** Validates that the requested file is within allowed paths (`frontend/`, `vendors/`, etc.) and prevents unauthorized direct access.

### `core-config.php`

- **Location:** Project root.
- **Function:** Defines critical global constants like system paths, DB credentials, and encryption keys.
- **Important:** Defines `PHLEXMOD_CORE_PATH`, `PHLEXMOD_MODULES_PATH`, etc.

---

## 2. System Engine (`backend/engine.php`)

The `engine.php` file acts as the Front Controller for business logic within the admin panel.

- **Workflow:**
  1. Receives encrypted parameters `module` and `content` via GET/POST.
  2. Decrypts parameters to identify the module and requested action.
  3. Verifies user permissions against the database (`setting_privilege_user`).
  4. Dynamically defines resource paths (`PHLEXMOD_ROUTE_SPECIFIES_MODULES_UI`, etc.).
  5. Loads the main module view and initializes the JavaScript `ModuleLoader`.

---

## 3. Frontend and Resource Management

### `load_resource.php`

- **Location:** `frontend/load_resource.php`
- **Role:** Secure file proxy. The only public entry point for serving protected assets.
- **Operation:**
  1. Receives a token (`r`) or encrypted path.
  2. Validates user session.
  3. Checks if the file exists and is within allowed directories (`whiteList`).
  4. Serves the file with correct MIME headers.

### `vendor_loader.php`

- **Location:** `frontend/vendor_loader.php`
- **Role:** Frontend dependency manager. Centralizes third-party libraries (Bootstrap, jQuery, FontAwesome).
- **Usage:** Defines `load_vendor_scripts($name)` which returns the necessary HTML `<script>` or `<link>` tags, using `proxy-helper` to obfuscate paths.

---

## 4. Module Development (`backend/modules/`)

### Module Structure
Example: `backend/modules/admin/menu/`
```text
menu/
├── css/            # Module-specific styles
├── endpoints/      # PHP scripts for AJAX requests (Internal API)
├── js/             # JavaScript logic
├── ui/             # Partial HTML/PHP views
└── menu.php        # Controller or entry point
```

### Guide to Creating a New Module
1. **Create Directory:** In `backend/modules/your_module/`.
2. **Structure:** Create subfolders `js`, `ui`, `endpoints`.
3. **Registry:** The module must be registered in the database (`setting_menu`) to be accessible by `engine.php`.
4. **Frontend Development:**
   - Use `ui/` for forms and tables.
   - Use `js/` for logic. `engine.php` will automatically load defined scripts.
   - For AJAX calls, point to your scripts in `endpoints/`.
   - **Important:** When using `fetch` or `ajax` from JS, use relative paths like `../endpoints/my_script.php`. `load_resource.php` will resolve it correctly.

---

## 5. Critical Paths Summary

- **Core Backend:** `/var/www/html/phlexmod/backend/core/`
- **Modules:** `/var/www/html/phlexmod/backend/modules/`
- **Frontend Assets:** `/var/www/html/phlexmod/frontend/assets/`
- **Proxy Script:** `/var/www/html/phlexmod/frontend/load_resource.php`
