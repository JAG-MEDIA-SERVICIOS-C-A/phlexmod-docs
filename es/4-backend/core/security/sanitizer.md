# Clase Sanitizer (Capa de Abstracción de Seguridad)

La clase `Sanitizer` constituye el componente central de la arquitectura de seguridad de PHLEXMOD, diseñado para la normalización, validación y tipado estricto de los datos de entrada. Su implementación es imperativa en todos los endpoints del backend para neutralizar vectores de ataque por inyección (XSS, SQL Injection) y asegurar la integridad de los datos procesados.

## Ubicación del Componente
`backend/core/Sanitizer.php`

## Principios de Diseño
1.  **Centralización de Entradas (Input Centralization)**: Todo flujo de datos externo (`$_POST`, `$_GET`, `$_REQUEST`) debe ser procesado exclusivamente a través de esta capa de abstracción.
2.  **Cumplimiento de Contrato de Tipos (Strict Type Enforcement)**: Se requiere la definición explícita del tipo de dato esperado (`int`, `float`, `email`, `url`, `string`) para validar la conformidad del payload.
3.  **Sanitización Defensiva (Defensive Sanitization)**: Eliminación automática de etiquetas HTML y secuencias de caracteres potencialmente maliciosas por defecto.
4.  **Manejo de Valores Nulos (Null Safety)**: Mecanismo robusto para la definición de valores por defecto (fallback values) en caso de ausencia o invalidez de los datos de entrada.

## Referencia de API

### `clean($data, $type = 'string')`
Método estático fundamental para la limpieza y validación de escalares.

-   `mixed $data`: El valor crudo a sanitizar.
-   `string $type`: Tipo de dato esperado. Valores permitidos: `'string'`, `'int'`, `'float'`, `'email'`, `'url'`, `'bool'`.
-   **Retorna**: El valor sanitizado y validado, o `null` (o cadena vacía para strings) si la validación falla.

### `post($key, $default = null, $type = 'string')`
Recupera y sanitiza un valor del superglobal `$_POST`.

-   `string $key`: La clave del índice en el array `$_POST`.
-   `mixed $default`: Valor de retorno por defecto si la clave no existe.
-   `string $type`: Tipo de dato esperado para validación.
-   **Retorna**: El valor procesado o el valor por defecto.

### `get($key, $default = null, $type = 'string')`
Recupera y sanitiza un valor del superglobal `$_GET`.

-   Funcionalidad homóloga a `post()` para peticiones GET.

## Patrones de Implementación

### 1. Validación de Enteros (IDs y Claves Foráneas)
```php
// Patrón Deprecado (Inseguro - Vulnerable a Type Juggling/Injection)
$id = $_POST['id'];

// Patrón Seguro (Validación de Tipo Entero)
$id = Sanitizer::post('id', 0, 'int');
```

### 2. Validación de Correo Electrónico
```php
// Patrón Deprecado
$email = $_POST['email'];

// Patrón Seguro
$email = Sanitizer::post('email', null, 'email');
if (!$email) {
    // Manejo de Excepción: Formato de email inválido
}
```

### 3. Sanitización de Cadenas de Texto
```php
// Patrón Deprecado
$nombre = strip_tags($_POST['nombre']);

// Patrón Seguro (Strip tags y Trim implícitos)
$nombre = Sanitizer::post('nombre');
```

### 4. Validación de URLs
```php
$url = Sanitizer::post('urlToReturn', null, 'url');
```

## Protocolo de Migración (Modo Trinchera)
Se requiere una refactorización exhaustiva de todos los endpoints heredados para erradicar el acceso directo a superglobales, reemplazándolos mandatoriamente por llamadas estáticas a la clase `Sanitizer`.
