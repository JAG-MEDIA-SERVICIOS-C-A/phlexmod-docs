# 🎨 Branding Guidelines - PHLEXMOD v2.0.1

## 📋 Overview

PHLEXMOD v2.0.1 cuenta con un sistema de branding profesional que incluye logos para PHLEXMOD Framework, JAG-Media y MIA Architecture.

---

## 🏢 Brand Assets

### **PHLEXMOD Framework**

<div align="center">
  <img src="../frontend/assets/img/logo-sitio/phlexmod/logo-black.webp" alt="PHLEXMOD Logo" width="200">
</div>

- **Archivo**: `frontend/assets/img/logo-sitio/phlexmod/logo-black.webp`
- **Dimensiones**: 206x48px
- **Formato**: WEBP
- **Tamaño**: 4.7KB
- **Uso**: Principal para PHLEXMOD Framework

<div align="center">
  <img src="../frontend/assets/img/logo-sitio/phlexmod/logo-white.webp" alt="PHLEXMOD Logo White" width="200">
</div>

- **Archivo**: `frontend/assets/img/logo-sitio/phlexmod/logo-white.webp`
- **Dimensiones**: 206x48px
- **Formato**: WEBP
- **Tamaño**: 4.7KB
- **Uso**: Fondos oscuros

---

### **JAG-Media**

<div align="center">
  <img src="../frontend/assets/img/logo-sitio/jagmedia/logo-black.webp" alt="JAG-Media Logo" width="300">
</div>

- **Archivo**: `frontend/assets/img/logo-sitio/jagmedia/logo-black.webp`
- **Dimensiones**: 372x89px
- **Formato**: WEBP
- **Tamaño**: 2.9KB
- **Uso**: Principal para JAG-Media

<div align="center">
  <img src="../frontend/assets/img/logo-sitio/jagmedia/logo-white.webp" alt="JAG-Media Logo White" width="300">
</div>

- **Archivo**: `frontend/assets/img/logo-sitio/jagmedia/logo-white.webp`
- **Dimensiones**: 372x89px
- **Formato**: WEBP
- **Tamaño**: 2.9KB
- **Uso**: Fondos oscuros

---

### **MIA Architecture**

<div align="center">
  <img src="../frontend/assets/img/logo-sitio/mia/logo-largo-black.webp" alt="MIA Architecture Logo" width="400">
</div>

- **Archivo**: `frontend/assets/img/logo-sitio/mia/logo-largo-black.webp`
- **Dimensiones**: 1672x362px
- **Formato**: WEBP
- **Tamaño**: 26KB
- **Uso**: Principal para MIA Architecture

<div align="center">
  <img src="../frontend/assets/img/logo-sitio/mia/logo-largo-white.webp" alt="MIA Architecture Logo White" width="400">
</div>

- **Archivo**: `frontend/assets/img/logo-sitio/mia/logo-largo-white.webp`
- **Dimensiones**: 1672x362px
- **Formato**: WEBP
- **Tamaño**: 26KB
- **Uso**: Fondos oscuros

---

## 🎨 Usage Guidelines

### **CSS Integration**

```css
/* Importar branding CSS */
@import url('../frontend/assets/css/branding.css');

/* Usar variables CSS */
.logo-phlexmod {
  background-image: var(--logo-phlexmod-black);
  width: var(--logo-phlexmod-width);
  height: var(--logo-phlexmod-height);
}

.logo-jagmedia {
  background-image: var(--logo-jagmedia-black);
  width: var(--logo-jagmedia-width);
  height: var(--logo-jagmedia-height);
}

.logo-mia {
  background-image: var(--logo-mia-largo-black);
  width: var(--logo-mia-width);
  height: var(--logo-mia-height);
}
```

### **JavaScript Integration**

```javascript
// Importar branding manager
import './frontend/assets/js/branding.js';

// Usar funciones globales
setPhlexmodLogo('black', '.logo-container');
setJagmediaLogo('white', '.header-logo');
setMiaLogo('black', '.footer-logo');

// Crear logos dinámicamente
const brandingManager = window.brandingManager;
const logoHTML = brandingManager.createLogoHTML('phlexmod', 'black', 'responsive-logo');
document.querySelector('.logo-placeholder').innerHTML = logoHTML;
```

