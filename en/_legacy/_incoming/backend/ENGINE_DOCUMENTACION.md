> ⚠️ **TRANSLATION PENDING:** This document is currently in Spanish. Contributions to translate it to English are welcome.

# Documentación del Motor Principal (engine.php)

## Descripción General

El archivo `engine.php` es el componente central del framework PHLEXMOD que gestiona la carga dinámica de módulos y la navegación del sistema. Actúa como un controlador principal que determina qué módulos cargar basándose en los parámetros de la solicitud y los permisos del usuario.

## Funcionalidades Principales

### 1. Inicialización del Sistema

- Incluye archivos de configuración esenciales:
  - `core-config.php`: Configuración global del framework
  - `encryption.php`: Funciones de encriptación/desencriptación
  - `config.php`: Configuraciones específicas de la aplicación

- Carga traducciones según el idioma configurado:
  ```php
  $translations = loadTranslations($lang);
  ```

### 2. Gestión de Navegación

- **Página de Bienvenida**: Si no se especifica un módulo o contenido, muestra la página de bienvenida.
  ```php
  if (empty($desencriptar($_REQUEST["modulo"] ?? null)) && empty($desencriptar($_REQUEST["contenido"]?? null))) {
      include PHLEXMOD_CORE_PATH.'welcome-page.php';
  }
  ```

- **Carga de Módulos**: Cuando se especifica un módulo y contenido, consulta la base de datos para verificar permisos y obtener información del módulo.
  ```php
  $sqlMain = "SELECT 
      setting_privilege_user.uid,
      setting_privilege_user.codigo,
      setting_menu.enlace,
      setting_menu.descripcion,
      setting_menu.icon,
      setting_menu.directorio,
      setting_menu.info
  FROM 
      setting_privilege_user
  INNER JOIN setting_menu ON setting_privilege_user.codigo = setting_menu.codigo 
  WHERE 
      setting_privilege_user.uid = $reqIdModulo 
  AND setting_privilege_user.codigo = $reqIdEnlaces";
  ```

### 3. Carga Dinámica de Módulos

- **Definición de Rutas Dinámicas**: Establece rutas específicas para cada módulo basándose en su directorio.
  ```php
  if (!defined('PHLEXMOD_ROUTE_SPECIFIES_MODULES_UI')) { 
      define('PHLEXMOD_ROUTE_SPECIFIES_MODULES_UI', PHLEXMOD_MODULES_PATH . $directorio."ui/"); 
  }
  ```

- **Determinación de Rutas de JavaScript**: Diferencia entre módulos administrativos (código ≥ 9000) y módulos de cliente.
  ```php
  $pathPluggin = ($rwMain['codigo'] >= 9000) ? $encriptar(PHLEXMOD_MODULES_ADMIN_PATH_JS) : $encriptar(PHLEXMOD_MODULES_PATH_JS . $directorio . "js/");
  ```

### 4. Integración Frontend-Backend

- **Renderizado de Interfaz**: Muestra el título, ícono y descripción del módulo.
  ```php
  <div class="mb-3">
      <h3 class="mb-2"><i class="<?= $iconoEnlace ?> mr-2 text-secondary opacity-75"></i> <?= $nombreEnlace ?></h3>
      <h6 class="text-muted"><?= $infoEnlace ?></h6>
  </div>
  ```

- **Carga Dinámica de JavaScript**: Utiliza JavaScript para cargar dinámicamente los archivos JS asociados al módulo.
  ```javascript
  async function cargarModulo() {
      const pathEncriptado = $('#path_function').val();
      const documentphp = $('#file_funcion').val();
      let filename = documentphp.split(".");
      let documentjs = filename[0] + '.js';
      try {
          const pathDesencriptado = await desencriptarEnServidor(pathEncriptado);
          let rutaOriginal = pathDesencriptado;
          window.PATH_ENDPOINTS = rutaOriginal.replace('js/', 'endpoints/');
          window.PATH_UI = rutaOriginal.replace('js/', 'ui/');
          const script = document.createElement('script');
          script.src = pathDesencriptado + documentjs;
          document.head.appendChild(script);
      } catch (error) {
          console.error('Error al cargar el módulo:', error);
      }
  }
  ```

### 5. Manejo de Errores

- **Verificación de Existencia de Archivos**: Comprueba si el archivo del módulo existe antes de incluirlo.
  ```php
  if (file_exists($ruta_completa)) {
      include PHLEXMOD_MODULES_PATH . $directorio . $enlace;
  } else {
      include PHLEXMOD_FRONTEND_PATH . 'errors/404.php';
  }
  ```

- **Manejo de Errores del Servidor**: Muestra una página de error 500 si no se puede cargar el dashboard o la página de búsqueda.
  ```php
  if (file_exists(PHLEXMOD_FRONTEND_PATH.'dashboard.php')) {
      include PHLEXMOD_FRONTEND_PATH.'dashboard.php';
  } else {
      include PHLEXMOD_FRONTEND_PATH.'errors/500.php';
  }
  ```

## Variables Globales JavaScript

El archivo `engine.php` define importantes variables globales de JavaScript que son utilizadas por los módulos:

- `window.PATH_ENDPOINTS`: Ruta a los endpoints API del módulo actual
- `window.PATH_UI`: Ruta a los archivos de interfaz de usuario del módulo actual

Estas variables son fundamentales para la comunicación entre el frontend y el backend en la arquitectura modular de PHLEXMOD.

## Flujo de Ejecución

1. Se cargan los archivos de configuración y traducciones
2. Se desencriptan los parámetros de solicitud para identificar el módulo y contenido solicitados
3. Si no hay módulo/contenido especificado, se muestra la página de bienvenida
4. Si hay módulo/contenido, se verifica en la base de datos si el usuario tiene permisos
5. Se obtienen los detalles del módulo (directorio, archivo, ícono, descripción)
6. Se definen las rutas dinámicas para el módulo
7. Se renderiza la interfaz del módulo (título, ícono, descripción)
8. Se carga dinámicamente el archivo JavaScript asociado al módulo
9. Se incluye el archivo PHP del módulo
10. Si el archivo no existe, se muestra una página de error 404

## Seguridad

- **Encriptación de Parámetros**: Los parámetros de módulo y contenido están encriptados en la URL
- **Verificación de Permisos**: Se consulta la base de datos para verificar que el usuario tenga acceso al módulo solicitado
- **Desencriptación Segura**: La desencriptación de rutas se realiza en el servidor mediante una llamada AJAX

## Integración con la Estructura Modular

Este archivo es fundamental para la implementación de la arquitectura modular de PHLEXMOD, permitiendo:

1. **Separación de Responsabilidades**: Cada módulo tiene su propio directorio con archivos PHP, JS, endpoints API y vistas UI
2. **Carga Bajo Demanda**: Los módulos se cargan solo cuando son solicitados
3. **Seguridad Granular**: Los permisos se verifican a nivel de módulo y contenido
4. **Internacionalización**: Soporte para múltiples idiomas mediante traducciones

---

**Versión de la documentación**: 1.0.0  
**Última actualización**: 2025-07-11  
**Autor**: JAG-Media Servicios, C.A.
