# Manifiesto de Módulo (module.json)

> **Estado:** Roadmap / Propuesta. Esta característica aún no está implementada en el core actual.

## Propósito

El objetivo del manifiesto `module.json` es permitir que los módulos sean autodescubribles y autoconfigurables, eliminando la necesidad de insertar registros manualmente en la base de datos (`setting_menu`, etc.).

## Estructura Propuesta

Cada módulo incluiría un archivo `module.json` en su raíz:

```json
{
    "id": "ventas.facturacion",
    "name": "Gestión de Facturación",
    "version": "1.0.0",
    "description": "Módulo para emisión y control de facturas",
    "entry_point": "ui/principal.php",
    "permissions": [
        "ver_facturas",
        "crear_facturas",
        "anular_facturas"
    ],
    "dependencies": {
        "sistema.usuarios": "^1.0"
    },
    "vendors": [
        "chartjs",
        "pdfmake"
    ]
}
```

## Beneficios Esperados

1. **Instalación en un clic:** El sistema podría leer este archivo y crear los menús y permisos automáticamente.
2. **Gestión de dependencias:** Alertar si falta un módulo requerido.
3. **Carga condicional de assets:** Cargar vendors solo cuando el módulo está activo.