### **HTML Integration**

```html
<!-- Logo PHLEXMOD -->
<div class="logo-phlexmod" role="img" aria-label="PHLEXMOD Framework"></div>

<!-- Logo JAG-Media -->
<div class="logo-jagmedia" role="img" aria-label="JAG-Media"></div>

<!-- Logo MIA -->
<div class="logo-mia" role="img" aria-label="MIA Architecture"></div>

<!-- Logo con tema automático -->
<div class="logo-phlexmod auto-theme" role="img" aria-label="PHLEXMOD Framework"></div>
```

---

## 📱 Responsive Design

### **Breakpoints**

- **Desktop (>768px)**: 100% tamaño
- **Tablet (768px)**: 70-80% tamaño
- **Mobile (<480px)**: 50-60% tamaño

### **CSS Media Queries**

```css
@media (max-width: 768px) {
  .logo-phlexmod {
    width: calc(var(--logo-phlexmod-width) * 0.8);
    height: calc(var(--logo-phlexmod-height) * 0.8);
  }
}

@media (max-width: 480px) {
  .logo-phlexmod {
    width: calc(var(--logo-phlexmod-width) * 0.6);
    height: calc(var(--logo-phlexmod-height) * 0.6);
  }
}
```

---

## 🌙 Theme Support

### **Dark Mode**

Los logos se adaptan automáticamente al tema del sistema:

```css
@media (prefers-color-scheme: dark) {
  .logo-phlexmod.auto-theme {
    background-image: var(--logo-phlexmod-white);
  }
}
```

### **Manual Theme Switching**

```javascript
// Cambiar a tema oscuro
document.querySelectorAll('.logo-phlexmod').forEach(logo => {
  logo.classList.add('white');
});

// Cambiar a tema claro
document.querySelectorAll('.logo-phlexmod').forEach(logo => {
  logo.classList.remove('white');
});
```

---

## ⚡ Performance Optimization

### **WebP Benefits**

- **40% más pequeño** que PNG
- **Calidad visual** idéntica
- **Carga más rápida** que SVG
- **Soporte universal** en navegadores modernos

### **Lazy Loading**

```html
<div class="logo-phlexmod lazy" 
     data-src="../frontend/assets/img/logo-sitio/phlexmod/logo-black.webp"
     role="img" 
     aria-label="PHLEXMOD Framework">
</div>
```

### **Image Optimization**

```javascript
// Optimización automática
const brandingManager = window.brandingManager;
brandingManager.setupLazyLoading();
brandingManager.setupResponsiveLogos();
```

---

## 🎯 Best Practices

### **✅ Do's**

- Usar formato WEBP para mejor rendimiento
- Incluir alt text para accesibilidad
- Usar CSS variables para consistencia
- Implementar lazy loading
- Adaptar tamaños según contexto

### **❌ Don'ts**

- No redimensionar logos con CSS (usa versiones apropiadas)
- No usar formatos pesados (PNG, SVG)
- No omitir alt text
- No hardcode rutas relativas
- No ignorar responsive design

---

## 🔧 Technical Specifications

### **File Formats**

| Brand | Format | Dimensions | Size | Usage |
|-------|---------|------------|------|-------|
| PHLEXMOD | WEBP | 206x48px | 4.7KB | Framework |
| JAG-Media | WEBP | 372x89px | 2.9KB | Company |
| MIA | WEBP | 1672x362px | 26KB | Architecture |

### **Color Specifications**

- **Primary**: #2563eb (Blue)
- **Secondary**: #1e40af (Dark Blue)
- **Accent**: #3b82f6 (Light Blue)
- **Text Light**: #ffffff (White)
- **Text Dark**: #1f2937 (Dark Gray)

---

## 📞 Contact

For branding questions or requests:

- **Email**: branding@jagmedia.com.ve
- **GitHub**: [Issues](https://github.com/JAG-MEDIA-SERVICIOS-C-A/Phlexmod/issues)
- **Website**: https://jagmedia.com.ve

---

*Last updated: PHLEXMOD v2.0.1 - December 2025*
