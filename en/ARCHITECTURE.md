# PHLEXMOD: Enterprise Application Operating System

**Architecture Version:** 2.1 (MIA-C4I Hybrid)
**Kernel:** PostgreSQL 10+
**Passive Hardware:** PHP 8.4
**Status:** Production Ready

---

## 1. MIA-C4I Architectural Vision

PHLEXMOD abandons the traditional "framework" definition to establish itself as a **Relational State Management System**. We do not manage objects; we manage the organization's will reflected in data.

### MIA (Modular Isolation Architecture) - Physical Sovereignty
In PHLEXMOD, a module is not an abstract class; it is a sovereign physical territory.
*   **Radical Independence:** Each module (`/backend/modules/sales`, `/backend/modules/hr`) contains its own logic (API), its own face (UI), and its own brain (JS).
*   **Resilience by Isolation:** Corruption of a file in the Inventory module is physically incapable of stopping the Billing module. They share no memory, they share no global state.
*   **Maintenance as Hardware:** Updating a module is equivalent to changing a graphics card: you take the old one out, put the new one in. The rest of the system does not notice.

### C4I (Command, Control, Communications, Computers, Intelligence) - The Central Government
If MIA is the fragmented body, C4I is the centralized soul.
*   **Command (The Will):** The database decides what exists. If a menu is not in the `setting_menu` table, the code on disk is irrelevant.
*   **Control (The Authority):** The `setting_privilege_user` table defines the access topology. Security is not "programmed"; it is "declared" in SQL.
*   **Intelligence (The Truth):** PHP code does not make strategic decisions; it only executes tactical orders defined by metadata.

---

## 2. The Existence Model (Dark Matter)

In PHLEXMOD physics, files on the hard drive are considered **Dark Matter**: they exist physically but do not interact with the logical universe until they are "illuminated" by the Kernel (Database).

### The Engine as a Metadata Interpreter
The `engine.php` file **is not a router**. It does not "decide" where to go.
1.  Receives coordinates (Menu ID).
2.  Consults the Kernel (PostgreSQL) if those coordinates have mass (existence).
3.  If the answer is positive, it "materializes" the corresponding PHP file via an isolated `include`.
4.  If the answer is negative, the file remains in darkness (404/403), inert and unreachable.

---

## 3. Binary Security and Numerical Topology

Security in PHLEXMOD does not rely on complex middleware or code annotations. It is **topological and numerical**.

### Range Segmentation (Defense in Depth)
The system uses numerical ID ranges to physically segregate access levels:
*   **< 1000 (System Core):** Low-level processes, invisible to the user.
*   **1000 - 8999 (User Space):** Standard business operations.
*   **>= 9000 (Admin Space):** Critical administration and configuration functions.
*   *Effect:* A standard user (ID < 9000) cannot, by mathematical definition, execute an administrative process, regardless of bugs in the code.

### The Atomic Privilege Matrix
We abandon the simplistic CRUD (Read/Write) for a governmental audit matrix:
1.  **Register:** Create the intent.
2.  **Certify:** Validate the truth of the data (Immutable).
3.  **Annul:** Revoke validity (Logical).
4.  **Reverse:** Accounting error correction (Auditable).
*This matrix guarantees that no destructive action goes unnoticed.*

---

## 4. Ephemeral Context Injection Flow

Each HTTP request is a universe that is born and dies in milliseconds. There are no persistent sessions on the application server; all state is cryptographically reconstructed.

1.  **The Token (The Passport):** The client sends an encrypted token. It contains no session data, it contains **identity**.
2.  **Decryption (Customs):** `engine.php` decrypts the token using rotating keys. Obtains `UID` (Who you are).
3.  **The Security JOIN (The Judgment):**
    ```sql
    SELECT 1 FROM setting_privilege_user
    JOIN setting_menu ON ...
    WHERE user_id = :uid AND menu_id = :requested_menu
    ```
    *This is the critical moment. If this query returns no rows, the system stops time for that request.*
4.  **The Injection (The Birth):** If the judgment is favorable, the requested module is injected into the execution flow. It inherits the DB context and executes its logic.
5.  **The Death:** Upon script termination, all memory is freed. Nothing remains on the server.

---

## 5. Technical Sovereignty Manual (Zero Magic)

PHLEXMOD rejects the "Black Boxes" of modern development.

### Why not use .env?
The `.env` file is a crutch for lazy developers. In production, it is a security risk (plaintext, slow parsing).
*   **Our Solution:** `core-config.php`. Native PHP. Compiled by OPcache. Fast. Secure. Inaccessible via web.

### Why not use Composer in the Core?
"Dependency Hell" is the greatest threat to long-term system sovereignty.
*   **Our Solution:** Everything needed for the system to *live* is in the repository. If GitHub or Packagist disappears tomorrow, PHLEXMOD keeps operating. Libraries are tools, not foundations.

### Why direct SQL?
ORMs (Object-Relational Mappers) add latency and hide data truth.
*   **Our Solution:** We speak the native language of the Kernel (SQL). This allows optimizations no ORM can dream of and ensures the architect understands their data.

---

## 6. The Inconvenient Truth (SPOF)

**Single Point of Failure: The Database.**

In PHLEXMOD, we are honest: **If PostgreSQL dies, the system ceases to exist.**
There is no "last known session" cache. There is no "offline mode" for business logic.
*   **The Advantage:** Absolute Consistency. You will never see outdated data.
*   **The Cost:** Database availability is infrastructure priority number 1.

> "Code is ephemeral. Data is eternal. Protect the data."
