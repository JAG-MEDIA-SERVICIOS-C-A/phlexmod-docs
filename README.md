
# PHLEXMOD Framework

![PHP Version](https://img.shields.io/badge/php-%3E%3D8.2-8892BF.svg)
![Status](https://img.shields.io/badge/status-beta-orange.svg)
![Demo](https://img.shields.io/badge/demo-online-brightgreen.svg)

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

1. **Prueba la demo en vivo:**
   Visita [phlexmod.jagmedia.com.ve](https://phlexmod.jagmedia.com.ve) con las credenciales de prueba.

2. **Explora la documentación:**
   Lee la [Arquitectura MIA](./MIA_Architecture.md) para entender los principios del framework.

3. **¿Interesado en el código?**
   El código fuente está en evaluación para licenciamiento. Contáctanos para más información.

---

## 💬 Contacto

Estamos abiertos a feedback, sugerencias y consultas sobre el framework.

- **Demo:** [phlexmod.jagmedia.com.ve](https://phlexmod.jagmedia.com.ve)
- **Documentación:** [GitHub - phlexmod-docs](https://github.com/JAG-MEDIA-SERVICIOS-C-A/phlexmod-docs)
- **Email:** soporte@jag-media.com.ve

---

## 📄 Licencia

El código fuente de PHLEXMOD está actualmente en evaluación para licenciamiento. La documentación se publica bajo **Creative Commons Attribution 4.0 (CC BY 4.0)**.

&copy; 2025 JAG-MEDIA Servicios, C.A.
