# Proyecto EFSRT

Aplicación web para agendamiento y gestión de servicios vehiculares. El sistema combina un flujo público de citas para clientes con módulos internos para administración, agenda operativa, técnicos, catálogo de servicios y validación de citas mediante QR.

El proyecto está construido con una arquitectura clásica basada en JSP, Servlets, DAO y MySQL. Se compila con Maven y se ejecuta con Docker usando Tomcat 11, MySQL 8, n8n y Evolution API.

## Tecnologías usadas

- Java 21
- JSP / Servlets
- Maven
- Tomcat 11
- MySQL 8
- Docker
- n8n
- Evolution API
- ZXing
- OpenPDF
- Jakarta Mail

## Funcionalidades implementadas

- Registro público de atenciones tradicionales
  - polarizado
  - logotipo
  - instalaciones
- Flujo público de citas
  - selección de servicio desde catálogo
  - detalle del servicio
  - fecha y horario
  - precio estimado
  - resumen final
  - confirmación
- Login de usuarios internos
  - ADMIN
  - TECNICO
- Dashboard administrativo
- Panel técnico
- Reportes con filtros
- Estados de atención y de cita
- Historial por cliente
- Exportación CSV
- Gestión de usuarios internos
- Catálogo administrable de servicios
- Asignación de técnico a citas
- QR de validación de cita
- PDF de cita
- Envío de correo
- Integración con n8n + Evolution para WhatsApp
- Protección CSRF en formularios administrativos y técnicos sensibles

## Enfoque funcional del sistema

El proyecto convive hoy con dos líneas de negocio dentro de la misma base:

- Flujo tradicional de atenciones basado en tablas históricas:
  - `clientes`
  - `pedidos`
  - `pedidosLogotipo`
  - `pedidosInstalaciones`
- Flujo nuevo de citas orientado al usuario final:
  - `catalogoServicios`
  - `citas`

Esto permite mantener compatibilidad con la lógica anterior mientras el sistema migra hacia un modelo más comercial de agendamiento.

## Estructura del proyecto

- `src/main/java/connection`
  - conexión JDBC
- `src/main/java/controller`
  - servlets principales del sistema
- `src/main/java/dao`
  - acceso a datos por entidad
- `src/main/java/filter`
  - filtros de acceso para panel admin y técnico
- `src/main/java/model`
  - modelos de dominio
- `src/main/java/util`
  - validaciones, sesión, hash de contraseñas, CSRF, QR, PDF, correo y WhatsApp
- `src/main/webapp`
  - JSP, CSS y recursos estáticos
- `clientes.sql`
  - esquema y datos iniciales para MySQL
- `n8n/workflows`
  - workflow base para integración con WhatsApp

## Requisitos

- Docker
- Docker Compose
- Maven
- Java 21 si vas a compilar fuera de contenedores

## Base de datos

Base creada automáticamente:

- `db_gestion_servicios`

Tablas principales:

- `clientes`
- `servicios`
- `pedidos`
- `pedidosLogotipo`
- `pedidosInstalaciones`
- `usuarios`
- `catalogoServicios`
- `citas`

Notas:

- Las atenciones tradicionales nuevas se crean con estado `pendiente`.
- Las citas nuevas se crean con estado `pendiente`.
- `clientes.sql` inserta datos demo y usuarios internos iniciales.

## Usuarios de prueba

Estas credenciales son solo para entorno local.

### Administrador

- Usuario: `admin`
- Contraseña: `admin123`

### Técnico

- Usuario: `tecnico`
- Contraseña: `tecnico123`

Las contraseñas se almacenan con hash PBKDF2 y no en texto plano.

## Cómo ejecutar con Docker

Desde la raíz del proyecto:

```bash
docker compose up -d --build
```

El `Dockerfile` compila el WAR con Maven dentro de Docker, por eso `mvn clean package` es opcional para validar localmente antes de construir la imagen.

