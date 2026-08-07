-- =====================================================
-- SCHEMA Y FUNCIONES RPC PARA BIBLIOTECA LUX EN SUPABASE
-- =====================================================
-- Copia y pega este contenido completo en:
-- Tu proyecto Supabase → SQL Editor → New Query
-- Luego pulsa "Run"
-- =====================================================

-- 1. Tabla de usuarios
CREATE TABLE IF NOT EXISTS usuarios (
  id BIGSERIAL PRIMARY KEY,
  nombre TEXT NOT NULL,
  tipo TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT now()
);

-- 2. Tabla de categorías
CREATE TABLE IF NOT EXISTS categorias (
  id BIGSERIAL PRIMARY KEY,
  nombre TEXT NOT NULL UNIQUE,
  created_at TIMESTAMP DEFAULT now()
);

-- 3. Tabla de libros
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

-- 4. Tabla de préstamos
CREATE TABLE IF NOT EXISTS prestamos (
  id BIGSERIAL PRIMARY KEY,
  usuario_id BIGINT REFERENCES usuarios(id) ON DELETE CASCADE,
  libro_id BIGINT REFERENCES libros(id) ON DELETE CASCADE,
  fecha_prestamo DATE NOT NULL DEFAULT CURRENT_DATE,
  fecha_devolucion DATE,
  dias_limite INTEGER DEFAULT 7,
  created_at TIMESTAMP DEFAULT now()
);

-- =====================================================
-- HABILITAR ROW LEVEL SECURITY (RLS)
-- =====================================================

ALTER TABLE usuarios ENABLE ROW LEVEL SECURITY;
ALTER TABLE categorias ENABLE ROW LEVEL SECURITY;
ALTER TABLE libros ENABLE ROW LEVEL SECURITY;
ALTER TABLE prestamos ENABLE ROW LEVEL SECURITY;

-- Políticas permisivas (Drop si existen para evitar conflictos al re-ejecutar)
DROP POLICY IF EXISTS "Select usuarios" ON usuarios;
DROP POLICY IF EXISTS "Insert usuarios" ON usuarios;
DROP POLICY IF EXISTS "Update usuarios" ON usuarios;
CREATE POLICY "Select usuarios" ON usuarios FOR SELECT USING (true);
CREATE POLICY "Insert usuarios" ON usuarios FOR INSERT WITH CHECK (true);
CREATE POLICY "Update usuarios" ON usuarios FOR UPDATE USING (true);

DROP POLICY IF EXISTS "Select categorias" ON categorias;
DROP POLICY IF EXISTS "Insert categorias" ON categorias;
DROP POLICY IF EXISTS "Update categorias" ON categorias;
CREATE POLICY "Select categorias" ON categorias FOR SELECT USING (true);
CREATE POLICY "Insert categorias" ON categorias FOR INSERT WITH CHECK (true);
CREATE POLICY "Update categorias" ON categorias FOR UPDATE USING (true);

DROP POLICY IF EXISTS "Select libros" ON libros;
DROP POLICY IF EXISTS "Insert libros" ON libros;
DROP POLICY IF EXISTS "Update libros" ON libros;
CREATE POLICY "Select libros" ON libros FOR SELECT USING (true);
CREATE POLICY "Insert libros" ON libros FOR INSERT WITH CHECK (true);
CREATE POLICY "Update libros" ON libros FOR UPDATE USING (true);

DROP POLICY IF EXISTS "Select prestamos" ON prestamos;
DROP POLICY IF EXISTS "Insert prestamos" ON prestamos;
DROP POLICY IF EXISTS "Update prestamos" ON prestamos;
CREATE POLICY "Select prestamos" ON prestamos FOR SELECT USING (true);
CREATE POLICY "Insert prestamos" ON prestamos FOR INSERT WITH CHECK (true);
CREATE POLICY "Update prestamos" ON prestamos FOR UPDATE USING (true);


-- =====================================================
-- FUNCIONES ALMACENADAS (RPC) PARA EJECUCIÓN EN SUPABASE
-- =====================================================

