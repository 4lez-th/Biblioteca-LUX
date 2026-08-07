$headers = @{
  'apikey'        = 'sb_publishable_daIZivHp77OzgMgEDnvKQA_WVhqhCGK'
  'Authorization' = 'Bearer sb_publishable_daIZivHp77OzgMgEDnvKQA_WVhqhCGK'
  'Prefer'        = 'return=representation'
}

$libros = @(
  # Literatura Clasica
  @{ titulo='Cien años de soledad';        autor='Gabriel García Márquez';  categoria='Literatura';       editorial='Sudamericana';     disponible=$true },
  @{ titulo='Don Quijote de la Mancha';    autor='Miguel de Cervantes';     categoria='Literatura';       editorial='Alfaguara';        disponible=$true },
  @{ titulo='Crimen y castigo';            autor='Fiódor Dostoievski';      categoria='Literatura';       editorial='Alianza';          disponible=$true },
  @{ titulo='El gran Gatsby';              autor='F. Scott Fitzgerald';     categoria='Literatura';       editorial='Scribner';         disponible=$true },
  @{ titulo='Orgullo y prejuicio';         autor='Jane Austen';             categoria='Literatura';       editorial='Penguin';          disponible=$true },
  @{ titulo='Madame Bovary';               autor='Gustave Flaubert';        categoria='Literatura';       editorial='Gallimard';        disponible=$true },
  @{ titulo='Ana Karenina';                autor='León Tolstói';            categoria='Literatura';       editorial='Alba';             disponible=$true },
  @{ titulo='El proceso';                  autor='Franz Kafka';             categoria='Literatura';       editorial='Alianza';          disponible=$true },

  # Ciencia Ficcion
  @{ titulo='1984';                        autor='George Orwell';           categoria='Ciencia Ficción';  editorial='Secker & Warburg'; disponible=$true },
  @{ titulo='Un mundo feliz';              autor='Aldous Huxley';           categoria='Ciencia Ficción';  editorial='Chatto & Windus'; disponible=$true },
  @{ titulo='Fahrenheit 451';              autor='Ray Bradbury';            categoria='Ciencia Ficción';  editorial='Ballantine';       disponible=$true },
  @{ titulo='Dune';                        autor='Frank Herbert';           categoria='Ciencia Ficción';  editorial='Chilton Books';   disponible=$true },
  @{ titulo='Fundación';                   autor='Isaac Asimov';            categoria='Ciencia Ficción';  editorial='Gnome Press';     disponible=$true },
  @{ titulo='Neuromante';                  autor='William Gibson';          categoria='Ciencia Ficción';  editorial='Ace Books';       disponible=$true },
  @{ titulo='El marciano';                 autor='Andy Weir';               categoria='Ciencia Ficción';  editorial='Crown';           disponible=$true },
  @{ titulo='Ender''s Game';               autor='Orson Scott Card';        categoria='Ciencia Ficción';  editorial='Tor Books';       disponible=$true },

  # Historia y Filosofia
  @{ titulo='Sapiens';                     autor='Yuval Noah Harari';       categoria='Historia';         editorial='Harper Collins';   disponible=$true },
  @{ titulo='Homo Deus';                   autor='Yuval Noah Harari';       categoria='Historia';         editorial='Harper Collins';   disponible=$true },
  @{ titulo='El origen de las especies';   autor='Charles Darwin';          categoria='Ciencia';          editorial='John Murray';      disponible=$true },
  @{ titulo='El arte de la guerra';        autor='Sun Tzu';                 categoria='Filosofía';        editorial='Oxford';           disponible=$true },
  @{ titulo='La República';               autor='Platón';                  categoria='Filosofía';        editorial='Gredos';          disponible=$true },
  @{ titulo='Meditaciones';               autor='Marco Aurelio';            categoria='Filosofía';        editorial='Penguin Classics'; disponible=$true },
  @{ titulo='Así habló Zaratustra';        autor='Friedrich Nietzsche';     categoria='Filosofía';        editorial='Alianza';         disponible=$true },
  @{ titulo='El príncipe';                autor='Nicolás Maquiavelo';      categoria='Filosofía';        editorial='Alianza';         disponible=$true },

  # Tecnologia y Programacion
  @{ titulo='The Pragmatic Programmer';    autor='Andrew Hunt';             categoria='Tecnología';       editorial='Addison-Wesley';  disponible=$true },
  @{ titulo='Design Patterns';             autor='Gang of Four';            categoria='Tecnología';       editorial='Addison-Wesley';  disponible=$true },
  @{ titulo='You Don''t Know JS';          autor='Kyle Simpson';            categoria='Tecnología';       editorial='O''Reilly';       disponible=$true },
  @{ titulo='The Clean Coder';             autor='Robert C. Martin';        categoria='Tecnología';       editorial='Prentice Hall';   disponible=$true },
  @{ titulo='Introduction to Algorithms'; autor='Cormen et al.';           categoria='Tecnología';       editorial='MIT Press';       disponible=$true },
  @{ titulo='Deep Learning';              autor='Ian Goodfellow';          categoria='Tecnología';       editorial='MIT Press';       disponible=$true },
  @{ titulo='Artificial Intelligence';    autor='Stuart Russell';          categoria='Tecnología';       editorial='Pearson';         disponible=$true },

  # Novela y Thriller
  @{ titulo='El código Da Vinci';          autor='Dan Brown';               categoria='Thriller';         editorial='Doubleday';       disponible=$true },
  @{ titulo='El nombre de la rosa';        autor='Umberto Eco';             categoria='Thriller';         editorial='Bompiani';        disponible=$true },
  @{ titulo='Gone Girl';                   autor='Gillian Flynn';           categoria='Thriller';         editorial='Crown';           disponible=$true },
  @{ titulo='El silencio de los corderos'; autor='Thomas Harris';           categoria='Thriller';         editorial='St. Martin''s';   disponible=$true },
  @{ titulo='Harry Potter y la piedra filosofal'; autor='J.K. Rowling';    categoria='Fantasía';         editorial='Bloomsbury';      disponible=$true },
  @{ titulo='El señor de los anillos';     autor='J.R.R. Tolkien';         categoria='Fantasía';         editorial='Allen & Unwin';   disponible=$true },
  @{ titulo='El juego de Ender';           autor='Orson Scott Card';        categoria='Fantasía';         editorial='Tor Books';       disponible=$true },

  # Autoayuda y Desarrollo
  @{ titulo='Los 7 hábitos de la gente altamente efectiva'; autor='Stephen Covey'; categoria='Desarrollo Personal'; editorial='Simon & Schuster'; disponible=$true },
  @{ titulo='Atomic Habits';              autor='James Clear';             categoria='Desarrollo Personal'; editorial='Avery';        disponible=$true },
  @{ titulo='Thinking, Fast and Slow';    autor='Daniel Kahneman';         categoria='Psicología';       editorial='Farrar';          disponible=$true },
  @{ titulo='El hombre en busca de sentido'; autor='Viktor Frankl';        categoria='Psicología';       editorial='Beacon Press';    disponible=$true },
  @{ titulo='Inteligencia emocional';     autor='Daniel Goleman';          categoria='Psicología';       editorial='Bantam Books';    disponible=$true },

  # Historia de Mexico
  @{ titulo='El laberinto de la soledad';  autor='Octavio Paz';            categoria='Historia';         editorial='FCE';             disponible=$true },
  @{ titulo='México profundo';             autor='Guillermo Bonfil Batalla'; categoria='Historia';       editorial='Grijalbo';        disponible=$true },
  @{ titulo='La noche de Tlatelolco';      autor='Elena Poniatowska';       categoria='Historia';         editorial='Era';             disponible=$true },

  # Economia
  @{ titulo='El capital';                  autor='Karl Marx';               categoria='Economía';         editorial='Hamburgo';        disponible=$true },
  @{ titulo='La riqueza de las naciones'; autor='Adam Smith';              categoria='Economía';         editorial='W. Strahan';      disponible=$true },
  @{ titulo='Freakonomics';               autor='Steven D. Levitt';        categoria='Economía';         editorial='Morrow';          disponible=$true },
  @{ titulo='El mundo es plano';          autor='Thomas L. Friedman';      categoria='Economía';         editorial='Farrar';          disponible=$true }
)

$total = $libros.Count
$ok    = 0
$fail  = 0

Write-Host "Insertando $total libros en Supabase...`n"

foreach ($libro in $libros) {
  $body = $libro | ConvertTo-Json -Compress
  try {
    $res = Invoke-RestMethod `
      -Uri 'https://qzanordyttklascfmozy.supabase.co/rest/v1/libros' `
      -Method Post `
      -Body $body `
      -ContentType 'application/json; charset=utf-8' `
      -Headers $headers
    Write-Host "  [OK] $($libro.titulo)"
    $ok++
  } catch {
    Write-Host "  [ERR] $($libro.titulo) -> $($_.Exception.Message)"
    $fail++
  }
}

Write-Host "`n=== Resultado: $ok OK / $fail errores de $total total ==="
