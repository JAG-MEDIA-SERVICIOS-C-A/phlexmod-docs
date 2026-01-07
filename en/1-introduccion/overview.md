# PHLEXMOD Overview

**Last updated:** December 2024

## What is PHLEXMOD?

PHLEXMOD is a PHP framework that implements the **Modular Isolation Architecture (MIA)**. It is designed for developers looking to build robust, secure, and maintainable enterprise applications without the overhead of traditional frameworks.

Its philosophy centers on returning control to the developer, prioritizing code clarity and long-term stability.

## Key Concepts

Instead of a long list of features, PHLEXMOD is defined by a few powerful concepts:

### 1. Modular Sovereignty (Real Isolation)

Unlike "modules" in other frameworks, PHLEXMOD modules are autonomous universes.

- **Want to disable a feature?** Delete its folder. The system will not break.
- **Want to reuse it?** Copy the folder to another project.
- No ghost dependencies or central registries.

### 2. Antifragile Stability (Dependency Control)

PHLEXMOD rejects the fragility of depending on external repositories in production. All necessary libraries reside within the project repository.

- **Zero `composer install` in production.** Your application will work today and 10 years from now, without surprises.

### 3. Security by Design (Not as an Afterthought)

Security is not an optional layer. Patterns like the `Sanitization Zone` are mandatory and ensure that no unvalidated input reaches business logic.

### 4. High Productivity through Clarity

PHLEXMOD favors explicit code over the "magic" of abstraction. This, combined with tools like the CLI (`phlexmod`), allows for rapid development with fewer errors.

## Typical Use Cases

- Complex enterprise applications (ERP, CRM)
- Internal management systems and self-service portals
- Projects requiring high security and long-term maintainability

## System Requirements

- **PHP:** 8.4 or higher
- **Database:** PostgreSQL 12+
- **Web Server:** Apache or Nginx
- **PHP Extensions:** `pgsql`, `mbstring`, `json`, `curl`

## Next Steps

1. [Installation Guide](./installation.md)
2. [Module Design Principles](../2-arquitectura/module-design-principles.md)
3. [Module Creation with CLI](../6-guias/desarrollo/scaffolding-modulos.md)

---
