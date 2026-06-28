<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Cita" %>
<%@ page import="model.ResumenPedidoReciente" %>
<!DOCTYPE html>
<html>
<head>
    <title>Dashboard Administrativo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/styles.css" rel="stylesheet">
</head>
<body class="app-body">
<%
    Integer totalClientes = (Integer) request.getAttribute("totalClientes");
    Integer totalPolarizado = (Integer) request.getAttribute("totalPolarizado");
    Integer totalLogotipo = (Integer) request.getAttribute("totalLogotipo");
    Integer totalInstalacion = (Integer) request.getAttribute("totalInstalacion");
    Integer totalGeneral = (Integer) request.getAttribute("totalGeneral");
    Integer totalCitas = (Integer) request.getAttribute("totalCitas");
    Integer citasPendientes = (Integer) request.getAttribute("citasPendientes");
    Integer citasConfirmadas = (Integer) request.getAttribute("citasConfirmadas");
    Integer citasAtendidas = (Integer) request.getAttribute("citasAtendidas");
    Integer citasCanceladas = (Integer) request.getAttribute("citasCanceladas");
    Integer citasHoy = (Integer) request.getAttribute("citasHoy");
    Integer citasSinTecnico = (Integer) request.getAttribute("citasSinTecnico");
    List<ResumenPedidoReciente> pedidosRecientes = (List<ResumenPedidoReciente>) request.getAttribute("pedidosRecientes");
    List<Cita> citasRecientes = (List<Cita>) request.getAttribute("citasRecientes");
    List<Cita> citasAgendaHoy = (List<Cita>) request.getAttribute("citasAgendaHoy");
    String flashSuccess = (String) request.getAttribute("flashSuccess");
    String flashWarning = (String) request.getAttribute("flashWarning");
    String flashError = (String) request.getAttribute("flashError");
%>

<nav class="app-topbar">
    <div class="app-topbar-inner">
        <div class="brand-stack">
            <span class="brand-title">Dashboard Administrativo</span>
            <span class="brand-subtitle">Resumen rapido de actividad, volumen y ultimos movimientos</span>
        </div>
        <div class="topbar-actions">
            <a href="inicio" class="app-button app-button-secondary">Inicio</a>
            <a href="admin-citas" class="app-button app-button-info">Agenda</a>
            <a href="servicio?tipo=reportes" class="app-button app-button-info">Atenciones</a>
            <a href="servicios-admin" class="app-button app-button-info">Servicios</a>
            <a href="usuarios" class="app-button app-button-info">Usuarios</a>
            <a href="logout" class="app-button app-button-outline">Cerrar sesion</a>
        </div>
    </div>
</nav>

