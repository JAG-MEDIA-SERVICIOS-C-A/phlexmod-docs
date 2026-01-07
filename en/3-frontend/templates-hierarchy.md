> ⚠️ **TRANSLATION PENDING:** This document is currently in Spanish. Contributions to translate it to English are welcome.

# Sistema de Plantillas y Jerarquía Visual

PHLEXMOD utiliza un patrón de **Composición de Layouts** en lugar de una herencia compleja. Este sistema separa la estructura global de la aplicación (layouts) de los componentes reutilizables (partials) y el contenido dinámico.

## 📂 Estructura de Directorios

Las plantillas se encuentran en `/frontend/templates/` y están organizadas por **contexto de la aplicación**:

```text
/frontend/templates/
├── sistema/          # Interfaz principal (Post-Login)
│   ├── layout.php    # Estructura base (HTML, Body wrapper)
│   ├── header.php    # Barra superior
│   ├── footer.php    # Pie de página
│   ├── menu.php      # (Opcional) Menú lateral
│   └── loder.php     # Spinner de carga
│
├── login/            # Pantalla de Inicio de Sesión
│   ├── layout_login.php
│   ├── form_login.php
│   └── ...
│
├── register/         # Pantalla de Registro
│   ├── layout_register.php
│   └── ...
│
└── install/          # Asistente de Instalación
    ├── layout_install.php
    └── ...
```

## 📐 Patrón de Composición (Layout Composition)

El sistema funciona inyectando **vistas parciales** dentro de marcadores (placeholders) definidos en un **layout maestro**.

### 1. El Layout Maestro (`layout.php`)
Define el esqueleto HTML y ubica los marcadores donde se inyectará el contenido.

```php
<!-- Ejemplo simplificado de layout.php -->
<!DOCTYPE html>
<html>
<body>
    ___HEADER___    <!-- Marcador para el header -->
    
    <div class="main-content">
        ___MENU___  <!-- Marcador para el menú -->
        ___MAIN___  <!-- Marcador para el contenido dinámico (Engine) -->
    </div>

    ___FOOTER___    <!-- Marcador para el footer -->
</body>
</html>
```

### 2. Definición de Placeholders (Entry Point)
En los archivos de entrada (`index.php`, `login.php`), se define qué archivo real reemplaza a cada marcador.

```php
// frontend/index.php
$placeholders = [
    '___HEADER___' => renderTemplate(PHLEXMOD_TEMPLATE_PATH . 'sistema/header.php'),
    '___MENU___'   => renderTemplate(PHLEXMOD_CORE_PATH . 'navigation-menu.php'),
    '___MAIN___'   => renderTemplate(PHLEXMOD_BACKEND_PATH . 'engine.php'), // Contenido dinámico
    '___FOOTER___' => renderTemplate(PHLEXMOD_TEMPLATE_PATH . 'sistema/footer.php'),
];

// Renderizado final
$layout = renderTemplate(PHLEXMOD_TEMPLATE_PATH . 'sistema/layout.php');
echo str_replace(array_keys($placeholders), array_values($placeholders), $layout);
```

## 🛠 Función `renderTemplate()`

Ubicada en `backend/template.php`, esta función es el motor del sistema de vistas.
- **Entrada**: Ruta del archivo y array de datos.
- **Proceso**: 
    1. Extrae variables (`extract($data)`).
    2. Ejecuta el PHP en un buffer (`ob_start()`).
    3. Retorna el HTML resultante.
- **Soporte de Tags**: Permite sintaxis tipo Blade/Twig simple:
    - `{{ $variable }}` → Imprime variable PHP.
    - `{{ trans('key') }}` → Imprime traducción.
    - `{{ CONSTANTE }}` → Imprime constante definida.

## 🔄 Jerarquía de Carga

1. **Contexto**: Se selecciona la carpeta (`sistema`, `login`, etc.) según el entry point.
2. **Layout**: Se carga el esqueleto base.
3. **Partials**: Se renderizan los componentes individuales.
4. **Engine**: En el contexto `sistema`, el placeholder `___MAIN___` carga el `engine.php`, que a su vez carga el módulo específico solicitado por el usuario.

> **Nota**: Para modificar la estructura visual global, edite los archivos en `frontend/templates/sistema/`. Para modificar el contenido de un módulo, vaya a `backend/modules/`.
