<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Cita" %>
<%@ page import="model.Usuario" %>
<%@ page import="util.CsrfUtil" %>
<!DOCTYPE html>
<html>
<head>
    <title>Panel Tecnico</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/styles.css" rel="stylesheet">
</head>
<body class="app-body">
<%
    String flashSuccess = (String) request.getAttribute("flashSuccess");
    String flashWarning = (String) request.getAttribute("flashWarning");
    String flashError = (String) request.getAttribute("flashError");
    String fechaCitaFiltro = (String) request.getAttribute("fechaCitaFiltro");
    String estadoCitaFiltro = (String) request.getAttribute("estadoCitaFiltro");
    Integer citasHoy = (Integer) request.getAttribute("citasHoy");
    Integer citasPendientes = (Integer) request.getAttribute("citasPendientes");
    Integer citasConfirmadas = (Integer) request.getAttribute("citasConfirmadas");
    Integer citasAtendidas = (Integer) request.getAttribute("citasAtendidas");
    List<Cita> citasTecnico = (List<Cita>) request.getAttribute("citasTecnico");
    Usuario tecnicoActual = (Usuario) request.getAttribute("tecnicoActual");
    Cita citaDetalle = (Cita) request.getAttribute("citaDetalle");
%>
<nav class="app-topbar">
    <div class="app-topbar-inner">
        <div class="brand-stack">
            <span class="brand-title">Panel Tecnico</span>
            <span class="brand-subtitle">Vista operativa para revisar citas del taller y preparar la atencion</span>
        </div>
        <div class="topbar-actions">
            <a href="inicio" class="app-button app-button-secondary">Inicio</a>
            <a href="logout" class="app-button app-button-outline">Cerrar sesion</a>
        </div>
    </div>
</nav>

