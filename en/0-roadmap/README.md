> ⚠️ **TRANSLATION PENDING:** This document is currently in Spanish. Contributions to translate it to English are welcome.

# 🚧 Roadmap & Estado del Proyecto

> **Versión Actual:** Development (Private Preview)
> **Próximo Hito:** Phlexmod Open Core (Community Release)

## Estado Actual: "Coming Soon"

Actualmente, **Phlexmod** se encuentra en una fase intensiva de auditoría y refinamiento arquitectónico. Nuestro objetivo es liberar una versión comunitaria ("Open Core") que cumpla estrictamente con los principios de **Soberanía Tecnológica** y **Zero Magic**.

### ¿Qué estamos haciendo ahora?

1.  **Auditoría de Módulos (MIA Sovereignty Check):**
    - Revisando cada línea de código para asegurar que no existan dependencias ocultas.
    - Desacoplando lógica de negocio propietaria del núcleo estructural.

2.  **Refinamiento de "Zero Magic":**
    - Eliminando abstracciones innecesarias.
    - Asegurando que todo el código sea explícito y fácil de auditar por humanos.
    - Implementando un autoloader nativo para eliminar la dependencia dura de Composer en el runtime.

3.  **Documentación vs. Realidad:**
    - Actualizando todas las guías para que coincidan 100% con el código que se liberará.
    - Nada es más frustrante que una documentación que describe funciones que no existen.

## Hoja de Ruta (Roadmap)

| Fase                       | Estado         | Descripción                                                |
| :------------------------- | :------------- | :--------------------------------------------------------- |
| **1. Internal Audit**      | 🟡 En Progreso | Limpieza de código, seguridad y estructura de directorios. |
| **2. Extension Release**   | ✅ Completado  | Lanzamiento de la extensión oficial para VS Code/Windsurf. |
| **3. Documentation Sync**  | 🟡 En Progreso | Sincronización de docs con la "Verdad del Código".         |
| **4. Open Core Release**   | 🔴 Pendiente   | Publicación del repositorio `phlexmod-opencore`.           |
| **5. Community Ecosystem** | 🔴 Pendiente   | Apertura de foros, issues y contribuciones.                |

---

## Integraciones (Vista Pública)

Las integraciones avanzadas existen en entornos privados y se liberarán progresivamente como módulos públicos o ediciones comerciales. En esta vista pública se listan únicamente categorías generales:

- **Pasarelas de Pago (Genéricas):** Soporte mediante contratos estandarizados (detalles privados).
- **Seguridad Avanzada:** 2FA TOTP y features avanzadas planificadas (roadmap).
- **Infraestructura:** Despliegue en contenedores Docker optimizados.

> _Mantente atento a este repositorio. La arquitectura soberana evoluciona con transparencia documental._
