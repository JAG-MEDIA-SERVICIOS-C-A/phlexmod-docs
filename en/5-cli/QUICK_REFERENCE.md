> ⚠️ **TRANSLATION PENDING:** This document is currently in Spanish. Contributions to translate it to English are welcome.

# 🔧 Referencia Rápida de Comandos CLI

## 📋 Comandos por Categoría

### **🗄️ Base de Datos**

```bash
./phlexmod db:create      # Crear BD si no existe
./phlexmod db:test        # Probar conexión
./phlexmod db:tables      # Listar tablas
./phlexmod db:seed        # Ejecutar instalación
./phlexmod db:monitor     # Monitor en tiempo real
```

### **⚙️ Configuración**

```bash
./phlexmod make:config    # Configurar core-config.php
./phlexmod sys:info       # Info del sistema
```

### **📦 Módulos**

```bash
./phlexmod make:module <nombre>                    # Crear módulo
./phlexmod make:endpoint <mod> <nombre> [--scope=admin|user]  # Crear endpoint
./phlexmod module:health                           # Auditar módulos
./phlexmod route:list                              # Listar rutas
```

### **📋 Logs**

```bash
./phlexmod log:view [--limit=N] [--search="texto"] # Ver logs
./phlexmod log:clear                               # Limpiar logs
```

### **❓ Ayuda**

```bash
./phlexmod help            # Ayuda general
```

## 🚀 Scripts Útiles

### **Instalación Fresh**

```bash
./phlexmod sys:info && ./phlexmod db:create && ./phlexmod db:test && ./phlexmod db:seed
```

### **Debug Completo**

```bash
./phlexmod sys:info && ./phlexmod module:health && ./phlexmod route:list && ./phlexmod log:view --limit=10
```

### **Desarrollo de Módulo**

```bash
./phlexmod make:module <nombre> && ./phlexmod make:endpoint <nombre> api --scope=admin
```

---
**Referencia rápida** - Imprime para consulta offline
