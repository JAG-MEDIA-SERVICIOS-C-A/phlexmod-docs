# Post para r/PHP

---

**Título:** Creé un framework PHP modular para sistemas administrativos - buscando feedback honesto

---

**Cuerpo:**

Hola r/PHP,

Llevo años desarrollando sistemas empresariales (nóminas, inventarios, gestión de usuarios) y siempre sentí que Laravel era demasiado para lo que necesitaba, pero el código espagueti no era opción.

Así que construí **PHLEXMOD**, un framework basado en lo que llamo "Arquitectura de Aislamiento Modular":

- Cada módulo es una carpeta autocontenida (endpoints, lógica, UI)
- Quieres eliminar un módulo? Borras la carpeta. Sin dependencias ocultas.
- RBAC integrado, multi-idioma, CLI para scaffolding

**Demo en vivo:** <https://phlexmod.jagmedia.com.ve>  
(Usuario: `demo` / Contraseña: `PhlexDemo2025!`)

**GitHub:** <https://github.com/JAG-MEDIA-SERVICIOS-C-A/Phlexmod>

No estoy seguro si liberarlo como open source o mantenerlo como producto comercial. Por ahora la documentación está pública.

¿Tiene sentido este enfoque? ¿Qué opinan? Críticas constructivas bienvenidas.

---

*Nota: No es un reemplazo de Laravel para APIs o SPAs. Es específico para sistemas administrativos con UI integrada.*
