# Proyecto EFSRT

Aplicación Java Web con JSP, Servlets, DAO y MySQL para gestión de servicios vehiculares.

## Requisitos

- Docker
- Docker Compose

## Ejecutar con Docker

Desde la raíz del proyecto:

```bash
docker compose up --build
```

La aplicación quedará disponible en:

- `http://localhost:8080`

## Reinicio limpio

Para reconstruir la aplicación y reinicializar la base de datos desde `clientes.sql`:

```bash
docker compose down -v --remove-orphans
docker compose build --no-cache
docker compose up -d
```

## Estructura del proyecto

- `src/main/java/connection`: acceso y configuración de conexión JDBC
- `src/main/java/dao`: acceso a datos separado por entidad
- `src/main/java/model`: modelos usados por la aplicación
- `src/main/java/controller`: servlets/controladores
- `src/main/java/util`: validaciones de entrada
- `src/main/webapp`: JSP, recursos estáticos y despliegue web

## Base de datos

El contenedor MySQL carga automáticamente `clientes.sql` al iniciar un volumen nuevo.

Base creada:

- `db_gestion_servicios`

Tablas principales:

- `clientes`
- `servicios`
- `pedidos`
- `pedidosLogotipo`
- `pedidosInstalaciones`

## Desarrollo local con Maven

Para compilar el WAR sin ejecutar tests:

```bash
mvn clean package -DskipTests
```