## Cómo detener Docker

Para detener los contenedores sin borrar datos:

```bash
docker compose down
```

Este comando conserva el volumen `mysql_data`, por lo que la base de datos no se borra.

## Cómo reiniciar sin perder datos

Para reconstruir la aplicación con los cambios del código y mantener la base de datos:

```bash
docker compose down
docker compose up -d --build
```

Si solo necesitas reiniciar Tomcat sin reconstruir la imagen:

```bash
docker compose restart app
```

## Cómo borrar y recrear la base de datos

Usa este flujo solo cuando quieras eliminar el volumen `mysql_data` y volver a crear la base desde `clientes.sql`:

```bash
docker compose down -v --remove-orphans
docker compose up -d --build
```

`docker compose down -v` borra los volúmenes del proyecto, incluida la base de datos MySQL.

## Servicios y puertos

- Aplicación web: `http://localhost:8080`
- MySQL: `localhost:3307`
- n8n: `http://localhost:5678`
- Evolution API: `http://localhost:8081`

## Variables relevantes en Docker

Definidas en `docker-compose.yml`:

- `DB_HOST`
- `DB_PORT`
- `DB_NAME`
- `DB_USER`
- `DB_PASSWORD`
- `PUBLIC_BASE_URL`
- `APP_INTERNAL_URL`
- `N8N_WHATSAPP_WEBHOOK_URL`
- `N8N_WHATSAPP_TOKEN`
- `SMTP_HOST`
- `SMTP_PORT`
- `SMTP_USER`
- `SMTP_PASSWORD`
- `SMTP_FROM`
- `EVOLUTION_API_URL`
- `EVOLUTION_INSTANCE_NAME`
- `EVOLUTION_API_KEY`

## Rutas principales

### Públicas

- `GET /inicio`
- `GET /login`
- `GET /citas`
- `GET /citas?paso=detalle&idCatalogoServicio=...`
- `GET /citas?paso=horario`
- `GET /citas?paso=preliminar`
- `GET /citas?paso=confirmacion`
- `GET /cita-pdf?token=...`
- `GET /qr-cita?token=...`
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
- `GET /admin-citas`
- `POST /admin-citas`
- `GET /usuarios`
- `POST /usuarios`
- `GET /servicios-admin`
- `POST /servicios-admin`
- `GET /logout`

### Técnicas protegidas

- `GET /tecnico`
- `POST /tecnico`

Si no existe sesión válida:

- las rutas admin redirigen a `GET /login`
- las rutas técnicas redirigen a `GET /login`

## Flujos principales

### Flujo público de citas

1. Entrar a `/citas`
2. Elegir servicio desde catálogo
3. Completar detalle del servicio
4. Elegir fecha y franja horaria
5. Revisar precio estimado
6. Ingresar datos del cliente
7. Confirmar la cita
8. Descargar PDF o usar QR

### Flujo público tradicional

1. Entrar a `/inicio`
2. Elegir servicio tradicional
3. Completar formulario
4. Registrar solicitud de atención
5. Ver confirmación

### Flujo administrativo

1. Entrar a `/login`
2. Iniciar sesión como administrador
3. Navegar por:
   - `Dashboard`
   - `Agenda de citas`
   - `Atenciones`
   - `Actualizar`
   - `Servicios`
   - `Usuarios`
4. Cerrar sesión desde `/logout`

### Flujo técnico

1. Entrar a `/login`
2. Iniciar sesión como técnico
3. Ir a `/tecnico`
4. Filtrar citas asignadas
5. Abrir detalle de cita
6. Actualizar estado operativo

## Módulos del sistema

### Dashboard administrativo

Muestra:

- total de clientes
- total de atenciones tradicionales por servicio
- total general de atenciones
- total de citas
- citas pendientes
- citas confirmadas
- citas atendidas
- citas canceladas
- citas de hoy
- citas sin técnico asignado
- agenda del día
- últimas atenciones
- próximas citas

