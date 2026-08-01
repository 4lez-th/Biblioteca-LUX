DOCUMENTACIÓN - Biblioteca LUX (Supabase)
=========================================

Resumen corto (en palabras sencillas)
-------------------------------------
Este proyecto publica una interfaz web para gestionar una biblioteca. Los datos reales (usuarios, libros, categorías, préstamos) se guardarán en una base de datos Supabase. Tú, como administrador, podrás agregar y gestionar estos datos directamente desde la página usando el "Panel Admin".

Archivos importantes
-------------------
- `LIBRERIAlux.html`: Página web principal. Contiene el diseño, la lógica de cliente y el panel admin.
- `LIBRERIAlux`      : Código Python con las clases del prototipo (sin datos de ejemplo).
- `DOCUMENTACION_SUPABASE.md`: Este archivo con instrucciones.

Esquema de la base de datos (sugerido)
-------------------------------------
Crea estas tablas en Supabase (puedes usar SQL en la sección SQL editor):

1) usuarios
```sql
create table usuarios (
  id serial primary key,
  nombre text not null,
  tipo text
);
```

2) categorias
```sql
create table categorias (
  id serial primary key,
  nombre text not null
);
```

3) libros
```sql
create table libros (
  id serial primary key,
  titulo text not null,
  autor text,
  categoria text,
  editorial text,
  palabras_clave jsonb,
  disponible boolean default true
);
```

4) prestamos
```sql
create table prestamos (
  id serial primary key,
  usuario_id integer references usuarios(id),
  libro_id integer references libros(id),
  fecha_prestamo date,
  fecha_devolucion date
);
```

Configurar Supabase
-------------------
1) Ve a https://app.supabase.com y crea un proyecto.
2) En el proyecto, entra a "Settings -> API" y copia:
   - URL del proyecto (algo como `https://xyz.supabase.co`)
   - anon key (public)
3) En la página web (biblioteca), pulsa "Configurar Supabase" y pega la URL y la anon key.
   - Estos valores se guardan en `localStorage` de tu navegador.

Cómo usar el Panel Admin (desde la web)
--------------------------------------
- Pulsa "Abrir panel admin".
- Agrega Usuarios: llena nombre y tipo (ej. estudiante, docente).
- Agrega Libros: título, autor, categoría.
- Agrega Categorías: nombre de la categoría.
- Tras agregar, la lista de opciones en la página se actualiza automáticamente.

Operaciones disponibles desde la interfaz
-----------------------------------------
- Prestar: selecciona Usuario, Libro y la acción "Prestar" y pulsa "Ejecutar acción".
  - Inserta una fila en `prestamos` y marca `libros.disponible = false`.
- Devolver: selecciona Usuario, Libro y la acción "Devolver" y pulsa "Ejecutar acción".
  - Marca la fecha_devolucion en el préstamo y pone `libros.disponible = true`.
- Consultar: selecciona categorías y la acción "Consultar" para ver libros que coincidan.

Seguridad y notas
-----------------
- La página usa la anon key pública de Supabase. Eso es suficiente para operaciones de lectura/escritura si las reglas de RLS lo permiten. Para producción, configura Row Level Security (RLS) y políticas que restrinjan quién puede escribir o borrar.
- Esta integración es para un prototipo y facilita administración desde el navegador. Para más seguridad, crea endpoints backend que firmen requests o controlen permisos.

Si te falta algo
----------------
- Si quieres, puedo:
  - Añadir validaciones más robustas en el panel Admin.
  - Crear un pequeño backend que actúe como intermediario seguro.
  - Generar scripts SQL para crear tablas automáticamente en Supabase.

Contacto rápido
---------------
- Dime si quieres que yo cree las tablas SQL por ti y las ejecute (necesitarás compartir acceso a Supabase o pegar el SQL en el editor).

Gracias — listo para la siguiente parte cuando lo indiques.
