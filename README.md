# Proyecto EFSRT

Aplicacion Java Web con JSP, Servlets, DAO y MySQL para gestion de servicios vehiculares. El proyecto corre con Maven, Docker, Tomcat 11 y MySQL 8.

## Stack

- Java 21
- Maven
- JSP / Servlets Jakarta
- Tomcat 11
- MySQL 8
- Docker Compose

## Requisitos

- Docker
- Docker Compose
- Maven

## Ejecucion rapida con Docker

Desde la raiz del proyecto:

```bash
docker compose up --build
```

Servicios expuestos:

- Aplicacion web: `http://localhost:8080`
- MySQL: `localhost:3307`

## Reinicio limpio

Usa este flujo cuando quieras reconstruir la app y volver a crear la base desde `clientes.sql`:

```bash
mvn clean package
docker compose down -v --remove-orphans
docker compose build --no-cache
docker compose up -d
```

Para ver logs:

```bash
docker compose logs -f app
docker compose logs -f db
```

## Compilacion local

```bash
mvn clean package
```

El WAR generado queda en:

- `target/Proyecto_Final_LP2.war`

## Estructura del proyecto

- `src/main/java/connection`: conexion JDBC
- `src/main/java/controller`: servlets principales
- `src/main/java/dao`: acceso a datos por entidad
- `src/main/java/filter`: filtros de seguridad
- `src/main/java/model`: modelos de dominio
- `src/main/java/util`: validaciones, sesiones y hash de contrasenas
- `src/main/webapp`: JSP, CSS y recursos estaticos
- `clientes.sql`: esquema y datos iniciales de MySQL

## Base de datos

El contenedor MySQL crea automaticamente:

- Base: `db_gestion_servicios`

Tablas usadas por el codigo:

- `clientes`
- `servicios`
- `pedidos`
- `pedidosLogotipo`
- `pedidosInstalaciones`
- `usuarios`

Notas:

- Los pedidos se crean con estado inicial `pendiente`.
- La tabla `usuarios` se usa para login y gestion de administradores.
- `clientes.sql` inserta un administrador inicial y datos demo para pedidos.

## Credenciales iniciales

Administrador inicial:

- Usuario: `admin`
- Contrasena: `admin123`

La contrasena no se guarda en texto plano. El proyecto usa hash PBKDF2 con SHA-256.

## Rutas principales

### Rutas publicas

- `GET /inicio`
  - pantalla principal con servicios disponibles
- `GET /login`
  - formulario de acceso administrador
- `GET /servicio?tipo=logotipos`
  - formulario de logotipos
- `GET /servicio?tipo=polarizado`
  - formulario de polarizado
- `GET /servicio?tipo=instalaciones`
  - formulario de instalaciones
- `POST /servicio`
  - registro de pedidos publicos usando `tipo=logotipos`, `tipo=polarizado` o `tipo=instalaciones`

### Rutas protegidas de administracion

Estas rutas requieren sesion de administrador activa:

- `GET /servicio?tipo=dashboard`
- `GET /servicio?tipo=reportes`
- `GET /servicio?tipo=actualizarReporte`
- `GET /servicio?tipo=historialCliente&idCliente=...`
- `GET /servicio?tipo=exportarCsv`
- `GET /usuarios`
- `POST /usuarios`
- `GET /dashboard.jsp`
- `GET /reportes.jsp`
- `GET /actualizarReporte.jsp`
- `GET /historialCliente.jsp`
- `GET /usuarios.jsp`

Si un usuario no autenticado intenta entrar, se redirige a:

- `GET /login`

### Login y logout

- `GET /login`
- `POST /login`
- `GET /logout`

## Flujo funcional actual

### Flujo publico de cliente

1. Entrar a `/inicio`
2. Elegir un servicio
3. Completar formulario
4. Registrar pedido
5. Ver pantalla de confirmacion
6. Volver al inicio o registrar otro pedido

### Flujo administrativo

1. Entrar a `/login`
2. Iniciar sesion como administrador
3. Navegar desde la cabecera a:
   - `Dashboard`
   - `Reportes`
   - `Actualizar`
   - `Usuarios`
4. Cerrar sesion con `/logout`

