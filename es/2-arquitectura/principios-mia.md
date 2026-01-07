# Principios MIA-C4I (Cuerpo y Alma)

La arquitectura de PHLEXMOD es un híbrido entre la soberanía física (**MIA**) y el gobierno centralizado de datos (**C4I**).

## 1. MIA (Modular Isolation Architecture) - El Cuerpo

MIA define la física del sistema. Se basa en que la robustez proviene del aislamiento, no de la interconexión.

- **Soberanía Territorial:** Un módulo (`/backend/modules/ventas`) es un territorio físico. Si borras su carpeta, desaparece del universo físico.
- **Independencia de Ejecución:** Ningún módulo puede bloquear la ejecución de otro por un error de sintaxis. El Engine carga módulos de forma aislada.
- **Autocontención:** Todo lo que el módulo necesita (UI, API, JS) está dentro de su territorio.

## 2. C4I (Command, Control, Intelligence) - El Alma

C4I define la metafísica del sistema. Los archivos físicos son inermes sin la voluntad de la base de datos.

- **Command (Voluntad):** La base de datos es el Kernel. Ella decide qué módulos están "activos". Un archivo en disco sin registro en `setting_modules` es **Materia Oscura** (existe pero no importa).
- **Control (Autoridad):** La seguridad es topológica (IDs numéricos) y declarativa (SQL). No se programa seguridad en el controlador; se declara en la tabla `setting_privilege_user`.
- **Intelligence (Verdad):** El código es efímero; los datos son eternos. La lógica de negocio crítica debe residir cerca de los datos (SQL o lógica PHP muy próxima a la capa de datos).

## 3. Principios de Supervivencia

### Materia Oscura
Los archivos no registrados en la base de datos son invisibles para el Engine. Esto permite tener versiones "beta" de módulos en producción que nadie puede ver ni ejecutar hasta que se les otorga un "soplo de vida" (registro en DB).

### Inyección de Contexto
El módulo no "busca" su configuración. El Engine "inyecta" la realidad al módulo al momento de cargarlo. El módulo nace sabiendo quién es el usuario y qué permisos tiene.

### Sin Magia (Zero Magic)
- No hay Autoloaders globales que escaneen todo el disco.
- No hay Inyección de Dependencias reflexiva que consuma CPU innecesariamente.
- Todo es explícito. Si un archivo se carga, es porque una línea de código o un registro de base de datos lo ordenó específicamente.
