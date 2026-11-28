$ErrorActionPreference='Stop'
$network='safetrack-auth06-net'
$containers=@('safetrack-auth06-api','safetrack-auth06-mail','safetrack-auth06-db')
foreach($name in $containers) { docker container inspect $name 2>$null | Out-Null; if ($LASTEXITCODE -eq 0) { throw "Fixture already exists: $name" } }
docker network create $network | Out-Null
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
try {
  $pw=[guid]::NewGuid().ToString('N')
  $jwt=[guid]::NewGuid().ToString('N')+[guid]::NewGuid().ToString('N')
  docker run -d --name safetrack-auth06-db --network $network -e "POSTGRES_PASSWORD=$pw" postgres:16-alpine | Out-Null
  if ($LASTEXITCODE -ne 0) { throw 'Could not start fixture database' }
  docker run -d --name safetrack-auth06-mail --network $network -p '127.0.0.1:8489:8025' axllent/mailpit:v1.27 | Out-Null
  if ($LASTEXITCODE -ne 0) { throw 'Could not start fixture inbox' }
  for($i=0;$i -lt 30;$i++){ docker exec safetrack-auth06-db pg_isready -U postgres 2>$null | Out-Null; if ($LASTEXITCODE -eq 0) { break }; Start-Sleep -Milliseconds 500 }
  docker exec safetrack-auth06-db psql -U postgres -v ON_ERROR_STOP=1 -c 'create schema auth;' | Out-Null
  if ($LASTEXITCODE -ne 0) { throw 'Could not create the fixture auth schema' }
  docker run -d --name safetrack-auth06-api --network $network -p '127.0.0.1:8488:9999' -e 'GOTRUE_API_HOST=0.0.0.0' -e 'GOTRUE_API_PORT=9999' -e 'API_EXTERNAL_URL=http://127.0.0.1:8488' -e 'GOTRUE_DB_DRIVER=postgres' -e "GOTRUE_DB_DATABASE_URL=postgres://postgres:${pw}@safetrack-auth06-db:5432/postgres?sslmode=disable&search_path=auth" -e 'GOTRUE_SITE_URL=http://127.0.0.1:8490/' -e 'GOTRUE_URI_ALLOW_LIST=http://127.0.0.1:8490/?account=1' -e "GOTRUE_JWT_SECRET=$jwt" -e 'GOTRUE_JWT_EXP=3600' -e 'GOTRUE_EXTERNAL_EMAIL_ENABLED=true' -e 'GOTRUE_MAILER_AUTOCONFIRM=false' -e 'GOTRUE_SMTP_ADMIN_EMAIL=safetrack@example.test' -e 'GOTRUE_SMTP_HOST=safetrack-auth06-mail' -e 'GOTRUE_SMTP_PORT=1025' -e 'GOTRUE_SMTP_MAX_FREQUENCY=1s' -e 'GOTRUE_MAILER_URLPATHS_CONFIRMATION=/verify' -e 'GOTRUE_MAILER_URLPATHS_RECOVERY=/verify' supabase/gotrue:v2.186.0 | Out-Null
  if ($LASTEXITCODE -ne 0) { throw 'Could not start fixture Auth' }
  for($i=0;$i -lt 30;$i++){ curl.exe -fsS --max-time 2 http://127.0.0.1:8488/health 2>$null | Out-Null; if ($LASTEXITCODE -eq 0) { break }; Start-Sleep -Milliseconds 500 }
  python (Join-Path $PSScriptRoot 'auth_smoke.py')
  if ($LASTEXITCODE -ne 0) { throw 'Local Auth smoke test failed' }
} finally {
  foreach($name in $containers) { docker rm -f $name 2>$null | Out-Null }
  docker network rm $network 2>$null | Out-Null
}
