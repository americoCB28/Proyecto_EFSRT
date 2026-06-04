<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Cita" %>
<%@ page import="model.Usuario" %>
<%@ page import="util.CsrfUtil" %>
<!DOCTYPE html>
<html>
<head>
    <title>Agenda de citas</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/styles.css" rel="stylesheet">
</head>
<body class="app-body">
<%
    String flashSuccess = (String) request.getAttribute("flashSuccess");
    String flashWarning = (String) request.getAttribute("flashWarning");
    String flashError = (String) request.getAttribute("flashError");
    Integer totalCitas = (Integer) request.getAttribute("totalCitas");
    Integer citasPendientes = (Integer) request.getAttribute("citasPendientes");
    Integer citasConfirmadas = (Integer) request.getAttribute("citasConfirmadas");
    Integer citasHoy = (Integer) request.getAttribute("citasHoy");
    String fechaCitaFiltro = (String) request.getAttribute("fechaCitaFiltro");
    String estadoCitaFiltro = (String) request.getAttribute("estadoCitaFiltro");
    Boolean validacionExitosa = (Boolean) request.getAttribute("validacionExitosa");
    Cita citaVerificada = (Cita) request.getAttribute("citaVerificada");
    List<Cita> ultimasCitas = (List<Cita>) request.getAttribute("ultimasCitas");
    List<Usuario> tecnicos = (List<Usuario>) request.getAttribute("tecnicos");
%>

<nav class="app-topbar">
    <div class="app-topbar-inner">
        <div class="brand-stack">
            <span class="brand-title">Agenda de Citas</span>
            <span class="brand-subtitle">Gestiona la agenda, valida citas y confirma atenciones desde la zona administrativa</span>
        </div>
        <div class="topbar-actions">
            <a href="inicio" class="app-button app-button-secondary">Inicio</a>
            <a href="servicio?tipo=dashboard" class="app-button app-button-info">Dashboard</a>
            <a href="servicios-admin" class="app-button app-button-info">Servicios</a>
            <a href="servicio?tipo=reportes" class="app-button app-button-info">Atenciones</a>
            <a href="logout" class="app-button app-button-outline">Cerrar sesion</a>
        </div>
    </div>
</nav>

