# La CLI de Desarrollo (`phlexmod`)

**Última actualización:** Diciembre 2024

`phlexmod` es tu principal herramienta para automatizar tareas de desarrollo y mantenimiento en un proyecto PHLEXMOD. Utilizarla te ahorrará tiempo y evitará errores manuales.

## Uso Básico

Todos los comandos se ejecutan desde el directorio raíz de tu proyecto.

```bash
# Para ver todos los comandos disponibles
./phlexmod help

# Sintaxis general
./phlexmod <comando> [argumentos] [--opciones]
```

## Comandos Disponibles

| Comando | Descripción |
| ------- | ----------- |
| `help` | Muestra la lista de todos los comandos disponibles y cómo usarlos |
| `make:module` | Crea la estructura completa de un nuevo módulo y lo registra en la base de datos |
| `make:endpoint` | Genera un archivo de API seguro dentro de un módulo existente |
| `module:health` | Audita todos los módulos para verificar estructura y registro en BD |
| `headers:scan` | Escanea archivos para estandarizar encabezados de licencia |

---

## Ejemplos de Uso

### Crear un módulo de usuario

Esto crea un módulo `inventario` en la carpeta `backend/modules/`.

```bash
./phlexmod make:module inventario --scope=user
```

### Crear un módulo administrativo

Esto crea un módulo `reportes` dentro del namespace `admin` (en `backend/modules/admin/`).

```bash
./phlexmod make:module reportes --scope=admin
```

### Crear un endpoint

Esto genera el archivo `get_stock.api.php` dentro de la carpeta `endpoints/` del módulo `inventario`.

```bash
./phlexmod make:endpoint inventario get_stock --scope=user
```

### Auditar módulos

Ideal para ejecutar antes de un commit para asegurarte de que no has roto ninguna convención.

```bash
./phlexmod module:health
```

---
