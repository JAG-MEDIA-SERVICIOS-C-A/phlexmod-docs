# Visión General de PHLEXMOD

**Última actualización:** Diciembre 2024

## ¿Qué es PHLEXMOD?

PHLEXMOD es un framework PHP que implementa la **Arquitectura de Aislamiento Modular (MIA)**. Está diseñado para desarrolladores que buscan construir aplicaciones empresariales robustas, seguras y mantenibles sin la sobrecarga de los frameworks tradicionales.

Su filosofía se centra en devolver el control al desarrollador, priorizando la claridad del código y la estabilidad a largo plazo.

## Conceptos Clave

En lugar de una larga lista de características, PHLEXMOD se define por unos pocos conceptos poderosos:

### 1. Soberanía Modular (Aislamiento Real)

A diferencia de los "módulos" de otros frameworks, los módulos de PHLEXMOD son universos autónomos.

- **¿Quieres desactivar una funcionalidad?** Borra su carpeta. El sistema no se romperá.
- **¿Quieres reutilizarla?** Copia la carpeta a otro proyecto.
- No hay dependencias fantasmas ni registros centrales.

### 2. Estabilidad Antifrágil (Control de Dependencias)

PHLEXMOD rechaza la fragilidad de depender de repositorios externos en producción. Todas las librerías necesarias residen dentro del repositorio del proyecto.

- **Cero `composer install` en producción.** Tu aplicación funcionará hoy y dentro de 10 años, sin sorpresas.

### 3. Seguridad por Diseño (No como ocurrencia tardía)

La seguridad no es una capa opcional. Patrones como la `Zona de Sanitización` son obligatorios y aseguran que ninguna entrada no validada alcance la lógica de negocio.

### 4. Alta Productividad a través de la Claridad

PHLEXMOD favorece el código explícito sobre la "magia" de la abstracción. Esto, combinado con herramientas como la `phlex-cli`, permite un desarrollo rápido y con menos errores.

## Casos de Uso Típicos

- Aplicaciones empresariales complejas (ERP, CRM)
- Sistemas de gestión interna y portales de autoservicio
- Proyectos que requieren alta seguridad y mantenibilidad a largo plazo

## Requisitos del Sistema

- **PHP:** 8.2 o superior
- **Base de datos:** PostgreSQL 12+
- **Servidor web:** Apache o Nginx
- **Extensiones PHP:** `pgsql`, `mbstring`, `json`, `curl`

## Próximos Pasos

1. [Guía de Instalación](./instalacion.md)
2. [Principios de Diseño de Módulos](../2-arquitectura/module-design-principles.md)
3. [Creación de Módulos con la CLI](../5-guias/desarrollo/scaffolding-modulos.md)

---
