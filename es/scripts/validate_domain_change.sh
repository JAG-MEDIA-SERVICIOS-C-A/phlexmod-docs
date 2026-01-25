#!/bin/bash
# validate_domain_change.sh - Script para validar despliegue de dominio
# Uso: ./validate_domain_change.sh <dominio.com>

set -e

DOMAIN="$1"
if [ -z "$DOMAIN" ]; then
    echo "❌ Error: Debes especificar el dominio a validar"
    echo "Uso: $0 <dominio.com>"
    exit 1
fi

echo "🔍 Validando despliegue en: $DOMAIN"
echo "⏰ Inicio: $(date)"
echo "════════════════════════════════════════"

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Contadores
TESTS_PASSED=0
TESTS_FAILED=0
TESTS_WARNING=0

# Función para mostrar resultado
test_result() {
    local test_name="$1"
    local status="$2"
    local message="$3"
    
    case $status in
        "PASS")
            echo -e "${GREEN}✅ PASS${NC} $test_name"
            ((TESTS_PASSED++))
            ;;
        "FAIL")
            echo -e "${RED}❌ FAIL${NC} $test_name"
            echo -e "   ${RED}→${NC} $message"
            ((TESTS_FAILED++))
            ;;
        "WARN")
            echo -e "${YELLOW}⚠️  WARN${NC} $test_name"
            echo -e "   ${YELLOW}→${NC} $message"
            ((TESTS_WARNING++))
            ;;
    esac
}

# Función para hacer HTTP request y mostrar código
http_test() {
    local url="$1"
    local method="${2:-GET}"
    local expected_code="${3:-200}"
    local description="$4"
    
    echo -e "\n${BLUE}🌐 Test HTTP: $description${NC}"
    echo "   URL: $url"
    echo "   Método: $method"
    
    # Ejecutar request con timeout
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" \
        --max-time 10 \
        -X "$method" \
        "$url" 2>/dev/null || echo "000")
    
    if [ "$HTTP_CODE" = "$expected_code" ]; then
        test_result "HTTP $method $url" "PASS" "Código $HTTP_CODE"
    else
        test_result "HTTP $method $url" "FAIL" "Código $HTTP_CODE (esperaba $expected_code)"
    fi
}

# Función para test de API
api_test() {
    local url="$1"
    local data="$2"
    local description="$3"
    
    echo -e "\n${BLUE}🔌 Test API: $description${NC}"
    echo "   URL: $url"
    
    # Ejecutar request POST
    RESPONSE=$(curl -s \
        --max-time 10 \
        -X POST \
        -d "$data" \
        -H "Content-Type: application/x-www-form-urlencoded" \
        "$url" 2>/dev/null || echo '{"error":"connection_failed"}')
    
    # Verificar si es JSON válido
    if echo "$RESPONSE" | jq . >/dev/null 2>&1; then
        ERROR_MSG=$(echo "$RESPONSE" | jq -r '.error // empty')
        if [ -z "$ERROR_MSG" ]; then
            test_result "API POST $url" "PASS" "Respuesta JSON válida"
        else
            test_result "API POST $url" "FAIL" "Error en API: $ERROR_MSG"
        fi
    else
        test_result "API POST $url" "FAIL" "Respuesta no válida: $RESPONSE"
    fi
}

# Función para test de assets
asset_test() {
    local url="$1"
    local description="$2"
    
    echo -e "\n${BLUE}📁 Test Asset: $description${NC}"
    echo "   URL: $url"
    
    # Verificar que el asset exista y cargue
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" \
        --max-time 10 \
        "$url" 2>/dev/null || echo "000")
    
    # También verificar Content-Type para algunos tipos
    CONTENT_TYPE=$(curl -s -I \
        --max-time 10 \
        "$url" 2>/dev/null | grep -i content-type | cut -d' ' -f2- | tr -d '\r\n')
    
    if [ "$HTTP_CODE" = "200" ]; then
        test_result "Asset $url" "PASS" "Código 200, Tipo: $CONTENT_TYPE"
    else
        test_result "Asset $url" "FAIL" "Código $HTTP_CODE"
    fi
}

# Función para test de WebSocket
websocket_test() {
    local ws_url="$1"
    local description="$2"
    
    echo -e "\n${BLUE}🔌 Test WebSocket: $description${NC}"
    echo "   URL: $ws_url"
    
    # Test simple con timeout
    if command -v wscat &> /dev/null; then
        timeout 5 wscat -c "$ws_url" >/dev/null 2>&1 && \
            test_result "WebSocket $ws_url" "PASS" "Conexión exitosa" || \
            test_result "WebSocket $ws_url" "FAIL" "No se pudo conectar"
    else
        test_result "WebSocket $ws_url" "WARN" "wscat no disponible para test"
    fi
}

# Iniciar tests
echo -e "\n${BLUE}🚀 INICIANDO PRUEBAS DE DESPLIEGUE${NC}"

# Test 1: Página principal
http_test "https://$DOMAIN/frontend/login.php" "GET" "200" "Página de login"

