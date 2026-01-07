> ⚠️ **TRANSLATION PENDING:** This document is currently in Spanish. Contributions to translate it to English are welcome.

# Guía de Contribución para PHLEXMOD v2.0.1

*Framework PHLEXMOD v2.0.1*  
*Última actualización: 2025-12-30*  
*Creado por JAG-Media Servicios, C.A.*  

¡Gracias por tu interés en contribuir a PHLEXMOD! Estamos construyendo una herramienta para desarrolladores pragmáticos y tu ayuda es invaluable. Para asegurar que el proceso sea fluido y efectivo para todos, hemos establecido algunas guías.

## 💡 Cómo Empezar

¿Tienes una idea para una mejora o encontraste un bug? ¡Genial! Antes de empezar a escribir código, por favor, sigue este paso previo:

1. **Abre un "Issue"**: Ve a la sección de [Issues](https://github.com/JAG-MEDIA-SERVICIOS-C-A/Phlexmod/issues) y abre un nuevo issue. Esto nos permite discutir el cambio, asegurarnos de que se alinea con la visión del proyecto y evitar que trabajes en algo que podría ser rechazado más tarde.
    * Para un **bug**, descríbelo con la mayor cantidad de detalles posible.
    * Para una **nueva característica**, explica qué problema resuelve y cómo encaja en la filosofía de PHLEXMOD.

## 🐞 Reporte de Bugs

Un buen reporte de bug es la forma más rápida de conseguir una solución. Por favor, incluye:

* **Versión de PHLEXMOD**: La versión que estás utilizando.
* **Versión de PHP**: La versión de tu entorno PHP.
* **Pasos para Reproducir**: Una descripción clara y concisa de cómo podemos replicar el error.
* **Comportamiento Esperado**: ¿Qué debería haber pasado?
* **Comportamiento Actual**: ¿Qué pasó en realidad? (Incluye mensajes de error, logs, etc.)

## 🚀 Sugerencia de Mejoras

Estamos abiertos a nuevas ideas, pero valoramos la simplicidad y la coherencia con los principios de MIA. Al proponer una mejora, pregúntate:

* ¿Esta característica respeta el **Principio de Aislamiento Estricto**?
* ¿Se comunica a través de **Contratos de Interfaz** claros?
* ¿Considera la **Seguridad Intrínseca**?

Explica el "porqué" detrás de tu idea. ¿Qué caso de uso habilita? ¿Qué problema resuelve?

## 流程 Proceso de Pull Request (PR)

Una vez que hemos discutido y aprobado tu idea en un "Issue", ¡es hora de programar!

1. **Haz un Fork** del repositorio a tu propia cuenta de GitHub.
2. **Crea una Nueva Rama**: Nombra tu rama de forma descriptiva (ej. `fix/login-bug` o `feature/new-cache-system`).

    ```bash
    git checkout -b feature/mi-nueva-caracteristica
    ```

3. **Escribe tu Código**: Asegúrate de seguir los estándares de código del proyecto (ver abajo).
4. **Abre un Pull Request**: Envía tu PR a la rama `main` de PHLEXMOD. En la descripción, enlaza al "Issue" original que discutimos (ej. "Closes #123").
5. **Revisión de Código**: Espera a que uno de los mantenedores revise tu código. Estaremos abiertos a dar feedback para pulir la contribución.

## ✍️ Estándares de Código

La legibilidad es clave. Aunque no imponemos un estándar de formato estricto, te pedimos que:

* **Imites el Código Existente**: La mejor guía es el propio código del framework. Mantén la coherencia en el estilo de nombrado, la estructura y los comentarios.
* **Comenta el "Porqué", no el "Qué"**: Tu código debe ser legible por sí mismo. Usa comentarios para explicar decisiones complejas o el razonamiento detrás de una pieza de lógica, no para describir lo que hace una línea.
* **Una Función, una Tarea**: Mantén tus funciones pequeñas y enfocadas en una sola responsabilidad.

Gracias de nuevo por tu tiempo y dedicación. ¡Construyamos algo grande juntos!