<main class="app-shell page-section">
    <section class="section-hero">
        <span class="eyebrow">Vista ejecutiva</span>
        <h1 class="form-title mt-3">Resumen general del sistema</h1>
        <p class="form-subtitle">Consulta metricas clave de citas y atenciones para operar el taller con una vista mas comercial y clara.</p>
    </section>

    <div class="flash-wrap">
        <% if (flashSuccess != null && !flashSuccess.isBlank()) { %>
        <div class="app-alert alert alert-success" role="alert"><%= flashSuccess %></div>
        <% } %>
        <% if (flashWarning != null && !flashWarning.isBlank()) { %>
        <div class="app-alert alert alert-warning" role="alert"><%= flashWarning %></div>
        <% } %>
        <% if (flashError != null && !flashError.isBlank()) { %>
        <div class="app-alert alert alert-danger" role="alert"><%= flashError %></div>
        <% } %>
    </div>

    <section class="stats-grid">
        <article class="stat-card">
            <div class="stat-label">Total clientes</div>
            <div class="stat-value"><%= totalClientes %></div>
            <div class="stat-help">Clientes registrados en la base actual.</div>
        </article>
        <article class="stat-card">
            <div class="stat-label">Atenciones polarizado</div>
            <div class="stat-value"><%= totalPolarizado %></div>
            <div class="stat-help">Registros operativos del servicio de polarizado.</div>
        </article>
        <article class="stat-card">
            <div class="stat-label">Atenciones logotipo</div>
            <div class="stat-value"><%= totalLogotipo %></div>
            <div class="stat-help">Registros operativos del servicio de logotipos.</div>
        </article>
        <article class="stat-card">
            <div class="stat-label">Atenciones instalaciones</div>
            <div class="stat-value"><%= totalInstalacion %></div>
            <div class="stat-help">Registros operativos del servicio de instalaciones.</div>
        </article>
        <article class="stat-card stat-card-highlight">
            <div class="stat-label">Total general de atenciones</div>
            <div class="stat-value"><%= totalGeneral %></div>
            <div class="stat-help">Suma de registros operativos en los tres servicios tradicionales.</div>
        </article>
    </section>

    <section class="table-card">
        <div class="table-title">
            <h3>Resumen de citas</h3>
            <a href="admin-citas" class="app-button app-button-outline">Gestionar citas</a>
        </div>
        <div class="stats-grid">
            <article class="stat-card">
                <div class="stat-label">Total citas</div>
                <div class="stat-value"><%= totalCitas %></div>
                <div class="stat-help">Reservas creadas desde el nuevo flujo comercial.</div>
            </article>
            <article class="stat-card">
                <div class="stat-label">Pendientes</div>
                <div class="stat-value"><%= citasPendientes %></div>
                <div class="stat-help">Citas a confirmar o atender.</div>
            </article>
            <article class="stat-card">
                <div class="stat-label">Confirmadas</div>
                <div class="stat-value"><%= citasConfirmadas %></div>
                <div class="stat-help">Citas listas para recibir al cliente.</div>
            </article>
            <article class="stat-card">
                <div class="stat-label">Atendidas</div>
                <div class="stat-value"><%= citasAtendidas %></div>
                <div class="stat-help">Servicios ya finalizados en el flujo nuevo.</div>
            </article>
            <article class="stat-card stat-card-highlight">
                <div class="stat-label">Citas de hoy</div>
                <div class="stat-value"><%= citasHoy %></div>
                <div class="stat-help">Agenda comprometida para el dia actual.</div>
            </article>
            <article class="stat-card">
                <div class="stat-label">Sin tecnico</div>
                <div class="stat-value"><%= citasSinTecnico %></div>
                <div class="stat-help">Citas que aun no tienen responsable asignado.</div>
            </article>
            <article class="stat-card">
                <div class="stat-label">Canceladas</div>
                <div class="stat-value"><%= citasCanceladas %></div>
                <div class="stat-help">Citas canceladas o no concretadas.</div>
            </article>
        </div>
    </section>

    <section class="table-card">
        <div class="table-title">
            <h3>Agenda del dia</h3>
            <a href="admin-citas?fechaCita=<%= java.time.LocalDate.now() %>" class="app-button app-button-outline">Ver agenda completa</a>
        </div>
        <div class="table-responsive-shell">
            <table class="admin-table">
                <thead>
                <tr>
                    <th>Codigo</th>
                    <th>Cliente</th>
                    <th>Servicio</th>
                    <th>Horario</th>
                    <th>Tecnico</th>
                    <th>Estado</th>
                </tr>
                </thead>
                <tbody>
                <% if (citasAgendaHoy != null && !citasAgendaHoy.isEmpty()) {
                    for (Cita cita : citasAgendaHoy) { %>
                <tr>
                    <td><%= cita.getCodigoVerificacion() %></td>
                    <td><%= cita.getNombreCliente() %></td>
                    <td><%= cita.getNombreCatalogoServicio() == null || cita.getNombreCatalogoServicio().isBlank() ? cita.getTipoServicio() : cita.getNombreCatalogoServicio() %></td>
                    <td><%= cita.getFranjaHoraria() %></td>
                    <td><%= cita.getNombreTecnicoAsignado() == null || cita.getNombreTecnicoAsignado().isBlank() ? "Sin asignar" : cita.getNombreTecnicoAsignado() %></td>
                    <td><span class="status-pill status-<%= cita.getEstadoCita() %>"><%= cita.getEstadoCita() %></span></td>
                </tr>
                <% }
                } else { %>
                <tr>
                    <td colspan="6">No hay citas registradas para hoy.</td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </section>

    <section class="table-card">
        <div class="table-title">
            <h3>Ultimas atenciones registradas</h3>
            <a href="servicio?tipo=reportes" class="app-button app-button-outline">Ir a atenciones</a>
        </div>
        <div class="table-responsive-shell">
            <table class="admin-table">
                <thead>
                <tr>
                    <th>Tipo</th>
                    <th>ID</th>
                    <th>Cliente</th>
                    <th>Detalle</th>
                    <th>Estado</th>
                    <th>Fecha</th>
                    <th>Accion</th>
                </tr>
                </thead>
                <tbody>
                <% if (pedidosRecientes != null) {
                    for (ResumenPedidoReciente pedido : pedidosRecientes) { %>
                <tr>
                    <td><%= pedido.getTipoServicio() %></td>
                    <td><%= pedido.getIdReferencia() %></td>
                    <td><%= pedido.getNombreCliente() %></td>
                    <td><%= pedido.getDetalle() %></td>
                    <td><span class="status-pill status-<%= pedido.getEstado() %>"><%= pedido.getEstado() %></span></td>
                    <td><%= pedido.getFechaPedido() %></td>
                    <td>
                        <a href="servicio?tipo=historialCliente&idCliente=<%= pedido.getIdCliente() %>"
                           class="app-button app-button-outline app-button-sm">Historial</a>
                    </td>
                </tr>
                <% }
                } %>
                </tbody>
            </table>
        </div>
    </section>

    <section class="table-card">
        <div class="table-title">
            <h3>Proximas citas registradas</h3>
            <a href="admin-citas" class="app-button app-button-outline">Abrir agenda</a>
        </div>
        <div class="table-responsive-shell">
            <table class="admin-table">
                <thead>
                <tr>
                    <th>Codigo</th>
                    <th>Cliente</th>
                    <th>Servicio</th>
                    <th>Fecha</th>
                    <th>Horario</th>
                    <th>Tecnico</th>
                    <th>Estado</th>
                    <th>Accion</th>
                </tr>
                </thead>
                <tbody>
                <% if (citasRecientes != null && !citasRecientes.isEmpty()) {
                    for (Cita cita : citasRecientes) { %>
                <tr>
                    <td><%= cita.getCodigoVerificacion() %></td>
                    <td><%= cita.getNombreCliente() %></td>
                    <td><%= cita.getNombreCatalogoServicio() == null || cita.getNombreCatalogoServicio().isBlank() ? cita.getTipoServicio() : cita.getNombreCatalogoServicio() %></td>
                    <td><%= cita.getFechaCita() %></td>
                    <td><%= cita.getFranjaHoraria() %></td>
                    <td><%= cita.getNombreTecnicoAsignado() == null || cita.getNombreTecnicoAsignado().isBlank() ? "Sin asignar" : cita.getNombreTecnicoAsignado() %></td>
                    <td><span class="status-pill status-<%= cita.getEstadoCita() %>"><%= cita.getEstadoCita() %></span></td>
                    <td>
                        <a href="admin-citas?accion=verificar&token=<%= cita.getTokenVerificacion() %>"
                           class="app-button app-button-outline app-button-sm">Validar</a>
                    </td>
                </tr>
                <% }
                } else { %>
                <tr>
                    <td colspan="8">Todavia no hay citas registradas.</td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </section>
</main>
</body>
</html>
