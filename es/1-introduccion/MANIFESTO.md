# PHLEXMOD: Sistema Operativo de Aplicaciones Empresariales

**Versión de Arquitectura:** 2.1 (MIA-C4I Hybrid)
**Kernel:** PostgreSQL 10+
**Hardware Pasivo:** PHP 8.4
**Estado:** Production Ready

---

## 1. Visión Arquitectónica (MIA-C4I)

PHLEXMOD abandona la definición tradicional de "framework" para constituirse como un **Sistema de Gestión de Estado Relacional**. No gestionamos objetos; gestionamos la voluntad de la organización reflejada en datos.

### MIA (Modular Isolation Architecture) - La Soberanía Física

En PHLEXMOD, un módulo no es una clase abstracta; es un territorio físico soberano.

- **Independencia Radical:** Cada módulo (`/backend/modules/ventas`, `/backend/modules/rrhh`) contiene su propia lógica (API), su propia cara (UI) y su propio cerebro (JS).
- **Resiliencia por Aislamiento:** La corrupción de un archivo en el módulo de Inventario es físicamente incapaz de detener el módulo de Facturación. No comparten memoria, no comparten estado global.
- **Mantenimiento como Hardware:** Actualizar un módulo es equivalente a cambiar una tarjeta gráfica: sacas la vieja, pones la nueva. El resto del sistema no se entera.

### C4I (Command, Control, Communications, Computers, Intelligence) - El Gobierno Central

Si MIA es el cuerpo fragmentado, C4I es el alma centralizada.

- **Command (La Voluntad):** La base de datos decide qué existe. Si un menú no está en la tabla `setting_menu`, el código en disco es irrelevante.
- **Control (La Autoridad):** La tabla `setting_privilege_user` define la topología de acceso. La seguridad no se "programa"; se "declara" en SQL.
- **Intelligence (La Verdad):** El código PHP no toma decisiones estratégicas; solo ejecuta órdenes tácticas definidas por los metadatos.

---

## 2. El Modelo de Existencia (Materia Oscura)

En la física de PHLEXMOD, los archivos en el disco duro se consideran **Materia Oscura**: existen físicamente pero no interactúan con el universo lógico hasta que son "iluminados" por el Kernel (Base de Datos).

### El Engine como Intérprete de Metadatos

El archivo `engine.php` **no es un enrutador**. No "decide" a dónde ir.

1.  Recibe coordenadas (ID de Menú).
2.  Consulta al Kernel (PostgreSQL) si esas coordenadas tienen masa (existencia).
3.  Si la respuesta es positiva, "materializa" el archivo PHP correspondiente mediante un `include` aislado.
4.  Si la respuesta es negativa, el archivo permanece en la oscuridad (404/403), inerte e inalcanzable.

---

## 3. Seguridad Binaria y Topología Numérica

La seguridad en PHLEXMOD no depende de middlewares complejos ni de anotaciones en el código. Es **topológica y numérica**.

### Segmentación por Rangos (Defensa en Profundidad)

El sistema utiliza rangos numéricos de IDs para segregar físicamente los niveles de acceso:

- **< 1000 (System Core):** Procesos de bajo nivel, invisibles al usuario.
- **1000 - 8999 (User Space):** Operaciones estándar de negocio.
- **>= 9000 (Admin Space):** Funciones críticas de administración y configuración.
- _Efecto:_ Un usuario estándar (ID < 9000) no puede, por definición matemática, ejecutar un proceso administrativo, independientemente de los bugs en el código.

### La Matriz de Privilegios Atómicos

Abandonamos el CRUD simplista (Leer/Escribir) por una matriz de auditoría gubernamental:

1.  **Registrar:** Crear la intención.
2.  **Certificar:** Validar la verdad del dato (Inmutable).
3.  **Anular:** Revocar la validez (Lógica).
4.  **Reversar:** Corrección de errores contables (Auditable).
    _Esta matriz garantiza que ninguna acción destructiva pase desapercibida._

---

## 4. Flujo de Inyección de Contexto Efímero

Cada petición HTTP es un universo que nace y muere en milisegundos. No hay sesiones persistentes en el servidor de aplicaciones; todo el estado se reconstruye criptográficamente.

1.  **El Token (El Pasaporte):** El cliente envía un token encriptado. No contiene datos de sesión, contiene **identidad**.
2.  **La Desencriptación (Aduana):** `engine.php` desencripta el token usando llaves rotativas. Obtiene `UID` (Quién eres).
3.  **El JOIN de Seguridad (El Juicio):**
    ```sql
    SELECT 1 FROM setting_privilege_user
    JOIN setting_menu ON ...
    WHERE user_id = :uid AND menu_id = :requested_menu
    ```
    _Este es el momento crítico. Si esta consulta no devuelve filas, el sistema detiene el tiempo para esa petición._
4.  **La Inyección (El Nacimiento):** Si el juicio es favorable, el módulo solicitado se inyecta en el flujo de ejecución. Hereda el contexto de la BD y ejecuta su lógica.
5.  **La Muerte:** Al terminar el script, toda la memoria se libera. Nada queda en el servidor.

---

## 5. Manual de Soberanía Técnica (Zero Magic)

PHLEXMOD rechaza las "Cajas Negras" del desarrollo moderno.

### ¿Por qué no usamos .env?

El archivo `.env` es una muleta para desarrolladores perezosos. En producción, es un riesgo de seguridad (texto plano, parsing lento).

- **Nuestra Solución:** `core-config.php`. PHP nativo. Compilado por OPcache. Rápido. Seguro. Inaccesible vía web.

### ¿Por qué no usamos Composer en el Core?

El "Infierno de Dependencias" es la mayor amenaza a la soberanía de un sistema a largo plazo.

- **Nuestra Solución:** Todo lo necesario para que el sistema _viva_ está en el repositorio. Si mañana desaparece GitHub o Packagist, PHLEXMOD sigue operando. Las librerías son herramientas, no cimientos.

### ¿Por qué SQL directo?

Los ORMs (Object-Relational Mappers) añaden latencia y ocultan la verdad de los datos.

- **Nuestra Solución:** Hablamos el idioma nativo del Kernel (SQL). Esto permite optimizaciones que ningún ORM puede soñar y garantiza que el arquitecto entienda sus datos.

---

## 6. La Verdad Incómoda (SPOF)

**Single Point of Failure: La Base de Datos.**

En PHLEXMOD, somos honestos: **Si PostgreSQL muere, el sistema deja de existir.**
No hay caché de "última sesión conocida". No hay "modo offline" para la lógica de negocio.

- **La Ventaja:** Consistencia Absoluta. Nunca verás un dato desactualizado.
- **El Costo:** La disponibilidad de la Base de Datos es la prioridad número 1 de la infraestructura.

> "El código es efímero. El dato es eterno. Protege el dato."
