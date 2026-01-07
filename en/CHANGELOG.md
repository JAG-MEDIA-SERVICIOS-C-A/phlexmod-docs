> ⚠️ **TRANSLATION PENDING:** This document is currently in Spanish. Contributions to translate it to English are welcome.

# CHANGELOG - PHLEXMOD Framework

## v2.0.1 - 2025-12-30

### 🎯 Versionamiento y Sincronización
- **Estandarización completa** de cabeceras en todo el framework
- **123 archivos** sincronizados a `v2.0.1` (81 PHP + 36 JS + 6 Tools)
- **Herramientas corregidas**: `scan_headers.php`, `generar_cabecera.php`, comandos CLI
- **Sin duplicados** ni inconsistencias en versionamiento

### 🔧 Mejoras Técnicas
- **Headers profesionales** en todos los archivos del framework
- **Formato consistente** `@version    v2.0.1` en todo el código
- **Generación de código** con versión automática y correcta
- **Documentación actualizada** con versión actual

### 📈 Documentación
- **README.md** actualizado con versión v2.0.1
- **Status cambiado** de Beta a Production Ready
- **Badges actualizados** para reflejar estado actual

## Aviso Importante

**Esta rama (main) es la versión histórica original del repositorio FlexMod, con último commit del 13 de marzo de 2025.**

A partir del 9 de julio de 2025, el desarrollo activo ha sido transferido a la rama `new-main` bajo el nuevo nombre **Phlexmod**. Se recomienda utilizar la rama `new-main` para cualquier trabajo futuro.

### Motivo del Cambio

La transición de FlexMod a Phlexmod representa una evolución significativa del proyecto, con mejoras en la arquitectura y funcionalidades. La rama `new-main` contiene la implementación más reciente y completa del framework.

### Información del Repositorio

