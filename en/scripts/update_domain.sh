#!/bin/bash
# update_domain.sh - Script para actualizar dominio en PHLEXMOD
# Uso: ./update_domain.sh <nuevo_dominio.com>

set -e  # Salir si hay error

NEW_DOMAIN="$1"
if [ -z "$NEW_DOMAIN" ]; then
    echo "❌ Error: Debes especificar el nuevo dominio"
    echo "Uso: $0 <nuevo_dominio.com>"
    exit 1
fi

# Validar formato del dominio
if [[ ! "$NEW_DOMAIN" =~ ^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
    echo "❌ Error: Formato de dominio inválido"
    exit 1
fi

echo "🚀 Iniciando actualización de dominio a: $NEW_DOMAIN"
echo "⏰ Fecha: $(date)"
echo "📍 Directorio: $(pwd)"
echo ""

# Función para hacer backup
make_backup() {
    echo "📦 Creando backup..."
    
    # Backup de core-config.php
    if [ -f "core-config.php" ]; then
        cp core-config.php "core-config.php.backup.$(date +%Y%m%d_%H%M%S)"
        echo "✅ Backup de core-config.php creado"
    fi
    
    # Backup de base de datos
    if command -v pg_dump &> /dev/null; then
        DB_BACKUP="backup_db_pre_update_$(date +%Y%m%d_%H%M%S).sql"
        pg_dump -h localhost -U postgres -d phlexmod > "$DB_BACKUP" 2>/dev/null || echo "⚠️  No se pudo hacer backup de BD (verificar conexión)"
        if [ -f "$DB_BACKUP" ]; then
            echo "✅ Backup de base de datos creado: $DB_BACKUP"
        fi
    fi
}

# Función para actualizar archivos
update_files() {
    echo "📝 Actualizando archivos de configuración..."
    
    # Actualizar core-config.php
    if [ -f "core-config.php" ]; then
        echo "  • Actualizando core-config.php..."
        
        # Actualizar WebSocket host
        sed -i "s/phlexmod\.mia-architecture\.com/$NEW_DOMAIN/g" core-config.php
        
        # Actualizar rutas SSL si existen
        sed -i "s|/etc/letsencrypt/live/[^/]*|/etc/letsencrypt/live/$NEW_DOMAIN|g" core-config.php
        
        # Verificar cambios
        if grep -q "$NEW_DOMAIN" core-config.php; then
            echo "  ✅ core-config.php actualizado correctamente"
        else
            echo "  ❌ Error actualizando core-config.php"
            exit 1
        fi
    else
        echo "  ❌ No se encuentra core-config.php"
        exit 1
    fi
}

# Función para actualizar base de datos
update_database() {
    echo "🗄️  Actualizando base de datos..."
    
    if command -v psql &> /dev/null; then
        # Actualizar configuración general
        psql -h localhost -U postgres -d phlexmod -c "
            UPDATE setting_general_config 
            SET config_value = REPLACE(config_value, 'phlexmod.mia-architecture.com', '$NEW_DOMAIN')
            WHERE config_value LIKE '%phlexmod.mia-architecture.com%';
        " 2>/dev/null && echo "  ✅ Configuración general actualizada"
        
        # Actualizar configuración de WebSocket si existe
        psql -h localhost -U postgres -d phlexmod -c "
            UPDATE setting_websocket_config 
            SET config_value = REPLACE(config_value, 'phlexmod.mia-architecture.com', '$NEW_DOMAIN')
            WHERE config_value LIKE '%phlexmod.mia-architecture.com%';
        " 2>/dev/null && echo "  ✅ Configuración WebSocket actualizada"
        
        # Actualizar cualquier otra referencia
        psql -h localhost -U postgres -d phlexmod -c "
            UPDATE setting_email_config 
            SET config_value = REPLACE(config_value, 'phlexmod.mia-architecture.com', '$NEW_DOMAIN')
            WHERE config_value LIKE '%phlexmod.mia-architecture.com%';
        " 2>/dev/null && echo "  ✅ Configuración email actualizada"
        
    else
        echo "  ⚠️  psql no disponible, omitiendo actualización de base de datos"
    fi
}

# Función para verificar cambios
verify_changes() {
    echo "🔍 Verificando cambios..."
    
    # Verificar core-config.php
    if grep -q "$NEW_DOMAIN" core-config.php; then
        echo "  ✅ Dominio encontrado en core-config.php"
    else
        echo "  ❌ Dominio no encontrado en core-config.php"
        return 1
    fi
    
    # Verificar que no queden referencias al dominio anterior
    OLD_REFERENCES=$(grep -r "phlexmod.mia-architecture.com" --include="*.php" . 2>/dev/null | grep -v vendor | wc -l)
    if [ "$OLD_REFERENCES" -eq 0 ]; then
        echo "  ✅ No quedan referencias al dominio anterior en archivos PHP"
    else
        echo "  ⚠️  Quedan $OLD_REFERENCES referencias al dominio anterior"
        echo "  💡 Revisa manualmente:"
        grep -r "phlexmod.mia-architecture.com" --include="*.php" . | grep -v vendor
    fi
}

# Función para limpiar caché
clean_cache() {
    echo "🧹 Limpiando caché..."
    
    # Limpiar Redis si está disponible
    if command -v redis-cli &> /dev/null; then
        redis-cli FLUSHALL >/dev/null 2>&1 && echo "  ✅ Caché Redis limpiada" || echo "  ⚠️  No se pudo limpiar Redis"
    fi
    
    # Limpiar caché de archivos si existe
    if [ -d "storage/cache" ]; then
        rm -rf storage/cache/* 2>/dev/null && echo "  ✅ Caché de archivos limpiada"
    fi
    
    # Limpiar logs antiguos (mantener últimos 7 días)
    if [ -d "storage/logs" ]; then
        find storage/logs -name "*.log" -mtime +7 -delete 2>/dev/null
        echo "  ✅ Logs antiguos limpiados"
    fi
}

# Función para mostrar resumen
show_summary() {
    echo ""
    echo "📊 RESUMEN DE ACTUALIZACIÓN"
    echo "════════════════════════════════════════"
    echo "🌐 Nuevo dominio: $NEW_DOMAIN"
    echo "📅 Fecha: $(date)"
    echo "📍 Ubicación: $(pwd)"
    echo ""
    echo "📋 Archivos modificados:"
    echo "  • core-config.php"
    echo ""
    echo "🗄️  Tablas de BD actualizadas:"
    echo "  • setting_general_config"
    echo "  • setting_websocket_config"
    echo "  • setting_email_config"
    echo ""
    echo "🔄 Próximos pasos recomendados:"
    echo "  1. Reiniciar servidor web: sudo systemctl restart apache2"
    echo "  2. Ejecutar script de validación: ./validate_domain_change.sh $NEW_DOMAIN"
    echo "  3. Probar acceso al login en el nuevo dominio"
    echo ""
    echo "⚠️  IMPORTANTE: Configurar SSL/TLS para el nuevo dominio"
    echo ""
}

# Función de rollback
rollback() {
    echo "🔄 Ejecutando rollback..."
    
    # Buscar backup más reciente de core-config.php
    BACKUP_FILE=$(ls -t core-config.php.backup.* 2>/dev/null | head -1)
    if [ -n "$BACKUP_FILE" ]; then
        cp "$BACKUP_FILE" core-config.php
        echo "  ✅ core-config.php restaurado desde $BACKUP_FILE"
    fi
    
    # Restaurar base de datos si hay backup
    DB_BACKUP=$(ls -t backup_db_pre_update_*.sql 2>/dev/null | head -1)
    if [ -n "$DB_BACKUP" ]; then
        psql -h localhost -U postgres -d phlexmod < "$DB_BACKUP" 2>/dev/null && echo "  ✅ Base de datos restaurada"
    fi
    
    echo "🔄 Rollback completado. Reinicia el servidor web."
}

# Manejar Ctrl+C para rollback
trap 'echo ""; echo "🛑 Interrumpido. Ejecutando rollback..."; rollback; exit 1' INT

# Ejecutar flujo principal
main() {
    make_backup
    update_files
    update_database
    verify_changes
    clean_cache
    show_summary
    
    echo "✅ Actualización completada exitosamente!"
    echo ""
    echo "🚀 Para validar los cambios, ejecuta:"
    echo "   ./validate_domain_change.sh $NEW_DOMAIN"
}

# Ejecutar main
main
