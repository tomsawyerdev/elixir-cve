# CVE Phoenix App

# Environment

Las claves se leen de un archivo de environment: *.env*


# Instrucciones para levantar los servicios


1. Generar la base de datos 

```docker-compose up db```

*Acceder al containner*
```docker exec -it wazuh-db bash```

*Correr psql*
```psql -U adminuser -d cve_db```

*Verificar los datos importados*
```select id,cveid,published,name from cve;```

2. Correr Phoenix

```docker-compose up api```

Acceder:

``` http://localhost:4000/```


# Probar la Api

## Get Array

```curl 'http://localhost:4000/api/cves'  -H 'Content-Type: application/json' ```

## Get One

```curl 'http://localhost:4000/api/cves/CVE-2025-24493'  -H 'Content-Type: application/json' ```

*404*

```curl 'http://localhost:4000/api/cves/CVE-inexist'  -H 'Content-Type: application/json' ```

## Download One


```curl 'http://localhost:4000/api/export/CVE-2025-24493'  -H 'Content-Type: application/json' ```