# Troubleshooting Guide - PHLEXMOD Migration

## Common Issues and Solutions

### 1. Resources Not Loading (404/400 on load_resource.php)

**Symptoms:**

- 404 or 400 errors on `load_resource.php/TOKEN/file.js`
- Application loads but without CSS, JS, images
- Login works but resources fail

**Root Cause:**
PATH_INFO not properly configured in Nginx for URLs like `/load_resource.php/TOKEN/file`

**Solution:**
Change URL format from PATH_INFO to GET parameters:

```php
// In /var/www/html/phlexmod/backend/core/proxy-helper.php line 169:

// BEFORE (PATH_INFO - doesn't work):
return $baseUrl . 'load_resource.php/' . $token . '/' . ltrim($relativePath, '/');

// NOW (GET parameters - works):
return $baseUrl . 'load_resource.php?r=' . $token . '&f=' . ltrim($relativePath, '/');
```

**Steps to apply:**

1. Edit `/var/www/html/phlexmod/backend/core/proxy-helper.php`
2. Modify line 169 as shown above
3. Clear cache: `redis-cli flushall`
4. Restart PHP-FPM: `sudo systemctl restart php8.4-fpm`
5. Verify new URLs in page source code

### 2. WebFonts Not Loading (404 on /webfonts/ and /fonts/)

**Symptoms:**

- 404 errors on `/webfonts/fa-solid-900.woff2`
- 404 errors on `/fonts/line/unicons-14.woff2`
- FontAwesome and Unicons icons not displaying

**Root Cause:**
CSS files reference relative paths that don't exist in project structure.

**Solution:**
Create symbolic links to actual locations:

```bash
# Symbolic links for fonts
sudo ln -sf /var/www/html/phlexmod/frontend/vendors/fontawesome/webfonts /var/www/html/phlexmod/webfonts
sudo ln -sf /var/www/html/phlexmod/frontend/vendors/unicons/fonts /var/www/html/phlexmod/fonts
```

**Verification:**

```bash
# Test URLs
curl -I "https://phlexmod.mia-architecture.com/webfonts/fa-solid-900.woff2"
curl -I "https://phlexmod.mia-architecture.com/fonts/line/unicons-14.woff2"
```

### 3. Nginx Configuration for New Domain

**Symptoms:**

- ERR_EMPTY_RESPONSE when accessing new domain
- Incorrect redirects
- SSL not working

**Solution:**
Replicate exact configuration from old domain:

```bash
# Copy existing configuration
sudo cp /etc/nginx/sites-available/phlexmod.conf /etc/nginx/sites-available/phlexmod.mia-architecture.com.conf

# Change domain name
sudo sed -i 's/server_name phlexmod\.jagmedia\.com\.ve;/server_name phlexmod.mia-architecture.com;/g' /etc/nginx/sites-available/phlexmod.mia-architecture.com.conf

# Update SSL certificates
sudo sed -i 's|/etc/letsencrypt/live/phlexmod\.jagmedia\.com\.ve/|/etc/letsencrypt/live/phlexmod.mia-architecture.com/|g' /etc/nginx/sites-available/phlexmod.mia-architecture.com.conf

# Enable and reload
sudo ln -sf /etc/nginx/sites-available/phlexmod.mia-architecture.com.conf /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl reload nginx

# Configure SSL with Certbot
sudo certbot --nginx -d phlexmod.mia-architecture.com --redirect --non-interactive --agree-tos --email admin@mia-architecture.com
```

### 4. Restart Critical Services

**WebSocket:**

```bash
# Kill zombie process if exists
sudo pkill -f websocket-manager.php

# Fix WorkingDirectory in service if needed
sudo sed -i 's|WorkingDirectory=/var/www/html/flexmod|WorkingDirectory=/var/www/html/phlexmod|' /etc/systemd/system/phlexmod-websocket.service

# Restart service
sudo systemctl daemon-reload
sudo systemctl restart phlexmod-websocket.service
```

**Redis:**

```bash
sudo systemctl restart redis
redis-cli ping  # Should respond PONG
```

**PHP-FPM:**

```bash
sudo systemctl restart php8.4-fpm
```

### 5. Cache Cleanup

**Redis:**

```bash
redis-cli flushall
```

**File cache:**

```bash
sudo rm -rf /var/www/html/phlexmod/cache/*
```

**OPcache:**

```bash
sudo systemctl restart php8.4-fpm
```

## Final Verification

After applying solutions, verify:

```bash
# 1. Login works
curl -I "https://phlexmod.mia-architecture.com/frontend/login.php"

# 2. Resources with GET parameters work
curl -I "https://phlexmod.mia-architecture.com/frontend/load_resource.php?r=TOKEN&f=file.js"

# 3. Fonts load
curl -I "https://phlexmod.mia-architecture.com/webfonts/fa-solid-900.woff2"

# 4. WebSocket active
sudo systemctl status phlexmod-websocket.service

# 5. Redis functional
redis-cli ping
```

## Important Notes

1. **PATH_INFO vs GET**: GET parameters are more reliable than PATH_INFO in Nginx
2. **Symbolic links**: Useful for maintaining compatibility with hardcoded paths
3. **Cache**: Always clear cache after structural changes
4. **Services**: Restart services in order: Redis → PHP-FPM → Nginx → WebSocket
5. **SSL**: Certbot overwrites configurations, apply fixes after running it

## Contact and Support

- Documentation updated: [Creation date]
- Valid for: PHLEXMOD on Ubuntu 20.04+ with Nginx, PHP-FPM 8.2 (default) + PHP-FPM 8.4 (PHLEXMOD), Redis
- Example domain: phlexmod.mia-architecture.com
