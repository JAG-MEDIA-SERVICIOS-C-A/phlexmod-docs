> ⚠️ **TRANSLATION PENDING:** This document is currently in Spanish. Contributions to translate it to English are welcome.

# Plantillas PHLEXMOD

Este directorio contiene las plantillas estándar para el desarrollo con PHLEXMOD Framework, siguiendo los principios de MIA (Modular Isolation Architecture).

## Plantillas Disponibles

### 1. PHP Template (`php-template.php`)

Plantilla estándar para archivos PHP que incluye:
- Encabezado con metadatos completos
- Verificación de seguridad
- Gestión de sesiones
- Estructura para importaciones
- Configuración de módulo
- Espacio para código principal

Para usar:
1. Copiar el archivo a la ubicación deseada
2. Reemplazar las variables entre llaves `{variable}`
3. Implementar la funcionalidad específica

### 2. JavaScript Template (`js-template.js`)

Plantilla estándar para archivos JavaScript que incluye:
- Encabezado consistente
- Namespace modular
- Configuración estructurada
- Gestión de estado
- Manejo de eventos
- Gestión de errores
- Limpieza de recursos

Para usar:
1. Copiar el archivo a la ubicación deseada
2. Reemplazar `modNombre` con el nombre real del módulo
3. Reemplazar las variables entre llaves `{variable}`
4. Implementar la funcionalidad específica

## Convenciones de Nombrado

- Archivos PHP: Usar guiones, todo en minúsculas (ejemplo: `user-auth.php`)
- Archivos JS: Usar guiones, todo en minúsculas (ejemplo: `user-validation.js`)
- Namespaces JS: Usar camelCase con prefijo 'mod' (ejemplo: `modUserAuth`)

## Versiones

La versión actual de las plantillas es 2.0.0, alineada con la refactorización del framework.

## Actualizaciones

Cuando se actualicen las plantillas:
1. Incrementar la versión siguiendo SemVer
2. Actualizar la fecha en `@updated`
3. Documentar los cambios en este README
