> ⚠️ **TRANSLATION PENDING:** This document is currently in Spanish. Contributions to translate it to English are welcome.

# Guía de Pruebas (PHPUnit / Jest)

## PHP (PHPUnit)

### Requisitos

- PHP >= 8.4
- Composer

### Nota sobre Composer y vendor/

- Composer se utiliza únicamente para el entorno de desarrollo/CI (por ejemplo, para instalar PHPUnit en `vendor/bin/`).
- El framework en ejecución (runtime) no depende de Composer ni de la carpeta `vendor/` para operar en producción; los recursos del frontend están en `frontend/vendors/` y las librerías PHP incluidas están en `backend/lib/`.

### Instalación

```bash
composer install
```

### Ejecutar tests

```bash
./vendor/bin/phpunit
```

### Estructura

- `tests/Unit/Backend/` — pruebas unitarias
- `tests/Integration/Backend/` — pruebas de integración (se auto-saltan si faltan variables/servicios)

### Añadir nuevos casos

- Crear archivos `*Test.php` dentro de `tests/Unit/Backend/`.
- Usar `PHPUnit\\Framework\\TestCase`.
- Evitar dependencias de base de datos en tests unitarios.

## JS (Jest)

### Requisitos (Jest)

- Node.js >= 18
- npm

### Instalación (Jest)

```bash
npm install
```

### Ejecutar tests (Jest)

```bash
npm run test:js
```

### Estructura (Jest)

- `tests/js/` — tests de scripts y checks de mitigaciones (ej. SEC-005)

### Añadir nuevos casos (Jest)

- Crear archivos `*.test.js` dentro de `tests/js/`.
- Preferir validaciones por lectura de archivos cuando se trate de templates `.php`.
