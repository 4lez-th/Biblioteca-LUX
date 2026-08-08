DOCUMENTACIÓN - Biblioteca LUX (Supabase + GitHub)
=================================================

Resumen Corto
-------------
Este proyecto publica una interfaz web para gestionar la biblioteca LUX. Los datos reales (usuarios, libros, categorías y préstamos) se almacenan y sincronizan en tiempo real en una base de datos **Supabase**. La aplicación web está alojada y publicada mediante **GitHub Pages**.

**Sitio Web Publicado**: https://4lez-th.github.io/Biblioteca-LUX/

Archivos Importantes del Proyecto
---------------------------------
- `index.html` / `LIBRERIAlux.html`: Página web principal. Contiene la interfaz gráfica, estilos y la integración cliente con Supabase SDK.
- `setup_supabase.sql`: Script SQL completo para crear la estructura de la base de datos (tablas `usuarios`, `categorias`, `libros`, `prestamos`), habilitar políticas de seguridad RLS y funciones atómicas RPC (`fn_prestar_libro`, `fn_devolver_libro`, etc.).
- `LIBRERIAlux`: Código Python con las clases orientadas a objetos del prototipo (`Usuario`, `Libro`, `Prestamo`, `Reportes`).
- `DOCUMENTACION_SUPABASE.md`: Este archivo con la guía técnica completa.

Configuración de Supabase
-------------------------
El proyecto está conectado a Supabase con las siguientes credenciales configuradas en `index.html` y `LIBRERIAlux.html`:
- **URL del proyecto**: `https://qzanordyttklascfmozy.supabase.co`
- **Anon Key**: `sb_publishable_daIZivHp77OzgMgEDnvKQA_WVhqhCGK`

Para desplegar o recrear la base de datos en un nuevo entorno Supabase:
1. Ve al menú **SQL Editor** en tu panel de Supabase.
2. Abre y copia todo el contenido del archivo `setup_supabase.sql`.
3. Ejecuta el script (**Run**). Esto creará las 4 tablas, activará RLS y registrará las funciones de préstamos.

Estructura de la Base de Datos (`setup_supabase.sql`)
---------------------------------------------------
1) **usuarios**: `id (bigserial)`, `nombre (text)`, `tipo (text)`, `created_at (timestamp)`
2) **categorias**: `id (bigserial)`, `nombre (text unique)`, `created_at (timestamp)`
3) **libros**: `id (bigserial)`, `titulo (text)`, `autor (text)`, `categoria (text)`, `editorial (text)`, `palabras_clave (jsonb)`, `disponible (boolean)`, `created_at (timestamp)`
4) **prestamos**: `id (bigserial)`, `usuario_id (references usuarios)`, `libro_id (references libros)`, `fecha_prestamo (date)`, `fecha_devolucion (date)`, `dias_limite (integer)`, `created_at (timestamp)`

Cómo usar la Interfaz Web
-------------------------
1. **Ver Libros y Buscar**: Usa la barra de búsqueda superior para filtrar por título o autor, o selecciona una categoría específica en el menú desplegable.
2. **Prestar un Libro**:
   - Haz clic en cualquier libro disponible en la lista para abrir su ventana modal de detalles.
   - Selecciona el usuario en la lista desplegable.
   - Pulsa el botón **"Prestar"**.
3. **Devolver un Libro**:
   - Haz clic en un libro actualmente prestado.
   - Pulsa el botón **"Devolver"**.
4. **Panel Admin (Gestión)**:
   - Haz clic en **"Abrir panel admin"** en la parte superior.
   - Agrega nuevos usuarios, libros o categorías. Los selectores de la página se actualizarán automáticamente.

Despliegue y Repositorio en GitHub
----------------------------------
- **Repositorio**: `4lez-th/Biblioteca-LUX`
- **Rama de despliegue**: `gh-pages`
- **URL pública**: `https://4lez-th.github.io/Biblioteca-LUX/`

Para subir y actualizar cambios a GitHub en el futuro:
```bash
git add .
git commit -m "Actualización de la biblioteca"
git push origin gh-pages
```

