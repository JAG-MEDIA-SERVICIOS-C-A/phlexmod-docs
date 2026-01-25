#!/bin/bash
# analyze_headers.sh - Analiza información de logging en cabeceras de archivos PHP y JS

echo "🔍 ANÁLISIS DE LOGGING EN CABECERAS"
echo "════════════════════════════════════════"
echo "📅 Fecha: $(date)"
echo "📍 Directorio: $(pwd)"
echo ""

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}📋 RESUMEN DE VERSIONES Y FECHAS${NC}"
echo ""

# Analizar archivos PHP
echo -e "${YELLOW}📄 Archivos PHP:${NC}"
echo "┌─────────────────────────────────────┬─────────┬────────────┬─────────────┐"
echo "│ Archivo                             │ Versión │ Since      │ Updated     │"
echo "├─────────────────────────────────────┼─────────┼────────────┼─────────────┤"

find . -name "*.php" -not -path "./vendor/*" -not -path "./node_modules/*" | while read file; do
    if [ -f "$file" ]; then
        version=$(grep -m1 "@version" "$file" | sed 's/.*@version[[:space:]]*[[:space:]]*\([^[:space:]]*\).*/\1/' | head -1)
        since=$(grep -m1 "@since" "$file" | sed 's/.*@since[[:space:]]*[[:space:]]*\([^[:space:]]*\).*/\1/' | head -1)
        updated=$(grep -m1 "@updated" "$file" | sed 's/.*@updated[[:space:]]*[[:space:]]*\([^[:space:]]*\).*/\1/' | head -1)
        
        # Limitar nombre de archivo para la tabla
        filename=$(basename "$file")
        if [ ${#filename} -gt 35 ]; then
            filename="${filename:0:32}..."
        fi
        
        # Formatear para tabla
        printf "│ %-35s │ %-7s │ %-10s │ %-11s │\n" "$filename" "${version:-N/A}" "${since:-N/A}" "${updated:-N/A}"
    fi
done | head -20

echo "└─────────────────────────────────────┴─────────┴────────────┴─────────────┘"
echo ""

# Analizar archivos JS
echo -e "${YELLOW}📄 Archivos JavaScript:${NC}"
echo "┌─────────────────────────────────────┬─────────┬────────────┬─────────────┐"
echo "│ Archivo                             │ Versión │ Since      │ Updated     │"
echo "├─────────────────────────────────────┼─────────┼────────────┼─────────────┤"

find . -name "*.js" -not -path "./vendor/*" -not -path "./node_modules/*" | while read file; do
    if [ -f "$file" ]; then
        version=$(grep -m1 "@version" "$file" | sed 's/.*@version[[:space:]]*[[:space:]]*\([^[:space:]]*\).*/\1/' | head -1)
        since=$(grep -m1 "@since" "$file" | sed 's/.*@since[[:space:]]*[[:space:]]*\([^[:space:]]*\).*/\1/' | head -1)
        updated=$(grep -m1 "@updated" "$file" | sed 's/.*@updated[[:space:]]*[[:space:]]*\([^[:space:]]*\).*/\1/' | head -1)
        
        # Limitar nombre de archivo para la tabla
        filename=$(basename "$file")
        if [ ${#filename} -gt 35 ]; then
            filename="${filename:0:32}..."
        fi
        
        # Formatear para tabla
        printf "│ %-35s │ %-7s │ %-10s │ %-11s │\n" "$filename" "${version:-N/A}" "${since:-N/A}" "${updated:-N/A}"
    fi
done | head -15

echo "└─────────────────────────────────────┴─────────┴────────────┴─────────────┘"
echo ""

# Estadísticas
echo -e "${BLUE}📊 ESTADÍSTICAS${NC}"
total_php=$(find . -name "*.php" -not -path "./vendor/*" -not -path "./node_modules/*" | wc -l)
total_js=$(find . -name "*.js" -not -path "./vendor/*" -not -path "./node_modules/*" | wc -l)
with_headers=$(find . \( -name "*.php" -o -name "*.js" \) -not -path "./vendor/*" -not -path "./node_modules/*" -exec grep -l "@since\|@version" {} \; | wc -l)

echo "📁 Total archivos PHP: $total_php"
echo "📁 Total archivos JS: $total_js"
echo "📝 Con cabeceras documentadas: $with_headers"
echo ""

# Fechas más comunes
echo -e "${BLUE}📅 FECHAS MÁS COMUNES (since)${NC}"
find . \( -name "*.php" -o -name "*.js" \) -not -path "./vendor/*" -not -path "./node_modules/*" -exec grep -h "@since" {} \; | sed 's/.*@since[[:space:]]*[[:space:]]*\([^[:space:]]*\).*/\1/' | sort | uniq -c | sort -nr | head -5
echo ""

# Versiones más comunes
echo -e "${BLUE}🔢 VERSIONES MÁS COMUNES${NC}"
find . \( -name "*.php" -o -name "*.js" \) -not -path "./vendor/*" -not -path "./node_modules/*" -exec grep -h "@version" {} \; | sed 's/.*@version[[:space:]]*[[:space:]]*\([^[:space:]]*\).*/\1/' | sort | uniq -c | sort -nr | head -5
echo ""

# Archivos sin cabecera
echo -e "${YELLOW}⚠️  ARCHIVOS SIN CABECERA (primeros 10)${NC}"
find . \( -name "*.php" -o -name "*.js" \) -not -path "./vendor/*" -not -path "./node_modules/*" -not -path "./.resource/*" | while read file; do
    if ! grep -q "@since\|@version" "$file" 2>/dev/null; then
        echo "  • $file"
    fi
done | head -10

echo ""
echo -e "${GREEN}✅ Análisis completado${NC}"
