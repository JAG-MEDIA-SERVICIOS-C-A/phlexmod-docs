<?php
/**
 * Nombre del Archivo: project_identifier_usage.php
 * Descripción: Ejemplos de uso del identificador de proyecto.
 * 
 * @package    PHLEXMOD-Framework
 * @subpackage Documentación
 * @autor      JAG-Media Servicios, C.A.
 * @version    1.0.0
 * @since      2025-07-09
 */

// Este archivo es solo para documentación y no debe ser incluido directamente en el código.
require_once __DIR__ . '/../../backend/lib/project_identifier.php';

// Ejemplo 1: Verificar en qué proyecto estamos trabajando
if (PROJECT_IDENTIFIER === 'teatro_ribas') {
    // Código específico para Teatro Ribas
    echo "Estamos en el proyecto Teatro Ribas";
} elseif (PROJECT_IDENTIFIER === 'phlexmod') {
    // Código específico para PhlexMod
    echo "Estamos en el proyecto PhlexMod";
} elseif (PROJECT_IDENTIFIER === 'siagem') {
    // Código específico para SIAGEM
    echo "Estamos en el proyecto SIAGEM";
}

// Ejemplo 2: Usar switch para comportamiento específico por proyecto
switch (PROJECT_IDENTIFIER) {
    case 'teatro_ribas':
        // Lógica específica de Teatro Ribas
        $projectSpecificPath = '/ruta/especifica/teatro_ribas/';
        break;
    case 'phlexmod':
        // Lógica específica de PhlexMod
        $projectSpecificPath = '/ruta/especifica/phlexmod/';
        break;
    case 'siagem':
        // Lógica específica de SIAGEM
        $projectSpecificPath = '/ruta/especifica/siagem/';
        break;
    default:
        // Comportamiento por defecto
        $projectSpecificPath = '/ruta/por/defecto/';
}

// Ejemplo 3: Acceder a otras constantes relacionadas con el proyecto
echo "Nombre del proyecto: " . PROJECT_NAME;
echo "Versión del proyecto: " . PROJECT_VERSION;
echo "¿Es compatible con MIA?: " . (IS_MIA_COMPLIANT ? 'Sí' : 'No');

// Ejemplo 4: Para SIAGEM, verificar si el módulo actual usa MIA
if (PROJECT_IDENTIFIER === 'siagem' && function_exists('isModuleMiaCompliant')) {
    if (isModuleMiaCompliant()) {
        // Usar enfoque MIA para este módulo
        echo "Este módulo de SIAGEM usa MIA";
    } else {
        // Usar enfoque tradicional
        echo "Este módulo de SIAGEM no usa MIA todavía";
    }
}

// Ejemplo 5: Uso en JavaScript (esto debe ser incluido en un archivo PHP que genera HTML)
?>

<!-- Ejemplo de cómo pasar el identificador a JavaScript -->
<script>
    // Estas variables estarían disponibles en todo el código JavaScript
    const PROJECT_IDENTIFIER = '<?php echo PROJECT_IDENTIFIER; ?>';
    const PROJECT_NAME = '<?php echo PROJECT_NAME; ?>';
    const PROJECT_VERSION = '<?php echo PROJECT_VERSION; ?>';
    const IS_MIA_COMPLIANT = <?php echo IS_MIA_COMPLIANT ? 'true' : 'false'; ?>;
    
    // Ejemplo de uso en JavaScript
    if (PROJECT_IDENTIFIER === 'teatro_ribas') {
        console.log('Ejecutando código específico para Teatro Ribas');
        // Lógica específica para Teatro Ribas
    } else if (PROJECT_IDENTIFIER === 'phlexmod') {
        console.log('Ejecutando código específico para PhlexMod');
        // Lógica específica para PhlexMod
    }
    
    // También se puede usar en funciones
    function getProjectSpecificSettings() {
        switch (PROJECT_IDENTIFIER) {
            case 'teatro_ribas':
                return {
                    apiEndpoint: '/api/teatro/',
                    theme: 'teatro-theme'
                };
            case 'phlexmod':
                return {
                    apiEndpoint: '/api/phlexmod/',
                    theme: 'phlexmod-theme'
                };
            default:
                return {
                    apiEndpoint: '/api/default/',
                    theme: 'default-theme'
                };
        }
    }
</script>