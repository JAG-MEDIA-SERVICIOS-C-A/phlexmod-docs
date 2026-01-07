> ⚠️ **TRANSLATION PENDING:** This document is currently in Spanish. Contributions to translate it to English are welcome.

# Documentación Backend

Esta sección cubre la lógica del servidor, la estructura del núcleo (Core) y los servicios auxiliares.

## Estructura

### [Core (Núcleo)](./core/)
Componentes fundamentales del framework ubicados en `backend/core/`.
- [Autenticación y Seguridad](./core/security/auth-manager.md)
- [Sanitización de Datos](./core/security/sanitizer.md)
- [Helpers (DB, Cifrado, Logs)](./core/helpers/)
- [Realtime (WebSockets)](./core/realtime/)
- [Navegación y Menú](./core/navigation.md)

### [Servicios](./servicios/)
Servicios transversales para soporte de la aplicación.
- [Gestor de Correos](./servicios/mail-manager.md)
- [API de Recursos](./servicios/api-endpoint.md)
- [WebSocket Service](./servicios/websocket-service.md)

### Seguridad y Flujos
- [Proxy de Seguridad](./security_proxy.md)
- [Análisis de Headers y Logging](./HEADERS_LOGGING_ANALYSIS.md)
- [Flujo de Datos PHP-JS](./flujo-php-js.md)

### [CLI](../5-cli/)
Herramientas de línea de comandos para mantenimiento y gestión.
