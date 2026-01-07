# Auditoría de Seguridad (OWASP Top 10) — Phlexmod

Fecha: 2026-01-04
Estado: VERIFICADO

## Alcance

Auditoría estática (code review) y verificación dinámica enfocada en:

- Inyección (PHP/Postgres)
- XSS (PHP/JS)
- Seguridad en CLI
- Gestión de sesiones y autenticación
- Instalador web / scripts de instalación

## Metodología

- Revisión de patrones de riesgo (OWASP Top 10) en archivos PHP/JS.
- Identificación de sinks peligrosos (SQL dinámico con `pg_query`, ejecución de comandos, manipulación DOM con `innerHTML`).
- Validación de mitigaciones mediante revisión de cambios aplicados y endurecimiento incremental.

## Hallazgos y Mitigaciones

### SEC-001 — RCE por ejecución arbitraria de comandos

- **Ubicación**: `installs/verificar.php`
- **Riesgo/Impacto**: Crítico (RCE, compromiso del servidor).
- **Estado**: VERIFICADO (2026-01-04)
- **Mitigación aplicada**:
  - Bloqueo post-instalación (si existe `core-config.php`).
  - Eliminación de ejecución arbitraria por parámetro.
  - Validación por lista blanca de chequeos predefinidos.

### SEC-002 — Ejecución de comandos en instalación de dependencias

- **Ubicación**: `instalar_dependencia.php`
- **Riesgo/Impacto**: Crítico (ejecución remota/abuso del sistema).
- **Mitigación aplicada**:
  - Bloqueo post-instalación.
  - Ya no acepta `command` del cliente; solo `package` en lista blanca.

### SEC-003 — SQL Injection por concatenación directa

- **Ubicaciones**:
  - `backend/modules/admin/settings/ui/usuarios/modal_editar.php`
  - `backend/modules/endpoints/consulta.php`
- **Riesgo/Impacto**: Crítico (exfiltración/alteración de datos).
- **Mitigación aplicada**:
  - Migración a `pg_query_params`.
  - Validación/casteo de entradas (por ejemplo IDs numéricos).

### SEC-004 — Instalador legacy y prácticas inseguras

- **Ubicación**: `installs/OLDInstall.php`
- **Riesgo/Impacto**: Alto/Crítico (según accesibilidad en producción).
- **Mitigación objetivo**:
  - Inhabilitar el script legacy (mover a `_legacy` o renombrar a `.php.bak`).
  - Evitar claves fijas y cualquier uso de `sudo` desde PHP.

### SEC-005 — Riesgo de XSS por uso de `innerHTML`

- **Ubicación**: `frontend/templates/login/form_login_2fa.php`
- **Riesgo/Impacto**: Medio (sube si se inyecta contenido no confiable).
- **Mitigación aplicada**:
  - Sustitución de `innerHTML` por `textContent` cuando el contenido es solo texto (contadores/estado).

### SEC-006 — CORS permisivo en endpoints generados por CLI

- **Ubicación**: `tools/console/commands/make_endpoint.php`
- **Riesgo/Impacto**: Medio.
- **Mitigación aplicada**:
  - El template ya no genera `Access-Control-Allow-Origin: *` por defecto.

### SEC-007 — Sesión/Auth: session fixation

- **Ubicación**: `backend/core/auth-manager.php`
- **Riesgo/Impacto**: Medio/Alto.
- **Mitigación aplicada**:
  - Regeneración de ID de sesión en el proceso de login: `session_regenerate_id(true)`.

### SEC-008 — Re-ejecución del instalador

- **Ubicación**: `installs/*` y `instalar_dependencia.php`
- **Riesgo/Impacto**: Alto.
- **Mitigación aplicada**:
  - “Hard lock” de instaladores si existe `core-config.php`.

## Recomendaciones Operativas

- Bloquear `/installs/` a nivel Nginx/Apache en producción.
- Mantener una revisión periódica automatizada (SAST) para:
  - detectar `pg_query` con SQL dinámico,
  - detectar `innerHTML` en plantillas,
  - detectar endpoints con ejecución de comandos.

## Referencias

- Documento de estado consolidado: `docs/6-referencia/SEGURIDAD.md`