- **Nombre Original:** FlexMod (esta rama)
- **Nuevo Nombre:** Phlexmod (rama `new-main`)
- **URL del Repositorio:** [Phlexmod Repository](https://github.com/JAG-MEDIA-SERVICIOS-C-A/Phlexmod)

## Estado de esta Rama

Esta rama se mantiene por razones históricas y de referencia. Contiene la versión original del proyecto FlexMod antes de la transición a Phlexmod.

### Cronología

#### Creación y Desarrollo Inicial

- **Creación del repositorio:** 2 de noviembre de 2024
- **Primeros commits y merges:** Noviembre de 2024 a enero de 2025

#### Fase de Configuración y Documentación (Febrero 2025)

- **9 de febrero:** Cambios principales (force push)
- **16-18 de febrero:** Configuración de GitHub templates, PHPUnit y CI
- **18-21 de febrero:** Extensa documentación, mejoras de calidad de código, configuración de CI/CD
- **21 de febrero:** Mejoras de workflow, diagramas y automatización

#### Sincronizaciones desde Producción

- **22 de febrero:** Primera sincronización desde producción
- **25 de febrero:** Actualización masiva (1043 commits)
- **27 de febrero:** 479 commits desde producción
- **28 de febrero:** 282 commits desde producción

#### Últimas Actualizaciones Registradas en Git

- **13 de marzo:** Actualización masiva (3792 commits)
- **Último commit:** f7249d53 "feat: Actualización completa del sistema"

#### Desarrollo Posterior (No Registrado en Git)

- **Desarrollo continuo:** Marzo a junio de 2025 (según fechas de archivos)
- **Últimas modificaciones en backend/core:** 13 de junio de 2025

### Componentes Principales

- Estructura base del proyecto con directorios: `backend`, `docs`, `frontend`
- Componentes en `backend/core`: autenticación, configuración, navegación, y utilidades
- Módulos organizados por funcionalidades en `backend/modules`
- Directorio `.resource` con recursos para la migración (presente solo en esta rama)

## Transición a Phlexmod

Para acceder a la versión actual del proyecto:

1. Cambia a la rama `new-main` : `git checkout new-main`
2. Consulta el CHANGELOG.md en esa rama para más detalles sobre la transición y el estado actual

---

*Este documento sirve como referencia histórica para la rama original del proyecto.*

## Actualizaciones Recientes (Phlexmod Refactoring - Enero 2025)

### Refactorización de Arquitectura

- **Reorganización de Módulos:**
  - Migración de módulos base (`companies`, `users`, `menu`, etc.) de `backend/modules/settings/` a `backend/modules/admin/`.
  - Estandarización de estructura de directorios (`endpoints`, `js`, `ui`, `css`) para todos los módulos.
- **Limpieza:** Eliminación de estructura antigua y archivos duplicados.

### Seguridad y Proxy

- **Ocultamiento de Rutas:** Implementación completa de sistema proxy para ocultar rutas reales del servidor (`/var/www/html/...`) al cliente.
- **Proxy Dinámico (`load_resource.php`):**
  - Soporte para carga de assets (JS, CSS, Imágenes).
  - Soporte para ejecución de Endpoints PHP con métodos POST y GET dinámicos.
  - Validación de seguridad y prevención de Path Traversal.
- **Mapeo de Sesión:** Uso de tokens en sesión para resolver rutas reales sin exponerlas.

### Mejoras Técnicas

- **Path Standards:** Adopción de `__DIR__` para referencias de archivos en PHP.
- **Correcciones:** Solución a errores de base de datos (PostgreSQL), configuración de DataTables y accesibilidad en modales.

## Actualizaciones Recientes (Diciembre 2025)

- **Compatibilidad PHP:** Alineación del proyecto a `PHP >= 8.4` y actualización de CI.
- **Gobernanza de vendors:** Creación de `VENDORS-SBOM.json` con origen, licencia y versión/commit.
- **TinyMCE:** Conversión a submódulo (`frontend/vendors/tinymce`) y política de carga:
  - CDN por defecto (jsdelivr) con fallback local si el submódulo está presente.
  - Documentado en `docs/development/vendors-loading.md`.
- **Gestor de Plantillas de Correo:** Integración de TinyMCE en `admin/email`, manteniendo compatibilidad con `window.editor` y actualizando textos de ayuda en modales.
- **CI:** Mejora del workflow (`.github/workflows/ci.yml`):
  - Inicializa submódulos, lint paralelo en `backend` y `frontend`, PHPUnit condicional.
- **Seguridad:** Añadido workflow de CodeQL para análisis de JavaScript (`.github/workflows/codeql.yml`).
- **Dependabot:** Configurado para `github-actions` y `gitsubmodule` (`.github/dependabot.yml`).
- **SMTP Test:** Endpoint de prueba con modo `dry_run` para validar sin enviar correo (`backend/modules/admin/email/endpoints/test_smtp_config.api.php`).
- **Conciliación BDV:**
  - Agregado log de respuesta completa en `BdvConciliacionService::consultarConciliacionMasiva` para facilitar depuración con soporte técnico.

### Release 2.01 (Diciembre 2025)

- Estandarización de cabeceras profesionales (JS/PHP) con `@version 2.01`.
- Herramientas en `tools/`:
  - `scan_headers.php` para escaneo y aplicación automática (`--apply`, `--bumpVersion`).
  - `generar_cabecera.php` para generación parametrizada de cabeceras.
- Hook `pre-commit` para aplicar cabeceras y versión en todos los módulos `admin` y `user`.
- Limpieza de endpoints `test_*` no referenciados en `bdv_portal`; mantenimiento de pruebas usadas en `email`, `settings/mail_api`, `totp` y `dist/lite`.
- Inclusión de `tools/` en `.gitignore` como herramientas locales de desarrollo.
- Publicación:
  - Rama `main` actualizada a `release/2.01` con respaldo `backup/main-pre-2.01`.
  - Tag `v2.01` creado y publicado.

## [Unreleased]

## 2025-12-27 — Security Hardening & Structural Reorganization

### Changed (Security)

- Endurecimiento de seguridad (OWASP): bloqueo estricto del instalador post-configuración, mitigación de SQL injection con `pg_query_params`, ajustes de sesión, y refactor puntual de `innerHTML` a `textContent` cuando aplica.
- Inserción de cabeceras de seguridad globales en entrypoints web.
- **Migración de validación CSRF del núcleo de encriptación (`encryption.php`) al Controlador Frontal (`frontend/index.php`).**
- **Sincronización del ciclo de vida de autenticación: generación de CSRF token fresco después de cada `session_regenerate_id(true)` en `auth-manager.php`.**
- Reorganización estructural de `docs/` y consolidación de documentación de seguridad.

### Added

- Documentación de CLI de desarrollo en `docs/5-guias/desarrollo/phlexmod-cli.md`.
  - Fuente: `phlexmod`, `tools/console/commands/help.php`, `tools/console/commands/make_module.php`, `tools/console/commands/make_endpoint.php`, `tools/console/commands/module_health.php`.
- Documentación del cargador dinámico en `docs/3-frontend/module-loader.md`.
  - Fuente: `frontend/assets/js/module-loader.js`, `backend/engine.php`, `backend/core/api-endpoint.php`.
- Documentación del flujo backend→frontend en `docs/4-backend/flujo-php-js.md`.
  - Fuente: `backend/engine.php`, `backend/core/api-endpoint.php`, `vendor_loader.php`.

### Changed (Docs)

- Reorganización de la carpeta `docs/` priorizando estructura numerada (1–7) y archivando estructura previa bajo `_legacy/old_structure_en/`.
- Ajuste de referencias de instalación para usar scripts reales en `installs/db/*.sql` (en lugar de `database/schema.sql`).
- Alineación de la referencia del módulo de correo a `backend/modules/admin/email/`.
