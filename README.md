# fixture-voley
# 🏐 Sistema de Fixture y Tabla de Posiciones de Vóley

**Materia:** Tecnología Web II (TEW-500)
**Docente:** Lic. Jeannette Mamani
**Metodología:** RUP (Proceso Unificado Racional) con prácticas de Scrum.

---

## 1. Descripción del Proyecto
Este sistema permite la gestión completa de un torneo de vóley. Cuenta con dos módulos principales:
*   **Panel Administrativo:** Gestión de usuarios, equipos, permisos, generación de fixture, registro de resultados y publicación de la tabla de posiciones.
*   **Portal Público:** Consulta de fixture, resultados y tabla de posiciones para los visitantes.

## 2. Tecnologías Utilizadas
*   **Backend:** PHP (PDO)
*   **Base de Datos:** MySQL / MariaDB
*   **Frontend:** HTML5, CSS3, JavaScript (AJAX/Fetch API)
*   **Control de Versiones:** Git + GitHub

---

## 3. Equipo de Desarrollo (Scrum Team)
*   **Scrum Master:** Coronel Casas Loida Geraldine
*   **Desarrolladores:** 
    *   Concha Nina Jhoselin
    *   Castro Callisaya Sebastián
    *   Condori Ramírez Ángel Kevin

---

## 4. Estructura de Carpetas
Para mantener el orden, el código debe subirse siguiendo esta estructura. **Por favor, no crear carpetas fuera de estas:**

```text
📦 fixture-voley
 ┣ 📂 assets/       # Imágenes, logos, iconos
 ┣ 📂 css/          # Archivos de estilos (style.css)
 ┣ 📂 js/           # Archivos JavaScript (validaciones.js)
 ┣ 📂 php/          # Lógica de backend
 ┃ ┣ 📂 controladores/  # Lógica de negocio (ej: login_controller.php)
 ┃ ┣ 📂 modelos/        # Consultas a la BD (ej: equipo_model.php)
 ┃ ┗ 📂 vistas/         # Archivos HTML/PHP de las pantallas
 ┣ 📂 sql/          # Scripts de la base de datos (script_oficial.sql)
 ┣ 📜 conexion.php  # Archivo de conexión a la base de datos (PDO)
 ┗ 📜 README.md     # Este archivo
```
## 5. Guía para subir código (¡LEER ANTES DE HACER PUSH!)
Para evitar conflictos y que el código de uno borre el del otro, sigan estas reglas:

Regla de Oro: "Pull antes de Push"
**Nunca suban código sin antes descargar los cambios de los demás.**

*  Abrir la terminal en la carpeta del proyecto.
*  Descargar cambios: git pull origin main
*  Agregar tus archivos: git add .
*  Hacer el commit: git commit -m "Módulo de Login terminado" (Escriban un mensaje claro de lo que hicieron).
*  Subir los cambios: git push origin main

### Reglas del Equipo:
NO subir archivos de configuración local: No suban archivos como .env, config.php con contraseñas locales, ni carpetas como vendor/ o node_modules/.

*  NO tocar el código de los demás sin avisar: Si necesitan modificar algo que hizo otro compañero, avisen primero por el grupo de WhatsApp.
*  Mantener los nombres claros: Usen nombres de archivos en minúsculas y sin espacios (ej: registrar_equipo.php).
##6. Configuración de la Base de Datos
Abrir MariaDB / phpMyAdmin.
Ejecutar el script que se encuentra en sql/DB_TEW-500.txt
Configurar las credenciales en conexion.php:

```text
$host = "localhost";
$db_name = "db_fixture_voley";
$username = "root"; // Cambiar si es necesario
$password = "";     // Cambiar si es necesario
```

