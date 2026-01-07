# El Engine: Intérprete de Metadatos

El archivo `engine.php` no es un router tradicional ni un controlador frontal. En la arquitectura C4I, actúa como el **Intérprete de Metadatos** que conecta la voluntad del Kernel (Base de Datos) con el hardware pasivo (Archivos PHP).

## 1. Filosofía de Operación

El Engine no "decide"; el Engine "consulta".
Su función es puramente topológica: verificar si una coordenada solicitada (Token de Navegación) tiene una correspondencia válida en el espacio de privilegios de la base de datos.

### Ciclo de Inyección de Contexto
1.  **Recepción:** El cliente envía un Token Encriptado (Coordenada).
2.  **Desencriptación:** El Engine revela el `menu_id` y `user_id`.
3.  **Consulta Existencial (C4I):**
    *   Pregunta al Kernel: "¿Existe una intersección entre este Usuario y este Menú en `setting_privilege_user`?"
    *   Si **NO**: El proceso se detiene. El archivo solicitado no se carga. Para el usuario, no existe.
    *   Si **SI**: El Engine inyecta el contexto (`$Path_UI`, `$Path_Endpoints`) y materializa el archivo mediante `include`.

## 2. Diferencias con un Router MVC

| Router MVC Tradicional | Engine PHLEXMOD (C4I) |
| :--- | :--- |
| Mapea URL `/users/edit/1` a `UserController::edit` | Mapea Token Encriptado a `menu_id` |
| Define rutas en archivos (`routes.php`) | Define rutas en Base de Datos (`setting_menu`) |
| Carga middlewares en cadena | Ejecuta una única validación SQL binaria |
| Gestiona el estado de la sesión | Reconstruye el estado en cada petición (Stateless) |

## 3. Inyección de Variables de Entorno

Una vez que el módulo es "materializado", el Engine le inyecta su realidad operativa:

```php
// El módulo no sabe dónde está hasta que el Engine se lo dice
$Path_UI = ".../modules/admin/usuarios/ui/";
$Path_Endpoints = ".../modules/admin/usuarios/endpoints/";
```

Esto permite que el módulo sea **Soberano** (MIA). No necesita saber la estructura global del sistema; solo necesita saber sus propias fronteras, las cuales son definidas dinámicamente por el Engine.

## 4. Gestión de Errores como "No-Existencia"

En PHLEXMOD, un error de permisos no es una excepción; es un vacío existencial.
*   Si un usuario intenta acceder a un módulo de Admin sin permisos, el sistema no lanza un "Access Denied"; simplemente no encuentra la ruta. La seguridad es por omisión.
