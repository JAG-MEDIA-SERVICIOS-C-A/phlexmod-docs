> ⚠️ **TRANSLATION PENDING:** This document is currently in Spanish. Contributions to translate it to English are welcome.

# Roadmap de PHLEXMOD

Esta sección detalla las características planificadas para futuras versiones del framework, enfocadas en mejorar la automatización, la seguridad y la experiencia del desarrollador.

## Corto Plazo (v2.1)

- **Manifiesto de Módulos (`module.json`):**
  - Introducción del archivo de configuración declarativa por módulo.
  - Definición de dependencias, permisos y assets requeridos.
  - [Ver propuesta actualizada](../../2-arquitectura/module-design-principles.md)

- **Carga Condicional de Assets:**
  - Optimización del `vendor_loader.php` para cargar librerías pesadas solo cuando el módulo activo lo requiera (leído desde `module.json`).

## Mediano Plazo (v2.2 - v2.5)

- **Auto-descubrimiento de Módulos:**
  - El `engine.php` escaneará automáticamente nuevos directorios en `backend/modules/`.
  - Registro automático en tablas de menú y permisos basado en `module.json`.

- **CLI de PHLEXMOD:**
  - Herramienta de línea de comandos para tareas comunes.
  - `phlexmod make:module <namespace>/<nombre>`: Generación de estructura de carpetas.
  - `phlexmod make:api <nombre>`: Generación de endpoints.

- **Middleware de Seguridad:**
  - Capa intermedia formal para validación de permisos antes de ejecutar endpoints (actualmente se hace dentro del endpoint o en el engine).

## Largo Plazo (v3.0)

- **Marketplace de Módulos:**
  - Repositorio centralizado para descargar e instalar módulos de la comunidad o de JAG-Media.
- **Panel de Control de Sistema:**
  - Interfaz gráfica para gestión integral de configuración (`core-config`), logs y estado del sistema.

---
> *Nota: Este roadmap es una guía de intención y está sujeto a cambios según las necesidades del proyecto.*
