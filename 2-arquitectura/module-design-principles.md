# Principios de Diseño de Módulos

*Última actualización: Diciembre 2024*

Además de la estructura técnica de un módulo, es crucial seguir principios de diseño que aseguren la mantenibilidad y escalabilidad del sistema. Esta guía explica la filosofía recomendada para organizar la lógica de negocio en PHLEXMOD.

---

## El Problema: El Módulo "Contenedor"

Un anti-patrón común en el desarrollo de software es el "módulo contenedor" (a veces llamado "módulo cajón de sastre"). Este es un módulo grande, como `settings` o `administration`, que agrupa funcionalidades que no tienen relación entre sí.

**Ejemplo de un módulo contenedor `settings`:**

```text
settings/
├── ui/
│   ├── gestion_usuarios.php
│   ├── configuracion_email.php
│   └── gestion_roles.php
└── endpoints/
    ├── guardar_usuario.api.php
    ├── probar_smtp.api.php
    └── asignar_rol.api.php
```

### Desventajas

- **Bajo Aislamiento:** Un bug en `configuracion_email.php` podría bloquear la gestión de usuarios
- **Acoplamiento Fuerte:** El código se vuelve interdependiente y difícil de mantener
- **Permisos Complejos:** ¿Un usuario puede ver `settings`, pero solo la parte de usuarios? Esto requiere lógica de sub-permisos compleja
- **Escalabilidad Pobre:** El módulo crece hasta volverse inmanejable

Este patrón viola directamente el **Principio de Aislamiento Estricto** de la arquitectura MIA.

---

## La Solución: Normalización con Namespaces

La estrategia recomendada en PHLEXMOD es la **normalización**: cada funcionalidad de negocio debe vivir en su propio módulo soberano.

Para agrupar módulos relacionados lógicamente, utilizamos directorios como **Namespaces**. El directorio no contiene lógica, solo organiza otros módulos.

**Estructura Normalizada:**

```text
backend/modules/
└── admin/                 # Namespace (Directorio agrupador)
    ├── users/             # Módulo soberano e independiente
    │   ├── users.php
    │   ├── ui/
    │   ├── endpoints/
    │   └── js/
    ├── menu/              # Módulo soberano e independiente
    │   ├── menu.php
    │   ├── ui/
    │   ├── endpoints/
    │   └── js/
    └── companies/         # Módulo soberano e independiente
        └── ...
```

### Ventajas de la Normalización

| Aspecto | Beneficio |
| ------- | --------- |
| **Aislamiento Real** | Un error en `users` no puede afectar a `companies` |
| **Permisos Granulares** | Es trivial asignar permisos a un módulo completo como `admin/users` |
| **Alta Cohesión** | Cada módulo se enfoca en una sola cosa |
| **Mantenibilidad** | Navegación más clara, archivos más pequeños |
| **Escalabilidad** | El namespace `admin` puede crecer indefinidamente |

---

## Regla de Oro

> ⚠️ **NO CREAR MÓDULOS CONTENEDOR.**
>
> Utiliza el patrón de "Contenedor" solo si es absolutamente necesario para migrar código legacy. Para todo nuevo desarrollo en PHLEXMOD, **siempre usa la estructura de Namespaces**.

---

## Separación de Capas

Cada módulo debe mantener una separación clara de responsabilidades:

| Capa | Ubicación | Responsabilidad |
| ---- | --------- | --------------- |
| **Interfaz** | `ui/` | Solo presentación HTML/PHP. No lógica de negocio |
| **Comunicación** | `endpoints/*.api.php` | Punto de entrada AJAX. Valida y responde JSON |
| **Lógica** | `endpoints/*.logic.php` | Procesa datos y aplica reglas de negocio |
| **Datos** | `endpoints/*.db.php` | Abstracción de BD. SQL y operaciones CRUD |

---

## Principios Clave

1. **Un módulo = Una carpeta:** Todo lo necesario está dentro
2. **Nombres consistentes:** El archivo principal tiene el mismo nombre que la carpeta
3. **Carga automática:** JS y CSS se cargan si existen con el nombre del módulo
4. **Independencia:** Un módulo no depende de la implementación interna de otro
5. **Portabilidad:** Mover un módulo a otra instancia debe ser trivial

---

Para crear módulos, consulta [Creación de Módulos con la CLI](../5-guias/desarrollo/scaffolding-modulos.md).