<main class="app-shell page-section">
    <section class="section-hero">
        <span class="eyebrow">Operacion del taller</span>
        <h1 class="form-title mt-3">Agenda tecnica diaria</h1>
        <p class="form-subtitle">
            Consulta las citas programadas, filtra por fecha o estado y prepara cada servicio antes de recibir el vehiculo.
            <% if (tecnicoActual != null && "TECNICO".equalsIgnoreCase(tecnicoActual.getRol())) { %>
            Mostrando solo citas asignadas a <strong><%= tecnicoActual.getUsername() %></strong>.
            <% } %>
        </p>
    </section>

    <section class="stats-grid">
        <article class="stat-card">
            <div class="stat-label">Citas de hoy</div>
            <div class="stat-value"><%= citasHoy %></div>
            <div class="stat-help">Carga estimada del dia actual.</div>
        </article>
        <article class="stat-card stat-card-highlight">
            <div class="stat-label">Pendientes</div>
            <div class="stat-value"><%= citasPendientes %></div>
            <div class="stat-help">Citas que aun requieren atencion o confirmacion operativa.</div>
        </article>
        <article class="stat-card">
            <div class="stat-label">Confirmadas</div>
            <div class="stat-value"><%= citasConfirmadas %></div>
            <div class="stat-help">Citas listas para recibir al cliente en taller.</div>
        </article>
        <article class="stat-card">
            <div class="stat-label">Atendidas</div>
            <div class="stat-value"><%= citasAtendidas %></div>
            <div class="stat-help">Citas que ya fueron completadas por el equipo.</div>
        </article>
        <article class="stat-card">
            <div class="stat-label">Visibles</div>
            <div class="stat-value"><%= citasTecnico == null ? 0 : citasTecnico.size() %></div>
            <div class="stat-help">Citas que coinciden con los filtros aplicados.</div>
        </article>
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

    <section class="table-card">
        <div class="table-title">
            <h3>Filtros tecnicos</h3>
        </div>
        <div class="form-helper-card mb-3">Usa estos filtros para concentrarte en la agenda del dia o en citas que todavia requieren accion.</div>
        <form action="tecnico" method="get" class="filter-grid">
            <div>
                <label for="fechaCita" class="form-label">Fecha</label>
                <input type="date" id="fechaCita" name="fechaCita" class="form-control app-field" value="<%= fechaCitaFiltro == null ? "" : fechaCitaFiltro %>">
            </div>
            <div>
                <label for="estadoCita" class="form-label">Estado</label>
                <select id="estadoCita" name="estadoCita" class="form-select app-field">
                    <option value="todos" <%= "todos".equals(estadoCitaFiltro) ? "selected" : "" %>>Todos</option>
                    <option value="pendiente" <%= "pendiente".equals(estadoCitaFiltro) ? "selected" : "" %>>Pendiente</option>
                    <option value="confirmada" <%= "confirmada".equals(estadoCitaFiltro) ? "selected" : "" %>>Confirmada</option>
                    <option value="atendida" <%= "atendida".equals(estadoCitaFiltro) ? "selected" : "" %>>Atendida</option>
                    <option value="cancelada" <%= "cancelada".equals(estadoCitaFiltro) ? "selected" : "" %>>Cancelada</option>
                    <option value="vencida" <%= "vencida".equals(estadoCitaFiltro) ? "selected" : "" %>>Vencida</option>
                </select>
            </div>
            <div class="filter-actions">
                <button type="submit" class="app-button app-button-primary">Aplicar filtros</button>
                <a href="tecnico" class="app-button app-button-outline">Hoy</a>
            </div>
        </form>
    </section>

    <% if (citaDetalle != null) { %>
    <section class="table-card">
        <div class="table-title">
            <h3>Detalle de la cita</h3>
            <a href="cita-pdf?token=<%= citaDetalle.getTokenVerificacion() %>" class="app-button app-button-secondary app-button-sm">Descargar PDF</a>
        </div>
        <div class="form-helper-card mb-3">Primero revisa servicio, horario, contacto y observaciones. Luego actualiza solo el estado operativo necesario.</div>
        <div class="detail-grid">
            <article class="detail-card">
                <div class="detail-label">Codigo</div>
                <div class="detail-value"><%= citaDetalle.getCodigoVerificacion() %></div>
            </article>
            <article class="detail-card">
                <div class="detail-label">Cliente</div>
                <div class="detail-value"><%= citaDetalle.getNombreCliente() %></div>
            </article>
            <article class="detail-card">
                <div class="detail-label">Servicio</div>
                <div class="detail-value"><%= citaDetalle.getNombreCatalogoServicio() == null || citaDetalle.getNombreCatalogoServicio().isBlank() ? citaDetalle.getTipoServicio() : citaDetalle.getNombreCatalogoServicio() %></div>
            </article>
            <article class="detail-card">
                <div class="detail-label">Detalle tecnico</div>
                <div class="detail-value"><%= citaDetalle.getDetalleServicio() %></div>
            </article>
            <article class="detail-card">
                <div class="detail-label">Fecha y horario</div>
                <div class="detail-value"><%= citaDetalle.getFechaCita() %> | <%= citaDetalle.getFranjaHoraria() %></div>
            </article>
            <article class="detail-card">
                <div class="detail-label">Contacto</div>
                <div class="detail-value"><%= citaDetalle.getTelefonoCliente() %><br><span class="muted-text"><%= citaDetalle.getCorreoCliente() %></span></div>
            </article>
            <article class="detail-card">
                <div class="detail-label">Observaciones</div>
                <div class="detail-value"><%= citaDetalle.getObservaciones() == null || citaDetalle.getObservaciones().isBlank() ? "Sin observaciones adicionales" : citaDetalle.getObservaciones() %></div>
            </article>
            <article class="detail-card">
                <div class="detail-label">Estado actual</div>
                <div class="detail-value"><span class="status-pill status-<%= citaDetalle.getEstadoCita() %>"><%= citaDetalle.getEstadoCita() %></span></div>
            </article>
            <article class="detail-card">
                <div class="detail-label">Tecnico asignado</div>
                <div class="detail-value"><%= citaDetalle.getNombreTecnicoAsignado() == null || citaDetalle.getNombreTecnicoAsignado().isBlank() ? "Sin asignar" : citaDetalle.getNombreTecnicoAsignado() %></div>
            </article>
        </div>

        <form action="tecnico" method="post" class="user-form-grid-wide">
            <input type="hidden" name="accion" value="actualizarEstado">
            <input type="hidden" name="idCita" value="<%= citaDetalle.getIdCita() %>">
            <input type="hidden" name="<%= CsrfUtil.CSRF_REQUEST_PARAM %>" value="<%= CsrfUtil.obtenerToken(request) %>">
            <div>
                <label for="estadoCitaDetalle" class="form-label">Actualizar estado operativo</label>
                <select id="estadoCitaDetalle" name="estadoCita" class="form-select app-field">
                    <option value="confirmada" <%= "confirmada".equals(citaDetalle.getEstadoCita()) ? "selected" : "" %>>Confirmada</option>
                    <option value="atendida" <%= "atendida".equals(citaDetalle.getEstadoCita()) ? "selected" : "" %>>Atendida</option>
                    <option value="vencida" <%= "vencida".equals(citaDetalle.getEstadoCita()) ? "selected" : "" %>>Vencida</option>
                </select>
            </div>
            <div class="filter-actions">
                <button type="submit" class="app-button app-button-primary">Guardar estado</button>
                <a href="tecnico" class="app-button app-button-outline">Cerrar detalle</a>
            </div>
        </form>
    </section>
    <% } %>

    <section class="table-card">
        <div class="table-title">
            <h3>Citas visibles para el equipo tecnico</h3>
        </div>
        <div class="table-responsive-shell">
            <table class="admin-table">
                <thead>
                <tr>
                    <th>Codigo</th>
                    <th>Cliente</th>
                    <th>Servicio</th>
                    <th>Detalle</th>
                    <th>Horario</th>
                    <th>Estado</th>
                    <th>Asignacion</th>
                    <th>Contacto</th>
                    <th>Accion</th>
                </tr>
                </thead>
                <tbody>
                <% if (citasTecnico != null && !citasTecnico.isEmpty()) {
                    for (Cita cita : citasTecnico) { %>
                <tr>
                    <td><%= cita.getCodigoVerificacion() %></td>
                    <td><%= cita.getNombreCliente() %></td>
                    <td><%= cita.getNombreCatalogoServicio() == null || cita.getNombreCatalogoServicio().isBlank() ? cita.getTipoServicio() : cita.getNombreCatalogoServicio() %></td>
                    <td><%= cita.getDetalleServicio() %></td>
                    <td><%= cita.getFechaCita() %> | <%= cita.getFranjaHoraria() %></td>
                    <td><span class="status-pill status-<%= cita.getEstadoCita() %>"><%= cita.getEstadoCita() %></span></td>
                    <td><%= cita.getNombreTecnicoAsignado() == null || cita.getNombreTecnicoAsignado().isBlank() ? "Pendiente de asignacion" : cita.getNombreTecnicoAsignado() %></td>
                    <td><%= cita.getTelefonoCliente() %></td>
                    <td><a href="tecnico?accion=detalle&idCita=<%= cita.getIdCita() %>&fechaCita=<%= fechaCitaFiltro %>&estadoCita=<%= estadoCitaFiltro %>" class="app-button app-button-outline app-button-sm">Ver detalle</a></td>
                </tr>
                <% }
                } else { %>
                <tr>
                    <td colspan="9">
                        <div class="empty-state">
                            <h4>No hay citas para los filtros actuales</h4>
                            <p>Cambia la fecha o selecciona todos los estados para revisar mas trabajo asignado.</p>
                            <a href="tecnico" class="app-button app-button-primary">Volver a hoy</a>
                        </div>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </section>
</main>
</body>
</html>
