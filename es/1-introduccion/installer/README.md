# 📚 Guía del Instalador PHLEXMOD

## Descripción

El instalador de PHLEXMOD prepara la base de datos y la configuración inicial del sistema. Soporta dos modos: Full (esquema completo y datos iniciales) y Lite (esquema mínimo para entornos restringidos).

## Modos de Instalación

- Full: Crea esquema completo, índices, constraints y datos iniciales.
- Lite: Crea tablas esenciales y constraints mínimas.

## Cómo Ejecutarlo

1. Verifica los requisitos de la Guía de Instalación.
2. Abre `http://tu-dominio.com/installs/` en el navegador.
3. Ingresa credenciales de base de datos.
4. El instalador generará `backend/core/core-config.php` y aplicará el modo seleccionado.

## Seguridad Post-Instalación

- Elimina o renombra el directorio `/installs` inmediatamente.
- Restringe permisos de escritura a `backend/storage/` únicamente.

## Troubleshooting

- Revisa los logs del servidor web ante errores.
- Verifica conectividad y credenciales de la base de datos.

## Referencias

- Guía de Instalación: [instalacion.md](../instalacion.md)