### Panel técnico

Incluye:

- citas asignadas al técnico logueado
- filtro por fecha
- filtro por estado
- detalle de cita
- cambio de estado técnico

Estados que el técnico puede marcar:

- `confirmada`
- `atendida`
- `vencida`

### Reportes con filtros

Filtros soportados en atenciones tradicionales:

- cliente
- tipo de servicio
- estado

### Estados de atención tradicionales

Estados válidos:

- `pendiente`
- `en_proceso`
- `terminado`
- `cancelado`

### Estados de cita

Estados válidos:

- `pendiente`
- `confirmada`
- `atendida`
- `cancelada`
- `vencida`

### Historial por cliente

Muestra:

- datos del cliente
- atenciones de polarizado
- atenciones de logotipo
- atenciones de instalaciones
- fecha y estado por registro

### Exportación CSV

Ruta:

- `GET /servicio?tipo=exportarCsv`

Características:

- UTF-8
- archivo `reporte_atenciones.csv`
- respeta filtros de cliente, servicio y estado

### Gestión de usuarios internos

Permite:

- listar usuarios internos
- crear administradores
- crear técnicos
- activar usuarios
- desactivar usuarios

Restricciones:

- username obligatorio
- username único
- username con letras, números, punto, guion y guion bajo
- contraseña mínima de 8 caracteres
- un admin no puede desactivarse a sí mismo
- un usuario inactivo no puede iniciar sesión

### Catálogo de servicios

Permite:

- crear servicios
- editar servicios
- activar o desactivar servicios
- definir tipo base
- definir precio base
- definir duración
- controlar orden visual

### Citas y validación

Cada cita puede incluir:

- código de verificación
- token seguro
- QR
- PDF
- canal de entrega
- técnico asignado

La agenda administrativa permite:

- buscar por código
- validar por token QR
- asignar técnico
- actualizar estado

### Integración con n8n y Evolution

El proyecto incluye infraestructura base para:

- disparar un webhook a n8n
- enviar información de la cita
- generar canal de WhatsApp apoyado en Evolution API

Workflow incluido:

- `n8n/workflows/proyecto_efsrt_whatsapp_pdf.json`

## Seguridad básica implementada

- sesión HTTP para usuarios internos
- protección de rutas administrativas
- protección de rutas técnicas
- verificación de usuario activo durante la sesión
- hash de contraseñas con PBKDF2
- consultas SQL con `PreparedStatement`
- protección CSRF en formularios administrativos y técnicos sensibles

## Comandos útiles

Compilar localmente (opcional):

```bash
mvn clean package
```

Levantar contenedores:

```bash
docker compose up -d --build
```

Reiniciar sin perder datos:

```bash
docker compose down
docker compose up -d --build
```

Recrear base de datos desde cero:

```bash
docker compose down -v --remove-orphans
docker compose up -d --build
```

Detener contenedores:

```bash
docker compose down
```

Ver logs:

```bash
docker compose logs -f app
docker compose logs -f db
docker compose logs -f n8n
docker compose logs -f evolution
```

## Capturas sugeridas para presentación

- Pantalla principal `/inicio`
- Flujo de citas `/citas`
- Resumen final de cita
- Confirmación con QR
- Login de administrador
- Dashboard administrativo
- Agenda de citas `/admin-citas`
- Catálogo de servicios `/servicios-admin`
- Panel técnico `/tecnico`
- Reportes con filtros
- Historial por cliente
- Gestión de usuarios internos

## Posibles mejoras futuras

- cupos por franja horaria
- bloqueo de días no disponibles
- asignación automática de técnicos
- reprogramación de citas
- integración completa de envío automático por WhatsApp
- recuperación de contraseña
- auditoría de acciones internas
- paginación en reportes y agendas
- búsqueda avanzada por rango de fechas
- pruebas automatizadas
- endurecimiento adicional de seguridad en formularios públicos
