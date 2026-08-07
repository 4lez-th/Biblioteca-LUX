$headers = @{
  'apikey' = 'sb_publishable_daIZivHp77OzgMgEDnvKQA_WVhqhCGK'
  'Authorization' = 'Bearer sb_publishable_daIZivHp77OzgMgEDnvKQA_WVhqhCGK'
  'Prefer' = 'return=representation'
}

# Test 1: INSERT prestamo
Write-Host "--- TEST 1: INSERT prestamo libro_id=4, usuario_id=1 ---"
$body = '{"usuario_id":1,"libro_id":4,"fecha_prestamo":"2026-08-07"}'
try {
  $res = Invoke-RestMethod -Uri 'https://qzanordyttklascfmozy.supabase.co/rest/v1/prestamos' -Method Post -Body $body -ContentType 'application/json' -Headers $headers
  Write-Host "OK - Prestamo creado con ID:" $res.id
  $prestamoId = $res.id
} catch {
  Write-Host "ERROR INSERT prestamo:" $_.Exception.Message
  $prestamoId = $null
}

# Test 2: UPDATE libro disponible=false
Write-Host "`n--- TEST 2: UPDATE libro disponible=false ---"
$bodyLib = '{"disponible":false}'
try {
  $res2 = Invoke-RestMethod -Uri 'https://qzanordyttklascfmozy.supabase.co/rest/v1/libros?id=eq.4' -Method Patch -Body $bodyLib -ContentType 'application/json' -Headers $headers
  Write-Host "OK - Libro actualizado a disponible=false"
} catch {
  Write-Host "ERROR UPDATE libro:" $_.Exception.Message
}

# Test 3: GET prestamos activos
Write-Host "`n--- TEST 3: GET prestamos activos (sin devolucion) ---"
try {
  $prestamos = Invoke-RestMethod -Uri 'https://qzanordyttklascfmozy.supabase.co/rest/v1/prestamos?select=*&fecha_devolucion=is.null' -Headers $headers
  Write-Host "Prestamos activos:" $prestamos.Count
  $prestamos | Format-Table id, usuario_id, libro_id, fecha_prestamo
} catch {
  Write-Host "ERROR GET prestamos:" $_.Exception.Message
}

# Test 4: Si se creo el prestamo, devolverlo
if ($prestamoId) {
  Write-Host "`n--- TEST 4: PATCH devolucion prestamo ID $prestamoId ---"
  $bodyDev = '{"fecha_devolucion":"2026-08-07"}'
  try {
    $res4 = Invoke-RestMethod -Uri "https://qzanordyttklascfmozy.supabase.co/rest/v1/prestamos?id=eq.$prestamoId" -Method Patch -Body $bodyDev -ContentType 'application/json' -Headers $headers
    Write-Host "OK - Devolucion registrada"
  } catch {
    Write-Host "ERROR PATCH devolucion:" $_.Exception.Message
  }

  # Test 5: Restaurar libro
  Write-Host "`n--- TEST 5: Restaurar libro disponible=true ---"
  $bodyLib2 = '{"disponible":true}'
  try {
    Invoke-RestMethod -Uri 'https://qzanordyttklascfmozy.supabase.co/rest/v1/libros?id=eq.4' -Method Patch -Body $bodyLib2 -ContentType 'application/json' -Headers $headers | Out-Null
    Write-Host "OK - Libro restaurado a disponible=true"
  } catch {
    Write-Host "ERROR restaurar libro:" $_.Exception.Message
  }
}

Write-Host "`n=== PRUEBAS TERMINADAS ==="
