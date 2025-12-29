# Estándar CSRF (AJAX sin `<form>`)

## Objetivo

Normalizar la protección CSRF en Phlexmod para peticiones AJAX usando un token en **cabecera HTTP**.

## Flujo esperado

- Trigger: evento JS (`click`, `change`, etc.)
- Captura: `$(selector).val()`
- Envío: `$.ajax()` / `$.post()` hacia endpoints PHP

## Capa de identidad (HTML/PHP)

- El servidor debe mantener `$_SESSION['csrf_token']`.
- El `header` global debe exponer el token al frontend vía meta tag:

```html
<meta name="csrf-token" content="<?php echo $_SESSION['csrf_token']; ?>">
```

## Automatización global (jQuery)

En el JS principal (cargado globalmente), configurar `$.ajaxSetup()` para inyectar el token en **headers**.

- Header: `X-CSRF-TOKEN: <token>`
- Recomendado: `X-Requested-With: XMLHttpRequest`

Regla:

- No enviar token redundante en `data`.

Nota:

- Si algún módulo usa `fetch()` en lugar de jQuery, debe agregar manualmente los headers `X-CSRF-TOKEN` y `X-Requested-With`.

## Validación en servidor (centralizada)

En `frontend/index.php` (Controlador Frontal):

- Si `REQUEST_METHOD === POST`:
  - AJAX: validar `$_SERVER['HTTP_X_CSRF_TOKEN']`
  - Fallback: validar `$_POST['csrf_token']`
  - Comparar con `$_SESSION['csrf_token']` usando `hash_equals()`.
  - Si no coincide: responder `403` con JSON:

```json
{"status":"error","message":"Solicitud no autorizada (CSRF)"}
```

## Checklist de estandarización

- Handlers con `e.preventDefault()` donde aplique.
- No usar `<form>` para acciones AJAX.
- No duplicar token en `data` (solo header).
- Endpoints deben responder JSON consistente (`status === 'success'` o `success === true`).
