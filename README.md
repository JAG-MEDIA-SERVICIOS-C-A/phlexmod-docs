# Especificaciones Públicas PHLEXMOD (MIA-C4I)

> Este documento contiene información técnica aprobada para difusión pública en blogs (Dev.to, CoderLegion) y presentaciones. No contiene secretos comerciales ni código fuente sensible.

## 1. Ficha Técnica

- **Nombre**: PHLEXMOD Framework
- **Arquitectura**: MIA-C4I (Modular Isolation Architecture + Command Control)
- **Stack**: PHP 8.4 (Core), PostgreSQL 10+ (Data), Vanilla JS (Client).
- **Licencia**: Propietaria (JAG MEDIA).
- **Filosofía**: Zero Vendor, Shared Nothing.

## 2. Métricas de Rendimiento (Benchmarks Referenciales)

| Métrica | PHLEXMOD | Framework Tradicional (Laravel/Symfony) |
| :--- | :--- | :--- |
| **Boot Time** | ~2-5ms | ~30-50ms |
| **Memoria Base** | < 2MB | > 15MB |
| **Dependencias** | 0 (Zero) | > 50 paquetes vendor |
| **Request/Sec** | Alto | Medio |

*Nota: PHLEXMOD logra esto eliminando el "Auto-Wiring" y la reflexión pesada en tiempo de ejecución, delegando el enrutamiento a consultas SQL indexadas.*

## 3. El Modelo de Aislamiento (MIA)

En la arquitectura MIA, el sistema se divide en dos planos:

1.  **Plano de Control (C4I)**: Gestionado por la Base de Datos. Define *quién* puede hacer *qué* y *dónde*.
2.  **Plano Operativo (Módulos)**: Unidades de código aisladas que ejecutan la lógica de negocio.

### Regla de Oro
> "Un módulo no conoce la existencia de otro módulo. Solo conoce al Kernel (DB) y al Engine (Orquestador)."

## 4. Flujo de Desarrollo (The 3-Step Flow)

Para crear una funcionalidad en PHLEXMOD, el desarrollador sigue un ciclo estricto que garantiza orden:

1.  **UI (La Piel)**: Se crea un archivo `.ui.php` (o `.ui.html` conceptual) que contiene **solo** la estructura visual. Sin lógica, sin bucles complejos.
2.  **API (El Cerebro)**: Se crea un endpoint `.api.php` que recibe parámetros limpios (vía `Sanitizer`) y retorna JSON puro.
3.  **JS (Los Nervios)**: Se conecta la UI con la API usando el `ModuleLoader` nativo, que inyecta la interactividad bajo demanda.

## 5. Seguridad por Diseño

- **Defense in Depth**: WAF (Nginx) + Security Headers (PHP) + DB Permissions.
- **Tokens CSRF**: Obligatorios en cada mutación de estado.
- **Aislamiento de Fallos**: Un `Fatal Error` en un reporte no detiene el sistema de facturación.

---
*Uso autorizado para artículos de divulgación tecnológica.*