-- A) Función Atómica para Prestar Libro
CREATE OR REPLACE FUNCTION fn_prestar_libro(
  p_usuario_id BIGINT,
  p_libro_id BIGINT,
  p_dias INTEGER DEFAULT 7
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_disponible BOOLEAN;
  v_titulo TEXT;
  v_usuario_nombre TEXT;
  v_prestamo_id BIGINT;
BEGIN
  -- 1. Verificar existencia del usuario
  SELECT nombre INTO v_usuario_nombre FROM usuarios WHERE id = p_usuario_id;
  IF v_usuario_nombre IS NULL THEN
    RETURN jsonb_build_object('success', false, 'message', 'El usuario especificado no existe.');
  END IF;

  -- 2. Verificar existencia y disponibilidad del libro
  SELECT disponible, titulo INTO v_disponible, v_titulo FROM libros WHERE id = p_libro_id FOR UPDATE;
  IF v_titulo IS NULL THEN
    RETURN jsonb_build_object('success', false, 'message', 'El libro especificado no existe.');
  END IF;
  
  IF v_disponible IS FALSE THEN
    RETURN jsonb_build_object('success', false, 'message', 'El libro "' || v_titulo || '" ya se encuentra prestado.');
  END IF;

  -- 3. Crear el registro de préstamo
  INSERT INTO prestamos (usuario_id, libro_id, fecha_prestamo, dias_limite)
  VALUES (p_usuario_id, p_libro_id, CURRENT_DATE, COALESCE(p_dias, 7))
  RETURNING id INTO v_prestamo_id;

  -- 4. Marcar libro como prestado
  UPDATE libros SET disponible = false WHERE id = p_libro_id;

  RETURN jsonb_build_object(
    'success', true,
    'message', 'Préstamo registrado exitosamente.',
    'prestamo_id', v_prestamo_id,
    'libro_titulo', v_titulo,
    'usuario_nombre', v_usuario_nombre,
    'fecha_limite', CURRENT_DATE + (COALESCE(p_dias, 7) || ' days')::INTERVAL
  );
EXCEPTION WHEN OTHERS THEN
  RETURN jsonb_build_object('success', false, 'message', 'Error interno al procesar el préstamo: ' || SQLERRM);
END;
$$;


-- B) Función Atómica para Devolver Libro
CREATE OR REPLACE FUNCTION fn_devolver_libro(
  p_libro_id BIGINT,
  p_usuario_id BIGINT DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_prestamo_record RECORD;
  v_titulo TEXT;
  v_dias_transcurridos INTEGER;
  v_a_tiempo BOOLEAN;
BEGIN
  -- 1. Obtener información del libro
  SELECT titulo INTO v_titulo FROM libros WHERE id = p_libro_id FOR UPDATE;
  IF v_titulo IS NULL THEN
    RETURN jsonb_build_object('success', false, 'message', 'El libro especificado no existe.');
  END IF;

  -- 2. Buscar préstamo activo
  IF p_usuario_id IS NOT NULL THEN
    SELECT * INTO v_prestamo_record FROM prestamos
    WHERE libro_id = p_libro_id AND usuario_id = p_usuario_id AND fecha_devolucion IS NULL
    ORDER BY id DESC LIMIT 1 FOR UPDATE;
  ELSE
    SELECT * INTO v_prestamo_record FROM prestamos
    WHERE libro_id = p_libro_id AND fecha_devolucion IS NULL
    ORDER BY id DESC LIMIT 1 FOR UPDATE;
  END IF;

  IF v_prestamo_record.id IS NULL THEN
    -- Forzar actualización de disponibilidad si por alguna razón no había registro pero estaba en false
    UPDATE libros SET disponible = true WHERE id = p_libro_id;
    RETURN jsonb_build_object('success', true, 'message', 'El libro "' || v_titulo || '" fue marcado como disponible.');
  END IF;

  -- 3. Marcar devolución en la tabla de préstamos
  UPDATE prestamos
  SET fecha_devolucion = CURRENT_DATE
  WHERE id = v_prestamo_record.id;

  -- 4. Marcar libro como disponible
  UPDATE libros SET disponible = true WHERE id = p_libro_id;

  -- 5. Calcular si la devolución fue a tiempo
  v_dias_transcurridos := CURRENT_DATE - v_prestamo_record.fecha_prestamo;
  v_a_tiempo := (v_dias_transcurridos <= COALESCE(v_prestamo_record.dias_limite, 7));

  RETURN jsonb_build_object(
    'success', true,
    'message', 'Devolución procesada correctamente.',
    'libro_titulo', v_titulo,
    'dias_transcurridos', v_dias_transcurridos,
    'a_tiempo', v_a_tiempo
  );
EXCEPTION WHEN OTHERS THEN
  RETURN jsonb_build_object('success', false, 'message', 'Error interno al procesar la devolución: ' || SQLERRM);
END;
$$;


-- C) Función de Consulta de Inventario Optimizada
CREATE OR REPLACE FUNCTION fn_consultar_inventario(
  p_categorias TEXT[] DEFAULT NULL,
  p_busqueda TEXT DEFAULT NULL
)
RETURNS TABLE (
  id BIGINT,
  titulo TEXT,
  autor TEXT,
  categoria TEXT,
  editorial TEXT,
  disponible BOOLEAN,
  palabras_clave JSONB
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  RETURN QUERY
  SELECT l.id, l.titulo, l.autor, l.categoria, l.editorial, l.disponible, l.palabras_clave
  FROM libros l
  WHERE (p_categorias IS NULL OR CARDINALITY(p_categorias) = 0 OR l.categoria = ANY(p_categorias))
    AND (p_busqueda IS NULL OR p_busqueda = '' OR (
          l.titulo ILIKE '%' || p_busqueda || '%' OR
          l.autor ILIKE '%' || p_busqueda || '%' OR
          l.categoria ILIKE '%' || p_busqueda || '%' OR
          l.palabras_clave::text ILIKE '%' || p_busqueda || '%'
        ))
  ORDER BY l.titulo ASC;
END;
$$;


-- D) Función para Métricas y Estadísticas Globales
CREATE OR REPLACE FUNCTION fn_obtener_estadisticas()
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_total_usuarios INT;
  v_total_libros INT;
  v_libros_disponibles INT;
  v_prestamos_activos INT;
  v_prestamos_vencidos INT;
