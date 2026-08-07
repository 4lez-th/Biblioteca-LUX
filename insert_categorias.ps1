$headers = @{
  'apikey'        = 'sb_publishable_daIZivHp77OzgMgEDnvKQA_WVhqhCGK'
  'Authorization' = 'Bearer sb_publishable_daIZivHp77OzgMgEDnvKQA_WVhqhCGK'
  'Prefer'        = 'return=representation'
}

$categorias = @(
  'Literatura',
  'Ciencia Ficcion',
  'Historia',
  'Filosofia',
  'Tecnologia',
  'Thriller',
  'Fantasia',
  'Desarrollo Personal',
  'Psicologia',
  'Economia',
  'Ciencia',
  'Novela',
  'Programacion'
)

foreach ($cat in $categorias) {
  $body = [System.Text.Encoding]::UTF8.GetBytes(('{"nombre":"' + $cat + '"}'))
  try {
    Invoke-RestMethod `
      -Uri 'https://qzanordyttklascfmozy.supabase.co/rest/v1/categorias' `
      -Method Post `
      -Body $body `
      -ContentType 'application/json' `
      -Headers $headers | Out-Null
    Write-Host "[OK] $cat"
  } catch {
    Write-Host "[SKIP] $cat"
  }
}

Write-Host "`nCategorias listas."
