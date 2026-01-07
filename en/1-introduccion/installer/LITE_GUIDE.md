> ⚠️ **TRANSLATION PENDING:** This document is currently in Spanish. Contributions to translate it to English are welcome.

# Guía para crear instalador LITE desde FULL

## Tablas a EXCLUIR para versión LITE

### Módulos opcionales (completos)

- **2FA**: `setting_2fa_users`, `setting_2fa_recovery_codes`
- **Conciliación**: `setting_conciliacion_empresas`, `setting_conciliacion_reportes`
- **BDV**: `bdv_conciliacion_pagos`, `bdv_tesoreria_movimientos`, `bdv_tesoreria_saldo`
- **Payments**: `payment_providers`, `payment_provider_endpoints`, `payment_client_credentials`, `payment_api_config`, `payment_audit_logs`
- **FontAwesome**: `setting_fontawesome` (2000+ iconos)

### Tablas de usuario opcionales

- **Info extendida**: `setting_user_info` (preferencias, país, moneda)
- **Verificación KYC**: `setting_user_verificacion` (documentos, estado)

### Seeds a EXCLUIR

- **Payment providers**: `payment_providers` (BDV IPG, Binance Pay)
- **User info**: `setting_user_info` (entrada admin)
- **Email config**: `setting_email_config` (placeholder SMTP)
- **Email templates**: `setting_email_templates` (templates básicos)
- **Prefijos telefónicos**: `setting_prefijos_telefonicos` (catálogo completo)
- **Monedas**: `setting_monedas` (solo mantener USD si se necesita)

## Comandos para generar LITE

```bash
# Copiar archivos FULL a LITE
cp installs/db/02_create_tables.sql installs/db/02_create_tables_lite.sql
cp installs/db/03_add_indexes.sql installs/db/03_add_indexes_lite.sql  
cp installs/db/04_add_constraints.sql installs/db/04_add_constraints_lite.sql
cp installs/db/05_insert_data.sql installs/db/05_insert_data_lite.sql

# Editar archivos LITE y eliminar:
# - Tablas listadas arriba
# - Índices de tablas eliminadas
# - Constraints de tablas eliminadas
# - Seeds de tablas eliminadas
```

## Estructura LITE resultante

### Mínimo indispensable

- **Core**: `setting_user`, `setting_grupos`, `setting_menu`, `setting_privilege_user`
- **Logs**: `setting_logs` (crítico para auditoría)
- **Security**: `security_login_attempts`, `security_login_locks`
- **Tokens**: `setting_verification_tokens` (para email/password reset)
- **System**: `setting_system_config` (configuración básica)

### Opcional pero recomendado

- **Email**: `setting_email_config`, `setting_email_templates` (si se envían emails)
- **Monedas**: `setting_monedas` (solo USD/EUR básicos)

## Estimación de reducción

- **Tablas**: 15 → 6-8 (40-50% menos)
- **Índices**: ~50 → ~20 (60% menos)
- **Constraints**: ~35 → ~15 (55% menos)
- **Seeds**: ~200 → ~10 (95% menos)
- **Tiempo instalación**: ~3min → ~1min

## Proceso de migración FULL → LITE

1. Crear archivos LITE desde FULL
2. Eliminar tablas/seeds opcionales según lista
3. Ajustar constraints que referencien tablas eliminadas
4. Probar instalación LITE en BD limpia
5. Documentar diferencias en README
