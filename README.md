
# PHLEXMOD Framework

![PHP Version](https://img.shields.io/badge/php-%3E%3D8.1-8892BF.svg)
![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Contributions Welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg)

**Un framework PHP pragmático, enfocado en la seguridad y el aislamiento modular.**

¿Atrapado entre la complejidad de los grandes frameworks monolíticos y el caos operativo de los microservicios? PHLEXMOD nace en las trincheras del desarrollo empresarial para ofrecer un equilibrio: la robustez de un núcleo cohesivo con la flexibilidad de módulos verdaderamente independientes.

Nuestra filosofía es la **Arquitectura de Aislamiento Modular (MIA)**.

## 🌐 Demo en Vivo

Explora PHLEXMOD funcionando:

**[https://phlexmod.jagmedia.com.ve](https://phlexmod.jagmedia.com.ve)**

> **Credenciales de prueba:** Usuario: `demo` | Contraseña: `PhlexDemo2025!`

---

## 🏛️ La Arquitectura de Aislamiento Modular (MIA)

MIA no es un patrón teórico, es un conjunto de reglas de desarrollo probadas en combate. Se basa en tres principios inquebrantables:

1. **Principio de Aislamiento Estricto**: Cada módulo es una "caja negra" soberana. Posee sus propios endpoints, lógica y UI. ¿Quieres eliminar un módulo? Borras su carpeta. ¿Quieres moverlo a otro proyecto? Lo copias. Sin dependencias ocultas ni efectos colaterales.

2. **Principio de Contratos de Interfaz**: La comunicación entre el motor y los módulos se realiza exclusivamente a través de "contratos" (un objeto de configuración bien definido). Esto elimina la "magia" y hace que el flujo de datos sea predecible y depurable.

3. **Principio de Seguridad Intrínseca**: La seguridad no es una ocurrencia tardía, es la base. Cada punto de entrada, desde el motor hasta el último endpoint de un módulo, implementa una "Zona de Sanitización" obligatoria, asegurando que ningún dato externo entre al sistema sin ser validado.

Lee la documentación completa de la arquitectura aquí: **[MIA Architecture Document](./docs/MIA_Architecture.md)**

---

## ✨ Características Principales

- **Motor de Módulos Dinámico**: Carga módulos de forma segura basándose en los privilegios del usuario definidos en la base de datos.
- **Seguridad Multi-capa**: Protección contra XSS, Inyección SQL, CSRF, y encriptación de parámetros sensibles por defecto.
- **Sistema de Plantillas Nativas**: Separación limpia de la lógica (PHP) y la presentación (PHP/HTML) sin necesidad de un motor de plantillas de terceros. Reutiliza componentes de UI de forma sencilla.
- **Herramientas de Línea de Comandos (`phlex`)**: Andamiaje para crear módulos, endpoints, gestionar la base de datos y mucho más.
- **Soporte Multi-idioma**: Estructura simple basada en archivos JSON para la internacionalización.
- **Gestión de Sesiones Segura**: Control de sesiones con medidas de seguridad robustas.

---

## 🚀 Inicio Rápido

Empezar a trabajar con PHLEXMOD es muy sencillo.

1.  **Clona el repositorio:**
    ```bash
    git clone https://github.com/JAG-MEDIA-SERVICIOS-C-A/Phlexmod.git
    cd Phlexmod
    ```

2.  **Instala las dependencias:**
    (Asegúrate de tener [Composer](https://getcomposer.org/) instalado)
    ```bash
    composer install
    ```

3.  **Configura el núcleo:**
    Copia `core-config.sample.php` a `core-config.php` y edítalo con los detalles de tu base de datos y entorno.
    ```bash
    cp core-config.sample.php core-config.php
    ```

4.  **Ejecuta el instalador:**
    Navega en tu navegador al directorio `/installs/` y sigue los pasos para configurar la base de datos y tu usuario administrador.

5.  **¡Listo!**
    Accede a la URL de tu proyecto para ver la página de inicio de sesión.

---

## 🤝 Cómo Contribuir

¡Las contribuciones son el corazón del código abierto! Estamos abiertos a tus ideas, reportes de bugs y pull requests.

1.  Lee nuestra **[Guía de Contribución](./CONTRIBUTING.md)** para entender nuestros estándares.
2.  Reporta un bug o sugiere una mejora abriendo un **[Issue](https://github.com/JAG-MEDIA-SERVICIOS-C-A/Phlexmod/issues)**.
3.  ¿Quieres añadir una característica? Haz un **[Fork](https://github.com/JAG-MEDIA-SERVICIOS-C-A/Phlexmod/fork)** del proyecto y envía un Pull Request.

**Si te gusta la filosofía de PHLEXMOD, ¡considera darle una estrella ⭐ al repositorio!**

---

## 📄 Licencia

PHLEXMOD Framework está licenciado bajo la **[Licencia MIT](./LICENSE)**. Eres libre de usarlo, modificarlo y distribuirlo en proyectos personales y comerciales.

&copy; 2025 JAG-MEDIA Servicios, C.A.