<main class="app-shell page-section">
    <section class="section-hero">
        <span class="eyebrow">Agenda operativa</span>
        <h1 class="form-title mt-3">Validacion y seguimiento de citas</h1>
        <p class="form-subtitle">Esta pantalla permite revisar si una cita es valida, descargar su constancia y filtrar la agenda por fecha o estado.</p>
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
        <div class="stats-grid mb-3">
            <article class="stat-card">
                <div class="stat-label">Total citas</div>
                <div class="stat-value"><%= totalCitas %></div>
                <div class="stat-help">Citas registradas en el nuevo flujo comercial.</div>
            </article>
            <article class="stat-card">
                <div class="stat-label">Pendientes</div>
                <div class="stat-value"><%= citasPendientes %></div>
                <div class="stat-help">Citas aun no atendidas ni canceladas.</div>
            </article>
            <article class="stat-card">
                <div class="stat-label">Confirmadas</div>
                <div class="stat-value"><%= citasConfirmadas %></div>
                <div class="stat-help">Citas ya validadas para atencion.</div>
            </article>
            <article class="stat-card stat-card-highlight">
                <div class="stat-label">Citas de hoy</div>
                <div class="stat-value"><%= citasHoy %></div>
                <div class="stat-help">Carga operativa del dia actual.</div>
            </article>
        </div>
    </section>

    <section class="table-card">
        <div class="table-title">
            <h3>Buscar por codigo</h3>
        </div>
        <form action="admin-citas" method="get" class="user-form-grid">
            <input type="hidden" name="accion" value="buscar">
            <div>
                <label for="codigo" class="form-label">Codigo de la cita</label>
                <input type="text" id="codigo" name="codigo" class="form-control app-field" placeholder="Ejemplo: CITA-20260530-0001">
            </div>
            <div class="filter-actions">
                <button type="submit" class="app-button app-button-primary">Buscar cita</button>
            </div>
        </form>
    </section>

    <section class="table-card">
        <div class="table-title">
            <h3>Agenda y filtros</h3>
        </div>
        <form action="admin-citas" method="get" class="filter-grid">
            <div>
                <label for="fechaCita" class="form-label">Fecha de cita</label>
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
                <a href="admin-citas" class="app-button app-button-outline">Limpiar</a>
            </div>
        </form>
    </section>

    <% if (Boolean.TRUE.equals(validacionExitosa) && citaVerificada != null) { %>
    <section class="table-card">
        <div class="table-title">
            <h3>Cita validada</h3>
            <a href="cita-pdf?token=<%= citaVerificada.getTokenVerificacion() %>" class="app-button app-button-secondary app-button-sm">Descargar PDF</a>
        </div>
        <div class="detail-grid">
            <article class="detail-card">
                <div class="detail-label">Codigo</div>
                <div class="detail-value"><%= citaVerificada.getCodigoVerificacion() %></div>
            </article>
            <article class="detail-card">
                <div class="detail-label">Cliente</div>
                <div class="detail-value"><%= citaVerificada.getNombreCliente() %></div>
            </article>
            <article class="detail-card">
                <div class="detail-label">Servicio</div>
                <div class="detail-value"><%= citaVerificada.getNombreCatalogoServicio() == null || citaVerificada.getNombreCatalogoServicio().isBlank() ? citaVerificada.getTipoServicio() : citaVerificada.getNombreCatalogoServicio() %></div>
            </article>
            <article class="detail-card">
                <div class="detail-label">Detalle</div>
                <div class="detail-value"><%= citaVerificada.getDetalleServicio() %></div>
            </article>
            <article class="detail-card">
                <div class="detail-label">Fecha</div>
                <div class="detail-value"><%= citaVerificada.getFechaCita() %></div>
            </article>
            <article class="detail-card">
                <div class="detail-label">Horario</div>
                <div class="detail-value"><%= citaVerificada.getFranjaHoraria() %></div>
            </article>
            <article class="detail-card">
                <div class="detail-label">Telefono</div>
                <div class="detail-value"><%= citaVerificada.getTelefonoCliente() %></div>
            </article>
            <article class="detail-card">
                <div class="detail-label">Correo</div>
                <div class="detail-value"><%= citaVerificada.getCorreoCliente() %></div>
            </article>
            <article class="detail-card">
                <div class="detail-label">Estado</div>
                <div class="detail-value"><span class="status-pill status-<%= citaVerificada.getEstadoCita() %>"><%= citaVerificada.getEstadoCita() %></span></div>
            </article>
            <article class="detail-card">
                <div class="detail-label">Tecnico asignado</div>
                <div class="detail-value"><%= citaVerificada.getNombreTecnicoAsignado() == null || citaVerificada.getNombreTecnicoAsignado().isBlank() ? "Sin asignar" : citaVerificada.getNombreTecnicoAsignado() %></div>
            </article>
            <article class="detail-card">
                <div class="detail-label">Precio estimado</div>
                <div class="detail-value">S/ <%= String.format(java.util.Locale.US, "%.2f", citaVerificada.getPrecioEstimado()) %></div>
            </article>
        </div>
    </section>
    <% } %>

    <section class="table-card">
        <div class="table-title">
            <h3>Agenda de citas</h3>
        </div>
        <div class="table-responsive-shell">
            <table class="admin-table">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Codigo</th>
                    <th>Cliente</th>
                    <th>Servicio</th>
                    <th>Fecha</th>
                    <th>Horario</th>
                    <th>Estado</th>
                    <th>Tecnico</th>
                    <th>Entrega</th>
                    <th>Accion</th>
                </tr>
                </thead>
                <tbody>
                <% if (ultimasCitas != null && !ultimasCitas.isEmpty()) {
                    for (Cita cita : ultimasCitas) { %>
                <tr>
                    <td><%= cita.getIdCita() %></td>
                    <td><%= cita.getCodigoVerificacion() %></td>
                    <td><%= cita.getNombreCliente() %></td>
                    <td><%= cita.getNombreCatalogoServicio() == null || cita.getNombreCatalogoServicio().isBlank() ? cita.getTipoServicio() : cita.getNombreCatalogoServicio() %></td>
                    <td><%= cita.getFechaCita() %></td>
                    <td><%= cita.getFranjaHoraria() %></td>
                    <td>
                        <form action="admin-citas" method="post" class="table-inline-form">
                            <input type="hidden" name="accion" value="actualizarEstado">
                            <input type="hidden" name="idCita" value="<%= cita.getIdCita() %>">
                            <input type="hidden" name="<%= CsrfUtil.CSRF_REQUEST_PARAM %>" value="<%= CsrfUtil.obtenerToken(request) %>">
                            <div class="table-status-editor">
                                <span class="status-pill status-<%= cita.getEstadoCita() %>"><%= cita.getEstadoCita() %></span>
                                <select name="estadoCita" class="form-select app-field app-field-sm">
                                    <option value="pendiente" <%= "pendiente".equals(cita.getEstadoCita()) ? "selected" : "" %>>Pendiente</option>
                                    <option value="confirmada" <%= "confirmada".equals(cita.getEstadoCita()) ? "selected" : "" %>>Confirmada</option>
                                    <option value="atendida" <%= "atendida".equals(cita.getEstadoCita()) ? "selected" : "" %>>Atendida</option>
                                    <option value="cancelada" <%= "cancelada".equals(cita.getEstadoCita()) ? "selected" : "" %>>Cancelada</option>
                                    <option value="vencida" <%= "vencida".equals(cita.getEstadoCita()) ? "selected" : "" %>>Vencida</option>
                                </select>
                                <button type="submit" class="app-button app-button-warning app-button-sm">Guardar</button>
                            </div>
                        </form>
                    </td>
                    <td>
                        <form action="admin-citas" method="post" class="table-inline-form">
                            <input type="hidden" name="accion" value="asignarTecnico">
                            <input type="hidden" name="idCita" value="<%= cita.getIdCita() %>">
                            <input type="hidden" name="<%= CsrfUtil.CSRF_REQUEST_PARAM %>" value="<%= CsrfUtil.obtenerToken(request) %>">
                            <div class="table-status-editor">
                                <span class="status-pill status-neutral"><%= cita.getNombreTecnicoAsignado() == null || cita.getNombreTecnicoAsignado().isBlank() ? "Sin asignar" : cita.getNombreTecnicoAsignado() %></span>
                                <select name="idTecnicoAsignado" class="form-select app-field app-field-sm">
                                    <option value="0">Sin asignar</option>
                                    <% if (tecnicos != null) {
                                        for (Usuario tecnico : tecnicos) { %>
                                    <option value="<%= tecnico.getIdUsuario() %>" <%= cita.getIdTecnicoAsignado() != null && cita.getIdTecnicoAsignado() == tecnico.getIdUsuario() ? "selected" : "" %>><%= tecnico.getUsername() %></option>
                                    <% }
                                    } %>
                                </select>
                                <button type="submit" class="app-button app-button-info app-button-sm">Asignar</button>
                            </div>
                        </form>
                    </td>
                    <td><%= cita.getCanalEntrega() == null || cita.getCanalEntrega().isBlank() ? "web" : cita.getCanalEntrega() %></td>
                    <td class="table-action-stack">
                        <a href="admin-citas?accion=verificar&token=<%= cita.getTokenVerificacion() %>" class="app-button app-button-outline app-button-sm">Validar</a>
                        <a href="cita-pdf?token=<%= cita.getTokenVerificacion() %>" class="app-button app-button-secondary app-button-sm">PDF</a>
                    </td>
                </tr>
                <% }
                } else { %>
                <tr>
                    <td colspan="10">No hay citas registradas para los filtros actuales.</td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </section>
</main>
</body>
</html>
