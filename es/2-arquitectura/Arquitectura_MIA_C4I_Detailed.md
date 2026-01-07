# Arquitectura MIA-C4I: Manual de Referencia Técnica

*Versión 2.1 (MIA-C4I Hybrid) - Enero 2026*
*Sistema Operativo: PHLEXMOD*

---

## 📋 Resumen Ejecutivo

**MIA-C4I** es el paradigma que transforma PHLEXMOD de un "framework" a un **Sistema Operativo de Aplicaciones Empresariales**. Combina el aislamiento físico extremo (**MIA**) con un gobierno de datos centralizado y autoritario (**C4I**).

### 🎯 Objetivos
- **Soberanía Física:** Cada módulo es un dispositivo hardware lógico.
- **Gobierno de Datos:** La base de datos es el Kernel que dicta la existencia.
- **Seguridad Binaria:** Los permisos son numéricos y topológicos, no programáticos.

---

## 🏛️ 1. Fundamentos del Patrón (Cuerpo y Alma)

### 1.1. MIA: El Cuerpo (Hardware)
MIA (Modular Isolation Architecture) dicta que el código en disco es inerte y aislado.
- **Aislamiento Estricto:** Un módulo no puede hacer `include` de otro.
- **Autocontención:** Todo lo necesario para renderizar la UI está dentro de la carpeta del módulo.

### 1.2. C4I: El Alma (Kernel)
C4I (Command, Control, Intelligence) dicta que la verdad reside en la base de datos.
- **Materia Oscura:** Si un archivo existe en disco pero no en `setting_menu`, es invisible.
- **Inyección de Contexto:** El Engine consulta al Kernel y luego "inyecta" la identidad y permisos al módulo.

---

## 🔧 2. Patrones de Implementación

### 2.1. Patrón: `Módulo Soberano`
*Implementa: MIA*

Estructura obligatoria de un módulo (Hardware):
```text
nombre-del-modulo/
├── js/               # Lógica de frontend (JavaScript)
├── endpoints/        # APIs internas (Business Logic)
├── ui/               # Vistas (HTML/PHP)
└── entry-point.php   # Conector Hardware
```

### 2.2. Patrón: `Inyección de Contexto`
*Implementa: C4I*

El Engine no "pasa parámetros"; reconstruye la realidad.
1.  **Token:** Recibe token encriptado.
2.  **Validación SQL:** Consulta `setting_privilege_user`.
3.  **Materialización:** Si es válido, hace `include` del entry-point y define constantes de entorno.

### 2.3. Patrón: `Zona de Sanitización`
*Implementa: Seguridad Intrínseca*

Cada endpoint debe limpiar la entrada antes de procesarla.
```php
// Zona de Sanitización
$id = Sanitizer::integer($_POST['id']);
// Fin Zona de Sanitización
```

---

## 📊 3. Tablas del Kernel (Command & Control)

### 3.1. `setting_modules` (Registro de Hardware)
Define qué componentes físicos están instalados.

### 3.2. `setting_menu` (Mapa de Memoria)
Define las direcciones de memoria (rutas) accesibles.

### 3.3. `setting_privilege_user` (Matriz de Acceso)
Define la topología de seguridad.

---

## 🚀 4. Roadmap de Evolución

| Versión | Paradigma | Estado | Descripción |
|---------|-----------|--------|-------------|
| v1.0 | MVC | 💀 Deprecated | Framework PHP tradicional. |
| v2.0 | MIA | ⚠️ Legacy | Introducción de aislamiento modular. |
| v2.1 | MIA-C4I | ✅ Current | Sistema Operativo, Materia Oscura, Soberanía. |

---

## 📄 5. Licencia

**MIA-C4I Architecture** se publica bajo licencia **Creative Commons Attribution 4.0 International (CC BY 4.0)**.
