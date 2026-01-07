# 🖥️ CLI Tools - Documentación Completa

## 📋 Comandos Disponibles

### **🗄️ Base de Datos**

| Comando | Descripción | Uso |
|---------|-------------|-----|
| `db:create` | Crea la base de datos si no existe | `./phlexmod db:create` |
| `db:test` | Verifica conexión a la BD | `./phlexmod db:test` |
| `db:tables` | Lista todas las tablas | `./phlexmod db:tables` |
| `db:seed` | Ejecuta scripts de instalación | `./phlexmod db:seed` |
| `db:monitor` | Monitor en tiempo real de la BD | `./phlexmod db:monitor` |

### **🔧 Configuración**

| Comando | Descripción | Uso |
|---------|-------------|-----|
| `make:config` | Asistente para core-config.php | `./phlexmod make:config` |
| `sys:info` | Muestra información del sistema | `./phlexmod sys:info` |

### **📦 Módulos**

| Comando | Descripción | Uso |
|---------|-------------|-----|
| `make:module` | Crea estructura de nuevo módulo | `./phlexmod make:module nombre` |
| `make:endpoint` | Genera endpoint API | `./phlexmod make:endpoint mod nombre [--scope=admin|user]` |
| `delete:module` | Elimina módulo y limpia BD | `./phlexmod delete:module nombre [--scope=admin]` |
| `module:health` | Audita salud de módulos | `./phlexmod module:health` |
| `route:list` | Lista rutas y módulos registrados | `./phlexmod route:list` |

### **🛡️ Calidad y Auditoría**

| Comando | Descripción | Uso |
|---------|-------------|-----|
| `audit:run` | Ejecuta auditoría de seguridad y calidad | `./phlexmod audit:run [--update-docs]` |
| `test:run` | Ejecuta pruebas unitarias y de integración | `./phlexmod test:run [--unit|--feature]` |
| `headers:scan` | Escanea y normaliza cabeceras | `./phlexmod headers:scan` |

### **📋 Logs**

| Comando | Descripción | Uso |
|---------|-------------|-----|
| `log:view` | Visualiza registros | `./phlexmod log:view [--limit=50] [--search="texto"]` |
| `log:clear` | Limpia tabla de logs | `./phlexmod log:clear` |

### **❓ Ayuda**

| Comando | Descripción | Uso |
|---------|-------------|-----|
| `help` | Muestra ayuda general | `./phlexmod help` |

## 🚀 Flujo de Trabajo Típico

### **1. Instalación Fresh**

```bash
# 1. Verificar sistema
./phlexmod sys:info

# 2. Crear base de datos
./phlexmod db:create

# 3. Probar conexión
./phlexmod db:test

# 4. Ejecutar instalación FULL
./phlexmod db:seed

# 5. Verificar tablas creadas
./phlexmod db:tables

# 6. Listar rutas iniciales
./phlexmod route:list
```

### **2. Desarrollo de Módulos**

```bash
# 1. Crear nuevo módulo
./phlexmod make:module mi_modulo

# 2. Agregar endpoint
./phlexmod make:endpoint mi_modulo api_data --scope=admin

# 3. Verificar salud del módulo
./phlexmod module:health

# 4. Listar rutas actualizadas
./phlexmod route:list
```

### **3. Auditoría y Calidad (Nuevo)**

```bash
# 1. Ejecutar auditoría de seguridad
./phlexmod audit:run

# 2. Actualizar reporte de avances
./phlexmod audit:run --update-docs

# 3. Ejecutar tests automatizados
./phlexmod test:run
```

### **4. Monitoreo y Debug**

```bash
# 1. Info del sistema
./phlexmod sys:info

# 2. Monitor de BD
./phlexmod db:monitor

# 3. Ver logs recientes
./phlexmod log:view --limit=20

# 4. Buscar en logs
./phlexmod log:view --search="error"
```

## 📁 Estructura de Comandos

```text
tools/console/commands/
├── 📄 db_create.php      # db:create
├── 📄 db_test.php        # db:test
├── 📄 db_tables.php      # db:tables
├── 📄 db_seed.php        # db:seed
├── 📄 db_monitor.php     # db:monitor
├── 📄 make_config.php    # make:config
├── 📄 sys_info.php       # sys:info
├── 📄 make_module.php    # make:module
├── 📄 make_endpoint.php  # make:endpoint
├── 📄 module_health.php  # module:health
├── 📄 route_list.php     # route:list
├── 📄 log_view.php       # log:view
├── 📄 log_clear.php      # log:clear
├── 📄 test_run.php       # test:run
├── 📄 audit_run.php      # audit:run
└── 📄 help.php           # help
```

## 🔧 Características Técnicas

### **Validaciones**

- Verificación de extensión PostgreSQL
- Comprobación de permisos de archivos
- Testing de conectividad de servicios
- Validación de estructura de módulos

### **Monitoreo**

- Conexión PostgreSQL en tiempo real
- Estado de Redis (cache)
- Disponibilidad de WebSocket
- Integración con APIs externas

### **Seguridad**

- Detección de archivos con permisos inseguros
- Enmascaramiento de claves API
- Validación de entorno CLI
- Verificación de configuración

## 📖 Ejemplos de Uso

### **Verificar sistema completo**

```bash
./phlexmod sys:info
# Muestra: PHP, extensiones, servicios, permisos, espacio en disco
```

### **Crear módulo con endpoint**

```bash
./phlexmod make:module gestion_usuarios
./phlexmod make:endpoint gestion_usuarios listar_usuarios --scope=admin
./phlexmod make:endpoint gestion_usuarios mi_perfil --scope=user
```

### **Auditoría completa**

```bash
./phlexmod module:health      # Salud de módulos
./phlexmod route:list          # Rutas registradas
./phlexmod db:tables           # Tablas en BD
./phlexmod log:view --limit=10 # Logs recientes
```

---
**Versión CLI**: v2.0  
**Última actualización**: 2025-12-27  
**Estado**: ✅ Completo y documentado