BEGIN
  SELECT COUNT(*) INTO v_total_usuarios FROM usuarios;
  SELECT COUNT(*) INTO v_total_libros FROM libros;
  SELECT COUNT(*) INTO v_libros_disponibles FROM libros WHERE disponible = true;
  SELECT COUNT(*) INTO v_prestamos_activos FROM prestamos WHERE fecha_devolucion IS NULL;
  
  SELECT COUNT(*) INTO v_prestamos_vencidos 
  FROM prestamos 
  WHERE fecha_devolucion IS NULL 
    AND (CURRENT_DATE - fecha_prestamo) > COALESCE(dias_limite, 7);

  RETURN jsonb_build_object(
    'total_usuarios', v_total_usuarios,
    'total_libros', v_total_libros,
    'libros_disponibles', v_libros_disponibles,
    'libros_prestados', (v_total_libros - v_libros_disponibles),
    'prestamos_activos', v_prestamos_activos,
    'prestamos_vencidos', v_prestamos_vencidos
  );
END;
$$;

-- Otorgar permisos de ejecución para anon y authenticated
GRANT EXECUTE ON FUNCTION fn_prestar_libro TO anon, authenticated;
GRANT EXECUTE ON FUNCTION fn_devolver_libro TO anon, authenticated;
GRANT EXECUTE ON FUNCTION fn_consultar_inventario TO anon, authenticated;
GRANT EXECUTE ON FUNCTION fn_obtener_estadisticas TO anon, authenticated;

-- =====================================================
-- FIN DEL SETUP CON FUNCIONES RPC
-- =====================================================
