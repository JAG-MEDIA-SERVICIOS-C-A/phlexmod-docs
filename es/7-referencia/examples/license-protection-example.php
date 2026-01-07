<?php
/**
 * EXAMPLE: How to protect a PRO feature module
 * Location: backend/modules/binance/dashboard.php
 */

session_start();
require_once '../../core/LicenseMiddleware.php';

use FlexMod\Core\LicenseMiddleware;

// Initialize license middleware
$license = new LicenseMiddleware();

// Option 1: HTTP Check (auto-exits with JSON error if not available)
$license->httpCheckFeature('binance');

// Option 2: Try-catch (custom error handling)
try {
    $license->checkFeature('binance');
    
    // Your Binance module code here
    echo "Welcome to Binance Integration (PRO Feature)";
    
} catch (Exception $e) {
    // Custom error response
    http_response_code(403);
    echo json_encode([
        'error' => $e->getMessage(),
        'upgrade_link' => 'https://phlexmod.mia-architecture.com/upgrade'
    ]);
    exit;
}

// Option 3: Conditional display
if ($license->hasFeature('binance')) {
    // Show PRO feature
    ?>
    <div class="binance-dashboard">
        <h2>Binance API Integration</h2>
        <!-- PRO content -->
    </div>
    <?php
} else {
    // Show upgrade prompt
    ?>
    <div class="upgrade-prompt">
        <p>Esta característica requiere PHLEXMOD PRO</p>
        <a href="https://phlexmod.mia-architecture.com/upgrade">Actualizar ahora</a>
    </div>
    <?php
}
?>
