# Proyecto EFSRT

Aplicacion web para gestion de servicios vehiculares. Permite registrar pedidos publicos de logotipos, polarizado e instalaciones, y ofrece una zona administrativa con autenticacion, reportes, dashboard, estados de pedido, historial por cliente, exportacion CSV y gestion de usuarios administradores.

El proyecto esta preparado para ejecutarse con Docker y compilarse con Maven, manteniendo una arquitectura clasica basada en JSP, Servlets, DAO y MySQL.

## Tecnologias usadas

- Java 21
- JSP / Servlets
- Maven
- Tomcat 11
- MySQL 8
- Docker

## Funcionalidades implementadas

- Registro de pedidos publicos
- Login de administradores
- Dashboard administrativo
- Reportes con filtros
- Estados de pedido
- Historial por cliente
- Exportacion CSV
- Gestion de usuarios administradores
- Proteccion CSRF en formularios administrativos sensibles

## Estructura del proyecto

- `src/main/java/connection`
  - Conexion JDBC
- `src/main/java/controller`
  - Servlets principales
- `src/main/java/dao`
  - Acceso a datos por entidad
- `src/main/java/filter`
  - Filtro de proteccion administrativa
- `src/main/java/model`
  - Modelos de dominio
- `src/main/java/util`
  - Validaciones, sesion, hash de contrasenas y CSRF
- `src/main/webapp`
  - JSP, CSS y recursos estaticos
- `clientes.sql`
  - Esquema y datos iniciales para MySQL

## Requisitos

- Docker
- Docker Compose
- Maven

## Base de datos

Base creada automaticamente:

- `db_gestion_servicios`

Tablas usadas por el proyecto:

- `clientes`
- `servicios`
- `pedidos`
- `pedidosLogotipo`
- `pedidosInstalaciones`
- `usuarios`

Notas:

- Los pedidos nuevos se crean con estado `pendiente`.
- `clientes.sql` inserta datos demo y el usuario administrador inicial.

## Credenciales admin de prueba

- Usuario: `admin`
- Contrasena: `admin123`

La contrasena se almacena con hash PBKDF2 y no en texto plano.

## Como ejecutar con Docker

Desde la raiz del proyecto:

```bash
docker compose up --build
```

Accesos:

- Aplicacion: `http://localhost:8080`
- MySQL: `localhost:3307`

## Como detener Docker

Para detener los contenedores sin borrar datos:

```bash
docker compose down
```

## Como reiniciar la base de datos

Para reconstruir la aplicacion y volver a crear la base desde `clientes.sql`:

```bash
mvn clean package
docker compose down -v --remove-orphans
docker compose build --no-cache
docker compose up -d
```

## Rutas principales

### Publicas

- `GET /inicio`
- `GET /login`
- `GET /servicio?tipo=logotipos`
- `GET /servicio?tipo=polarizado`
- `GET /servicio?tipo=instalaciones`
- `POST /servicio`
  - con `tipo=logotipos`
  - con `tipo=polarizado`
  - con `tipo=instalaciones`

### Administrativas protegidas

- `GET /servicio?tipo=dashboard`
- `GET /servicio?tipo=reportes`
- `GET /servicio?tipo=actualizarReporte`
- `GET /servicio?tipo=historialCliente&idCliente=...`
- `GET /servicio?tipo=exportarCsv`
- `GET /usuarios`
- `POST /usuarios`
- `GET /logout`

Si no existe sesion admin valida, las rutas protegidas redirigen a `GET /login`.

## Flujo administrativo actual

1. Entrar a `/login`
2. Iniciar sesion como administrador
3. Navegar por:
   - `Dashboard`
   - `Reportes`
   - `Actualizar`
   - `Usuarios`
4. Cerrar sesion desde `/logout`

## Modulos del sistema

### Registro de pedidos

Flujo publico:

1. Entrar a `/inicio`
2. Elegir servicio
3. Completar formulario
4. Registrar pedido
5. Ver confirmacion

### Dashboard

Muestra:

- total de clientes
- total de pedidos por servicio
- total general
- ultimos pedidos registrados

### Reportes con filtros

Filtros soportados:

- cliente
- tipo de servicio
- estado

### Estados de pedido

Estados validos:

- `pendiente`
- `en_proceso`
- `terminado`
- `cancelado`

### Historial por cliente

Muestra:

- datos del cliente
- pedidos de polarizado
- pedidos de logotipo
- pedidos de instalaciones
- fecha y estado por pedido

### Exportacion CSV

Ruta:

- `GET /servicio?tipo=exportarCsv`

Caracteristicas:

- UTF-8
- archivo `reporte_pedidos.csv`
- respeta filtros de cliente, servicio y estado

### Gestion de usuarios administradores

Permite:

- listar administradores
- crear administrador
- activar administrador
- desactivar administrador

Restricciones:

- username obligatorio
- username unico
- username con letras, numeros, punto, guion y guion bajo
- contrasena minima de 8 caracteres
- un admin no puede desactivarse a si mismo
- un usuario inactivo no puede iniciar sesion

### Proteccion CSRF

Se aplica a formularios administrativos sensibles, incluyendo:

- actualizacion de clientes
- actualizacion de pedidos
- eliminacion de clientes
- creacion de administradores
- activacion y desactivacion de administradores

## Seguridad basica implementada

- Sesion HTTP para administradores
- Rutas administrativas protegidas
- Verificacion de usuario activo en login y durante la sesion
- Hash de contrasenas con PBKDF2
- Consultas SQL con `PreparedStatement`
- Proteccion CSRF en POST administrativos

## Comandos utiles

Compilar:

```bash
mvn clean package
```

Levantar contenedores:

```bash
docker compose up --build
```

Detener contenedores:

```bash
docker compose down
```

Recrear desde cero:

```bash
docker compose down -v
docker compose up --build
```

Ver logs:

```bash
docker compose logs -f app
docker compose logs -f db
```

## Capturas sugeridas para la presentacion

- Pantalla principal `/inicio`
- Login de administrador
- Dashboard administrativo
- Reportes con filtros aplicados
- Actualizacion de reportes con estados
- Historial por cliente
- Exportacion CSV descargada
- Gestion de usuarios administradores

## Posibles mejoras futuras

- Recuperacion de contrasena
- Auditoria de acciones administrativas
- Paginacion en reportes
- Exportacion adicional a PDF o Excel
- Busqueda avanzada por fechas
- Notificaciones o seguimiento de pedidos
- Pruebas automatizadas
- CSRF tambien en formularios publicos si se requiere endurecer mas el sistema
