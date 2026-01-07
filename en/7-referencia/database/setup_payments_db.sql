-- Script de inicialización para módulo de pagos BDV
-- Ejecutar este script en la base de datos PostgreSQL del proyecto

-- 1. Tabla de proveedores de pago
CREATE TABLE IF NOT EXISTS payment_providers (
    id SERIAL PRIMARY KEY,
    key VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    active BOOLEAN DEFAULT TRUE,
    empresa_id INT,
    created_by INT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- 2. Tabla de credenciales de clientes
CREATE TABLE IF NOT EXISTS payment_client_credentials (
    id SERIAL PRIMARY KEY,
    provider_id INT REFERENCES payment_providers(id),
    environment VARCHAR(20) NOT NULL CHECK (environment IN ('test', 'production')),
    affiliate VARCHAR(100) NOT NULL,
    password_encrypted TEXT,
    password_hint VARCHAR(100),
    extra JSONB,
    active BOOLEAN DEFAULT TRUE,
    empresa_id INT,
    created_by INT,
    updated_by INT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP,
    UNIQUE (provider_id, environment, affiliate)
);

-- 3. Tabla de endpoints de proveedores (opcional, para configuración dinámica)
CREATE TABLE IF NOT EXISTS payment_provider_endpoints (
    id SERIAL PRIMARY KEY,
    provider_id INT REFERENCES payment_providers(id),
    name VARCHAR(50) NOT NULL,
    base_url VARCHAR(255) NOT NULL,
    path VARCHAR(255),
    method VARCHAR(10) DEFAULT 'POST',
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW()
);

-- 4. Tabla de auditoría de pagos
CREATE TABLE IF NOT EXISTS payment_audit_logs (
    id SERIAL PRIMARY KEY,
    provider_key VARCHAR(50),
    provider_id INT,
    endpoint VARCHAR(100),
    endpoint_id INT,
    empresa_id INT,
    user_uid INT,
    ip VARCHAR(45),
    user_agent TEXT,
    base_url TEXT,
    request_payload JSONB,
    response_status INT,
    response_body TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- 5. Insertar proveedor inicial (BDV IPG)
INSERT INTO payment_providers (key, name, active) 
VALUES ('bdv_ipg', 'BDV IPG', true)
ON CONFLICT (key) DO NOTHING;

-- 6. Insertar endpoints por defecto para BDV IPG (Ambiente Demo)
-- Nota: En producción se deben actualizar estas URLs
INSERT INTO payment_provider_endpoints (provider_id, name, base_url, path)
SELECT id, 'oauth_token', 'https://biodemo.ex-cle.com:4443', '/Biopago2/IPG2/connect/token'
FROM payment_providers WHERE key = 'bdv_ipg'
ON CONFLICT DO NOTHING;

INSERT INTO payment_provider_endpoints (provider_id, name, base_url, path)
SELECT id, 'create_payment', 'https://biodemo.ex-cle.com:4443', '/Biopago2/IPG2/api/Payments'
FROM payment_providers WHERE key = 'bdv_ipg'
ON CONFLICT DO NOTHING;