## Funcionalidades administrativas actuales

### Dashboard

Ruta:

- `GET /servicio?tipo=dashboard`

Muestra:

- total de clientes
- total de pedidos de polarizado
- total de pedidos de logotipo
- total de pedidos de instalaciones
- total general de pedidos
- ultimos pedidos registrados

### Reportes y filtros

Ruta:

- `GET /servicio?tipo=reportes`

Filtros soportados:

- cliente
- tipo de servicio
- estado

Datos visibles:

- clientes registrados
- pedidos de polarizado
- pedidos de logotipo
- pedidos de instalaciones

### Actualizacion de reportes

Ruta:

- `GET /servicio?tipo=actualizarReporte`

Permite:

- actualizar nombre de cliente
- actualizar pedidos de polarizado
- actualizar pedidos de logotipo
- actualizar pedidos de instalaciones
- eliminar cliente y pedidos relacionados

### Estados de pedido

Estados validos:

- `pendiente`
- `en_proceso`
- `terminado`
- `cancelado`

El estado se muestra en:

- reportes
- actualizacion de reportes
- dashboard
- historial por cliente
- exportacion CSV

### Exportacion CSV

Ruta:

- `GET /servicio?tipo=exportarCsv`

Caracteristicas:

- exporta en UTF-8
- nombre de archivo: `reporte_pedidos.csv`
- respeta filtros activos de:
  - cliente
  - tipo de servicio
  - estado

### Historial por cliente

Ruta:

- `GET /servicio?tipo=historialCliente&idCliente=...`

Muestra:

- datos del cliente
- pedidos de polarizado
- pedidos de logotipo
- pedidos de instalaciones
- fecha y estado por pedido

### Gestion de usuarios administradores

Ruta principal:

- `GET /usuarios`

Acciones:

- listar administradores
- crear administrador
- activar administrador
- desactivar administrador

Reglas actuales:

- el `username` es obligatorio y unico
- el `username` acepta letras, numeros, punto, guion y guion bajo
- la contrasena es obligatoria y debe tener minimo 8 caracteres
- un administrador no puede desactivarse a si mismo
- un usuario inactivo no puede iniciar sesion

## Validaciones implementadas

- nombre de cliente obligatorio y maximo 100 caracteres
- materiales de polarizado controlados por lista valida
- porcentajes de luz visible controlados por lista valida
- servicios de logotipo controlados por lista valida
- servicios de instalacion controlados por lista valida
- estados de pedido controlados por lista valida
- `idCliente`, `idPedido`, `idUsuario` validados como enteros positivos
- `username` validado por patron seguro
- contrasena admin con minimo 8 caracteres

## Seguridad basica implementada

- login con sesion HTTP
- rutas admin protegidas por filtro
- redireccion a login si no hay sesion valida
- cierre de sesion con invalidacion de sesion
- contrasenas con hash PBKDF2
- consultas con `PreparedStatement`
- verificacion de usuario activo en login
- verificacion de usuario activo durante el uso de la sesion admin

## Archivos clave

- [ServicioController.java](src/main/java/controller/ServicioController.java)
- [PedidoController.java](src/main/java/controller/PedidoController.java)
- [AuthController.java](src/main/java/controller/AuthController.java)
- [UsuarioAdminController.java](src/main/java/controller/UsuarioAdminController.java)
- [AdminAuthFilter.java](src/main/java/filter/AdminAuthFilter.java)
- [ClienteDAO.java](src/main/java/dao/ClienteDAO.java)
- [PedidoDAO.java](src/main/java/dao/PedidoDAO.java)
- [DashboardDAO.java](src/main/java/dao/DashboardDAO.java)
- [UsuarioDAO.java](src/main/java/dao/UsuarioDAO.java)
- [InputValidator.java](src/main/java/util/InputValidator.java)
- [SessionUtil.java](src/main/java/util/SessionUtil.java)
- [PasswordUtil.java](src/main/java/util/PasswordUtil.java)

## Comandos recomendados

Compilar:

```bash
mvn clean package
```

Levantar contenedores:

```bash
docker compose up --build
```

Recrear desde cero:

```bash
docker compose down -v
docker compose up --build
```