# Test 2: Dashboard (puede redirigir a login)
http_test "https://$DOMAIN/frontend/dashboard.php" "GET" "200" "Dashboard"

# Test 3: API endpoint principal
api_test "https://$DOMAIN/backend/core/api-endpoint.php" "datosEncriptados=test" "API Endpoint principal"

# Test 4: Assets CSS
asset_test "https://$DOMAIN/frontend/assets/css/main.css" "CSS principal"

# Test 5: Assets JS
asset_test "https://$DOMAIN/frontend/assets/js/module-loader.js" "JS module loader"

# Test 6: Vendor assets
asset_test "https://$DOMAIN/frontend/vendors/bootstrap/css/bootstrap.min.css" "Bootstrap CSS"

# Test 7: Load resource proxy
http_test "https://$DOMAIN/frontend/load_resource.php" "GET" "200" "Load resource proxy"

# Test 8: WebSocket (si está configurado)
websocket_test "wss://$DOMAIN:9002" "WebSocket principal"

# Test 9: Verificar configuración del dominio
echo -e "\n${BLUE}🔍 Verificación de configuración${NC}"
DOMAIN_IN_CONFIG=$(curl -s "https://$DOMAIN/frontend/login.php" 2>/dev/null | grep -o "$DOMAIN" | head -1)
if [ "$DOMAIN_IN_CONFIG" = "$DOMAIN" ]; then
    test_result "Configuración de dominio" "PASS" "Dominio encontrado en la aplicación"
else
    test_result "Configuración de dominio" "FAIL" "Dominio no encontrado en la aplicación"
fi

# Test 10: Verificar headers de seguridad
echo -e "\n${BLUE}🔒 Verificación de seguridad${NC}"
SECURITY_HEADERS=$(curl -s -I "https://$DOMAIN/frontend/login.php" 2>/dev/null)
if echo "$SECURITY_HEADERS" | grep -qi "x-frame-options"; then
    test_result "Security headers" "PASS" "X-Frame-Options presente"
else
    test_result "Security headers" "WARN" "Algunos headers de seguridad faltan"
fi

# Test 11: Verificar que no haya errores de PHP
echo -e "\n${BLUE}🐛 Verificación de errores PHP${NC}"
ERROR_RESPONSE=$(curl -s "https://$DOMAIN/frontend/login.php" 2>/dev/null)
if echo "$ERROR_RESPONSE" | grep -qi "fatal error\|parse error\|warning"; then
    test_result "Errores PHP" "FAIL" "Se detectaron errores PHP en la respuesta"
else
    test_result "Errores PHP" "PASS" "No se detectaron errores PHP"
fi

# Test 12: Verificar tiempo de respuesta
echo -e "\n${BLUE}⏱️  Verificación de rendimiento${NC}"
RESPONSE_TIME=$(curl -o /dev/null -s -w "%{time_total}" "https://$DOMAIN/frontend/login.php" 2>/dev/null)
if (( $(echo "$RESPONSE_TIME < 2.0" | bc -l) )); then
    test_result "Tiempo de respuesta" "PASS" "${RESPONSE_TIME}s"
else
    test_result "Tiempo de respuesta" "WARN" "${RESPONSE_TIME}s (mayor a 2s)"
fi

# Resumen final
echo -e "\n${BLUE}📊 RESUMEN DE VALIDACIÓN${NC}"
echo "════════════════════════════════════════"
echo -e "✅ Pruebas pasadas: ${GREEN}$TESTS_PASSED${NC}"
echo -e "❌ Pruebas fallidas: ${RED}$TESTS_FAILED${NC}"
echo -e "⚠️  Advertencias: ${YELLOW}$TESTS_WARNING${NC}"
echo ""

TOTAL_TESTS=$((TESTS_PASSED + TESTS_FAILED + TESTS_WARNING))

if [ $TESTS_FAILED -eq 0 ]; then
    if [ $TESTS_WARNING -eq 0 ]; then
        echo -e "${GREEN}🎉 EXCELENTE: Todas las pruebas pasaron ($TOTAL_TESTS/$TOTAL_TESTS)${NC}"
        echo -e "${GREEN}✅ El despliegue está listo para producción${NC}"
        exit 0
    else
        echo -e "${YELLOW}✅ BUENO: Todas las pruebas críticas pasaron ($TESTS_PASSED/$TOTAL_TESTS)${NC}"
        echo -e "${YELLOW}⚠️  Revisa las advertencias antes de producción${NC}"
        exit 0
    fi
else
    echo -e "${RED}❌ PROBLEMAS: $TESTS_FAILED pruebas fallaron de $TOTAL_TESTS${NC}"
    echo -e "${RED}🚨 No es recomendable ir a producción sin solucionar los fallos${NC}"
    echo ""
    echo -e "${BLUE}💡 Sugerencias:${NC}"
    echo "  1. Revisa los logs de errores: tail -f /var/log/apache2/error.log"
    echo "  2. Verifica la configuración de Apache/Nginx"
    echo "  3. Ejecuta rollback si es necesario: ./rollback_domain.sh"
    exit 1
fi
