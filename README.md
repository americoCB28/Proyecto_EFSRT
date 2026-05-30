# Proyecto EFSRT

Aplicación web para gestión de servicios vehiculares. Permite registrar pedidos públicos de logotipos, polarizado e instalaciones, y ofrece una zona administrativa con autenticación, reportes, dashboard, estados de pedido, historial por cliente, exportación CSV y gestión de usuarios administradores.

El proyecto está preparado para ejecutarse con Docker y compilarse con Maven, manteniendo una arquitectura clásica basada en JSP, Servlets, DAO y MySQL.

## Tecnologías usadas

- Java 21
- JSP / Servlets
- Maven
- Tomcat 11
- MySQL 8
- Docker

## Funcionalidades implementadas

- Registro de pedidos públicos
- Login de administradores
- Dashboard administrativo
- Reportes con filtros
- Estados de pedido
- Historial por cliente
- Exportación CSV
- Gestión de usuarios administradores
- Protección CSRF en formularios administrativos sensibles

## Estructura del proyecto

- `src/main/java/connection`
  - Conexión JDBC
- `src/main/java/controller`
  - Servlets principales
- `src/main/java/dao`
  - Acceso a datos por entidad
- `src/main/java/filter`
  - Filtro de protección administrativa
- `src/main/java/model`
  - Modelos de dominio
- `src/main/java/util`
  - Validaciones, sesión, hash de contraseñas y CSRF
- `src/main/webapp`
  - JSP, CSS y recursos estáticos
- `clientes.sql`
  - Esquema y datos iniciales para MySQL

## Requisitos

- Docker
- Docker Compose
- Maven

## Base de datos

Base creada automáticamente:

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
> Estas credenciales son solo para pruebas locales. En un entorno real deben cambiarse.
- Usuario: `admin`
- Contrasena: `admin123`

La contrasena se almacena con hash PBKDF2 y no en texto plano.

## Cómo ejecutar con Docker

Desde la raíz del proyecto:

```bash
docker compose up --build
```

Accesos:

- Aplicación: `http://localhost:8080`
- MySQL: `localhost:3307`

## Cómo detener Docker

Para detener los contenedores sin borrar datos:

```bash
docker compose down
```

## Cómo reiniciar la base de datos

Para reconstruir la aplicación y volver a crear la base desde `clientes.sql`:

```bash
mvn clean package
docker compose down -v --remove-orphans
docker compose build --no-cache
docker compose up -d
```

## Rutas principales

### Públicas

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

Si no existe sesión admin válida, las rutas protegidas redirigen a `GET /login`.

## Flujo administrativo actual

1. Entrar a `/login`
2. Iniciar sesión como administrador
3. Navegar por:
   - `Dashboard`
   - `Reportes`
   - `Actualizar`
   - `Usuarios`
4. Cerrar sesión desde `/logout`

## Módulos del sistema

### Registro de pedidos

Flujo público:

1. Entrar a `/inicio`
2. Elegir servicio
3. Completar formulario
4. Registrar pedido
5. Ver confirmación

### Dashboard

Muestra:

- total de clientes
- total de pedidos por servicio
- total general
- últimos pedidos registrados

### Reportes con filtros

Filtros soportados:

- cliente
- tipo de servicio
- estado

### Estados de pedido

Estados válidos:

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

### Exportación CSV

Ruta:

- `GET /servicio?tipo=exportarCsv`

Características:

- UTF-8
- archivo `reporte_pedidos.csv`
- respeta filtros de cliente, servicio y estado

### Gestión de usuarios administradores

Permite:

- listar administradores
- crear administrador
- activar administrador
- desactivar administrador

Restricciones:

- username obligatorio
- username único
- username con letras, números, punto, guion y guion bajo
- contrasena mínima de 8 caracteres
- un admin no puede desactivarse a sí mismo
- un usuario inactivo no puede iniciar sesión

### Protección CSRF

Se aplica a formularios administrativos sensibles, incluyendo:

- actualización de clientes
- actualización de pedidos
- eliminación de clientes
- creación de administradores
- activación y desactivación de administradores

## Seguridad básica implementada

- Sesión HTTP para administradores
- Rutas administrativas protegidas
- Verificación de usuario activo en login y durante la sesión
- Hash de contrasenas con PBKDF2
- Consultas SQL con `PreparedStatement`
- Protección CSRF en POST administrativos

## Comandos útiles

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

## Capturas sugeridas para la presentación

- Pantalla principal `/inicio`
- Login de administrador
- Dashboard administrativo
- Reportes con filtros aplicados
- Actualización de reportes con estados
- Historial por cliente
- Exportación CSV descargada
- Gestión de usuarios administradores

## Posibles mejoras futuras

- Recuperación de contrasena
- Auditoría de acciones administrativas
- Paginación en reportes
- Exportación adicional a PDF o Excel
- Búsqueda avanzada por fechas
- Notificaciones o seguimiento de pedidos
- Pruebas automatizadas
- CSRF también en formularios públicos si se requiere endurecer más el sistema
