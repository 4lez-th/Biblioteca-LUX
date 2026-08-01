-- =====================================================
-- SCHEMA PARA BIBLIOTECA LUX EN SUPABASE
-- =====================================================
-- Copia y pega este contenido completo en:
-- Tu proyecto Supabase → SQL Editor → New Query
-- Luego pulsa "Run"
-- =====================================================

-- Tabla de usuarios
CREATE TABLE IF NOT EXISTS usuarios (
  id BIGSERIAL PRIMARY KEY,
  nombre TEXT NOT NULL,
  tipo TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT now()
);

-- Tabla de categorías
CREATE TABLE IF NOT EXISTS categorias (
  id BIGSERIAL PRIMARY KEY,
  nombre TEXT NOT NULL UNIQUE,
  created_at TIMESTAMP DEFAULT now()
);

-- Tabla de libros
CREATE TABLE IF NOT EXISTS libros (
  id BIGSERIAL PRIMARY KEY,
  titulo TEXT NOT NULL,
  autor TEXT,
  categoria TEXT,
  editorial TEXT,
  palabras_clave JSONB DEFAULT '[]',
  disponible BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT now()
);

-- Tabla de préstamos
CREATE TABLE IF NOT EXISTS prestamos (
  id BIGSERIAL PRIMARY KEY,
  usuario_id BIGINT REFERENCES usuarios(id) ON DELETE CASCADE,
  libro_id BIGINT REFERENCES libros(id) ON DELETE CASCADE,
  fecha_prestamo DATE NOT NULL,
  fecha_devolucion DATE,
  created_at TIMESTAMP DEFAULT now()
);

-- =====================================================
-- HABILITAR ROW LEVEL SECURITY (RLS)
-- Para este prototipo, permitimos lectura/escritura pública
-- En producción, configura políticas más restrictivas
-- =====================================================

ALTER TABLE usuarios ENABLE ROW LEVEL SECURITY;
ALTER TABLE categorias ENABLE ROW LEVEL SECURITY;
ALTER TABLE libros ENABLE ROW LEVEL SECURITY;
ALTER TABLE prestamos ENABLE ROW LEVEL SECURITY;

-- Políticas permisivas para este prototipo (sin autenticación requerida)
CREATE POLICY "Select usuarios" ON usuarios FOR SELECT USING (true);
CREATE POLICY "Insert usuarios" ON usuarios FOR INSERT WITH CHECK (true);
CREATE POLICY "Update usuarios" ON usuarios FOR UPDATE USING (true);

CREATE POLICY "Select categorias" ON categorias FOR SELECT USING (true);
CREATE POLICY "Insert categorias" ON categorias FOR INSERT WITH CHECK (true);
CREATE POLICY "Update categorias" ON categorias FOR UPDATE USING (true);

CREATE POLICY "Select libros" ON libros FOR SELECT USING (true);
CREATE POLICY "Insert libros" ON libros FOR INSERT WITH CHECK (true);
CREATE POLICY "Update libros" ON libros FOR UPDATE USING (true);

CREATE POLICY "Select prestamos" ON prestamos FOR SELECT USING (true);
CREATE POLICY "Insert prestamos" ON prestamos FOR INSERT WITH CHECK (true);
CREATE POLICY "Update prestamos" ON prestamos FOR UPDATE USING (true);

-- =====================================================
-- FIN DEL SETUP
-- =====================================================
