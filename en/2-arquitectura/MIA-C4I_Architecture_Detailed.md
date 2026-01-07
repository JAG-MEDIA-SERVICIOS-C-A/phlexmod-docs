# MIA-C4I Architecture: Technical Reference Manual

*Version 2.1 (MIA-C4I Hybrid) - January 2026*
*Operating System: PHLEXMOD*

---

## 📋 Executive Summary

**MIA-C4I** is the paradigm that transforms PHLEXMOD from a "framework" into an **Enterprise Application Operating System**. It combines extreme physical isolation (**MIA**) with centralized and authoritative data governance (**C4I**).

### 🎯 Objectives
- **Physical Sovereignty:** Each module is a logical hardware device.
- **Data Governance:** The database is the Kernel that dictates existence.
- **Binary Security:** Permissions are numeric and topological, not programmatic.

---

## 🏛️ 1. Foundations of the Pattern (Body and Soul)

### 1.1. MIA: The Body (Hardware)
MIA (Modular Isolation Architecture) dictates that code on disk is inert and isolated.
- **Strict Isolation:** A module cannot `include` another.
- **Self-Containment:** Everything needed to render the UI is inside the module folder.

### 1.2. C4I: The Soul (Kernel)
C4I (Command, Control, Intelligence) dictates that the truth resides in the database.
- **Dark Matter:** If a file exists on disk but not in `setting_menu`, it is invisible.
- **Context Injection:** The Engine consults the Kernel and then "injects" identity and permissions into the module.

---

## 🔧 2. Implementation Patterns

### 2.1. Pattern: `Sovereign Module`
*Implements: MIA*

Mandatory structure of a module (Hardware):
```text
module-name/
├── js/               # Frontend logic (JavaScript)
├── endpoints/        # Internal APIs (Business Logic)
├── ui/               # Views (HTML/PHP)
└── entry-point.php   # Hardware Connector
```

### 2.2. Pattern: `Context Injection`
*Implements: C4I*

The Engine does not "pass parameters"; it reconstructs reality.
1.  **Token:** Receives encrypted token.
2.  **SQL Validation:** Queries `setting_privilege_user`.
3.  **Materialization:** If valid, `include`s the entry-point and defines environment constants.

### 2.3. Pattern: `Sanitization Zone`
*Implements: Intrinsic Security*

Each endpoint must clean input before processing.
```php
// Sanitization Zone
$id = Sanitizer::integer($_POST['id']);
// End Sanitization Zone
```

---

## 📊 3. Kernel Tables (Command & Control)

### 3.1. `setting_modules` (Hardware Registry)
Defines which physical components are installed.

### 3.2. `setting_menu` (Memory Map)
Defines accessible memory addresses (routes).

### 3.3. `setting_privilege_user` (Access Matrix)
Defines the security topology.

---

## 🚀 4. Evolution Roadmap

| Version | Paradigm | Status | Description |
|---------|----------|--------|-------------|
| v1.0 | MVC | 💀 Deprecated | Traditional PHP Framework. |
| v2.0 | MIA | ⚠️ Legacy | Introduction of modular isolation. |
| v2.1 | MIA-C4I | ✅ Current | Operating System, Dark Matter, Sovereignty. |

---

## 📄 5. License

**MIA-C4I Architecture** is published under the **Creative Commons Attribution 4.0 International (CC BY 4.0)** license.
