# Visión General de PHLEXMOD (MIA-C4I)

**Versión:** 2.1 (MIA-C4I Hybrid)
**Kernel:** PostgreSQL 10+
**Hardware:** PHP 8.4

## ¿Qué es PHLEXMOD?

PHLEXMOD no es un framework PHP tradicional; es un **Sistema Operativo de Aplicaciones Empresariales** construido sobre el paradigma MIA-C4I. Su propósito es gestionar el estado de una organización, utilizando la base de datos como Kernel y los archivos PHP como Hardware Pasivo.

## Conceptos Clave (El Nuevo Paradigma)

### 1. MIA (Modular Isolation Architecture) - El Cuerpo
Cada módulo en PHLEXMOD es un territorio físico soberano. No hay "autocarga" mágica de clases entre módulos. Si un módulo falla, el resto del sistema sigue operando. Es **Hardware Lógico** intercambiable.

### 2. C4I (Command, Control, Intelligence) - El Alma
La base de datos (PostgreSQL) es la única fuente de verdad.
- **Command:** Define qué módulos existen (`setting_modules`).
- **Control:** Define quién puede entrar (`setting_privilege_user`).
- **Intelligence:** Centraliza la lógica de negocio crítica.

### 3. Modelo de Materia Oscura
Los archivos en disco son inermes (Materia Oscura) hasta que el Kernel los "ilumina" mediante una consulta SQL existencial. Si la base de datos dice que un archivo no existe (o no tienes permiso), el servidor web nunca lo ejecutará.

### 4. Soberanía Tecnológica
- **Zero Composer en Runtime:** Todas las dependencias viven en el repositorio.
- **Zero .env:** La configuración es PHP nativo compilado.
- **Air-Gapped Ready:** Diseñado para funcionar en entornos aislados sin internet.

## Casos de Uso Típicos
- Sistemas de Gobierno Electrónico.
- ERPs de Misión Crítica.
- Aplicaciones donde la integridad de los datos es más importante que la velocidad de desarrollo.

## Próximos Pasos
1. [Guía de Instalación](./instalacion.md)
2. [Estructura de Módulos (Hardware)](../2-arquitectura/estructura-modulos.md)
3. [El Engine (Intérprete)](../2-arquitectura/engine.md)

---
