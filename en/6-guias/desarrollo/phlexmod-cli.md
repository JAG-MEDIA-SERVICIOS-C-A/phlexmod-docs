# PHLEXMOD Development CLI (`phlexmod`)

**Last updated:** January 2026

The `phlexmod` tool is the main way to automate development and maintenance tasks in a PHLEXMOD project. Using it reduces manual work and avoids human error.

The CLI talks to the MIA-C4I Engine as an interpreter for your commands, while the database remains the Command Center that governs privileges and configuration.

## Basic Usage

All commands are executed from the root directory of your project.

```bash
# List all available commands
./phlexmod help

# General syntax
./phlexmod <command> [arguments] [--options]
```

## Available Commands

| Command | Description |
| ------- | ----------- |
| `help` | Shows the list of all available commands and how to use them |
| `make:module` | Creates the full structure of a new module and registers it in the database |
| `make:endpoint` | Generates a secure API file inside an existing module |
| `module:health` | Audits all modules to verify structure and registration in the DB |
| `headers:scan` | Scans files to standardize license headers |
| `locale:audit` | Lists translation keys that are used/unused in code and locale files |
| `locale:sync` | Propagates new keys from es_VE.json to the rest of the locales |

---

## Usage Examples

### Create a user-scope module

This creates a module named `inventario` inside the `backend/modules/` folder.

```bash
./phlexmod make:module inventario --scope=user
```

### Create an admin module

This creates a module named `reportes` inside the `admin` namespace (in `backend/modules/admin/`).

```bash
./phlexmod make:module reportes --scope=admin
```

### Create an endpoint

This generates the `get_stock.api.php` file inside the `endpoints/` folder of the `inventario` module.

```bash
./phlexmod make:endpoint inventario get_stock --scope=user
```

### Audit modules

Recommended before committing changes, to ensure you have not broken any MIA-C4I or structural conventions.

```bash
./phlexmod module:health
```

---
