# Guía de Pruebas (PHPUnit / Jest)

## PHP (PHPUnit)

### Requisitos

- PHP >= 8.2
- Composer

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
