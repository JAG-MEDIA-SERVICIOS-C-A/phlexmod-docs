# Proxy de Assets y Ofuscación de Rutas (load_resource.php)

PHLEXMOD implementa una capa de ofuscación para recursos estáticos y dependencias frontend para evitar exponer rutas internas del servidor y estandarizar la carga de recursos desde el propio framework.

Esta capa se apoya en dos mecanismos distintos:

- **Proxy por sesión (modo "tokenizado")**: `load_resource.php?r=<TOKEN>&f=<RELATIVE_PATH>`
- **Proxy público firmado (modo "public signed")**: `load_resource.php?p=<PATH>&exp=<EPOCH>&sig=<HMAC>`

Ambos son servidos por `frontend/load_resource.php`.

---

## Objetivo

- Servir recursos desde `frontend/assets/` y `frontend/vendors/` sin exponer rutas del filesystem.
- Controlar qué rutas/extensiones se pueden servir.
- Permitir cargas tempranas (como `manifest.json`) sin depender de sesión/Redis.
- Reducir dependencia de configuración adicional en Nginx para rutas auxiliares (`/fonts`, `/webfonts`, `/badges`).

---

## Ubicación de piezas

- **Proxy runtime**: `frontend/load_resource.php`
- **Helper para generar URLs**: `backend/core/proxy-helper.php`
- **Cargador central de vendors**: `vendor_loader.php`
- **Constantes**: `core-config.php`

---

## 1) Modo tokenizado (por sesión / Redis)

### URL tokenizada

`/frontend/load_resource.php?r=<TOKEN>&f=<RELATIVE_PATH>`

### Cómo se genera la URL tokenizada

Desde PHP:

- `get_proxied_asset_url($webPath)` (en `backend/core/proxy-helper.php`)

Este helper:

- Resuelve el archivo real del sistema.
- Calcula un `authRoot` (raíz autorizada) para permitir recursos relativos.
- Genera un `TOKEN` y lo guarda:
  - Preferentemente en Redis (`proxy_map:<TOKEN>`), con TTL.
  - O en sesión (`$_SESSION['resource_map']`).

### Ventajas transparentes

- Permite autorizar una “raíz” para cargas relativas.
- Control centralizado sobre qué root se expone por token.

### Limitaciones

- Depende de Redis o sesión.
- Puede fallar en cargas tempranas o contextos sin cookie/sesión.

---

## 2) Modo public signed (sin sesión / sin Redis)

Este modo resuelve recursos con **firma HMAC** y (opcional) expiración.

### URL firmada

`/frontend/load_resource.php?p=<PATH>&exp=<EPOCH>&sig=<HMAC>`

- `p`: ruta relativa dentro de `frontend/`.
  - Ejemplo: `vendors/unicons/css/line.css`
  - Ejemplo: `assets/img/favicons/manifest.json`
- `exp`:
  - `0` para no expirar.
  - o un timestamp UNIX (segundos) para expiración.
- `sig`: firma HMAC de `p|exp`.

### Cómo se genera la URL firmada

Desde PHP:

- `get_public_signed_asset_url($webPath, $ttlSeconds = 86400)`

Implementado en `backend/core/proxy-helper.php`.

### Derivación de llave (coherencia con 1 sola llave operativa)

Para mantener una única llave operativa y evitar reutilización directa por propósito, se deriva una llave de firma:

- Si existe `PHLEXMOD_PUBLIC_ASSET_SIGNING_KEY`, se usa como master.
- Si no existe, se usa `PHLEXMOD_PASS_ENCRYPT` como master.

Luego:

- `signingKey = HMAC_SHA256("PHLEXMOD:PUBLIC_ASSET_SIGNING:v1", master)`

Y la firma:

- `sig = HMAC_SHA256(p|exp, signingKey)`

### Allowlist

El modo public signed solo permite servir rutas que inicien con:

- `assets/`
- `vendors/`

Y solo ciertas extensiones (ej. `css`, `js`, `json`, `woff2`, `png`, etc.).

### Ventajas

- No depende de sesión/Redis.
- Ideal para recursos “públicos” que el navegador pide temprano (ej. `manifest.json`).
- Reduce necesidad de `alias` en Nginx.

---

## 3) Reescritura de URLs dentro de CSS

Cuando un CSS es servido por `public signed`, `load_resource.php` reescribe:

- `url(...)` relativas

hacia URLs firmadas `p/exp/sig`, de forma que:

- Los fonts/imagenes referenciados dentro del CSS se resuelven sin depender de rutas como `/fonts` o `/webfonts`.

Esto es crítico para vendors como:

- Unicons (`vendors/unicons/css/line.css` → `vendors/unicons/fonts/...`)
- FontAwesome (`vendors/fontawesome/css/all.min.css` → `vendors/fontawesome/webfonts/...`)

---

## 4) Recomendaciones de uso

- **Assets del core (favicons, manifest, theme CSS, JS core)**:
  - preferir `public signed`.
- **Assets de módulos (dependen de autenticación y rotación de permisos)**:
  - preferir modo tokenizado (`r/f`).

---

## 5) Badges y documentación pública

Los badges usados en README (ej. `README.md`, `docs/README.md`) se consumen desde GitHub y no pueden generar `sig` dinámico.

Recomendación:

- Mantener una URL pública estable `/badges/*.svg` o servirlos desde un hosting estático independiente.

---

## 6) Checklist de despliegue (sin dependencia Nginx)

- Verificar que `frontend/load_resource.php` soporte `p/exp/sig`.
- Verificar que `backend/core/proxy-helper.php` genere URLs firmadas.
- Verificar que `vendor_loader.php` use URLs firmadas para vendors con rutas relativas en CSS.
- (Opcional) Retirar `alias` específicos de Nginx si ya no son necesarios.
