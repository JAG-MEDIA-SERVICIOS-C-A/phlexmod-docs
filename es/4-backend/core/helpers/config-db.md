# Conexión y helpers DB — `config.php`

## Archivo fuente

- `backend/core/config.php`

## Propósito

Inicializar la conexión PostgreSQL (`$conexion`), verificar tablas mínimas y proveer helpers reutilizables de DB.

## Conexión

- La conexión se establece con `pg_connect(...)` usando constantes de `core-config.php`:
  - `PHLEXMOD_DB_HOST`, `PHLEXMOD_DB_PORT`, `PHLEXMOD_DB_DATABASE`, `PHLEXMOD_DB_USER`, `PHLEXMOD_DB_PASS`

## Funciones

## `checkTableExists($conexion, $tableName)`

| Campo | Valor |
|---|---|
| **Firma** | `function checkTableExists($conexion, $tableName): bool` |
| **Entrada** | `$conexion` (PgSql\Connection o resource), `$tableName` (string) |
| **Salida** | `bool` |

### Comportamiento

- Consulta `to_regclass('public.<table>')` para validar existencia.

## `handleError($conexion, $customMessage)`

| Campo | Valor |
|---|---|
| **Firma** | `function handleError($conexion, $customMessage)` |
| **Entrada** | `$conexion`, `$customMessage` |
| **Salida** | `false` (además imprime JSON y cierra conexión) |

### Comportamiento

- Obtiene `pg_last_error($conexion)` y lo registra con `error_log`.
- Ajusta el mensaje en base a patrones:
  - `duplicate key`
  - `violates foreign key constraint`
  - `null value`
- Cierra conexión (`pg_close`).
- Responde JSON con:
  - `status: 'error'`
  - `message: <mensaje>`

### Ejemplo

```php
include PHLEXMOD_CORE_PATH . 'config.php';

$res = pg_query($conexion, 'SELECT 1');
if (!$res) {
  return handleError($conexion, 'Error ejecutando consulta');
}
```
