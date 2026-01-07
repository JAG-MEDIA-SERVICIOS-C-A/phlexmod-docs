> ⚠️ **TRANSLATION PENDING:** This document is currently in Spanish. Contributions to translate it to English are welcome.

# Migración a Nueva Rama Principal en GitHub

## Pasos Recomendados

1. **Renombrar rama main existente**
   ```bash
   git branch -m main main_backup
   ```

2. **Crear nueva rama main**
   ```bash
   git checkout -b main
   ```

3. **Realizar commit de cambios actuales** (si hay cambios no guardados)
   ```bash
   git add .
   git commit -m "Preparando nueva rama main"
   ```

4. **Subir nueva rama main a GitHub**
   ```bash
   git push origin main
   ```

5. **Configurar rama main como principal en GitHub** (si no está configurada automáticamente)
   - Ir a Settings > Branches en el repositorio de GitHub.
   - En "Default branch", seleccionar `main`.
   - Hacer clic en "Update".

6. **Eliminar rama de backup (opcional y solo local)**
   ```bash
   git branch -D main_backup
   ```

## Ventajas
- No se elimina la rama main original, solo se renombra a `main_backup`.
- Permite mantener un backup local de la rama principal antigua.
- La rama main antigua no se sube a GitHub, evitando confusión.
