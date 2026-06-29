<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="jakarta.servlet.http.HttpServletRequest" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Cliente" %>
<%@ page import="model.Pedido" %>
<%@ page import="model.PedidoLogotipo" %>
<%@ page import="model.PedidoInstalacion" %>
<%!
    private int numeroAttr(HttpServletRequest request, String nombre) {
        Object valor = request.getAttribute(nombre);
        return valor instanceof Integer ? (Integer) valor : 0;
    }

    private String etiquetaServicio(String servicio) {
        if ("polarizado".equals(servicio)) {
            return "Polarizado";
        }
        if ("logotipo".equals(servicio)) {
            return "Logotipo";
        }
        if ("instalacion".equals(servicio)) {
            return "Instalacion";
        }
        return "Todos los servicios";
    }

    private String etiquetaEstado(String estado) {
        if ("pendiente".equals(estado)) {
            return "Pendiente";
        }
        if ("en_proceso".equals(estado)) {
            return "En proceso";
        }
        if ("terminado".equals(estado)) {
            return "Terminado";
        }
        if ("cancelado".equals(estado)) {
            return "Cancelado";
        }
        return "Todos los estados";
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Atenciones registradas</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/styles.css" rel="stylesheet">
</head>
<body class="app-body">
<%
    String flashSuccess = (String) request.getAttribute("flashSuccess");
    String flashWarning = (String) request.getAttribute("flashWarning");
    String flashError = (String) request.getAttribute("flashError");
    String clienteFiltro = (String) request.getAttribute("clienteFiltro");
    String servicioFiltro = (String) request.getAttribute("servicioFiltro");
    String estadoFiltro = (String) request.getAttribute("estadoFiltro");
    List<Cliente> clientes = (List<Cliente>) request.getAttribute("clientes");
    List<Pedido> pedidos = (List<Pedido>) request.getAttribute("pedidos");
    List<PedidoLogotipo> pedidosLogotipo = (List<PedidoLogotipo>) request.getAttribute("pedidosLogotipo");
    List<PedidoInstalacion> pedidosInstalacion = (List<PedidoInstalacion>) request.getAttribute("pedidosInstalacion");
    int totalAtenciones = numeroAttr(request, "totalAtenciones");
    int totalPendientes = numeroAttr(request, "totalPendientes");
    int totalEnProceso = numeroAttr(request, "totalEnProceso");
    int totalTerminadas = numeroAttr(request, "totalTerminadas");
    int totalCanceladas = numeroAttr(request, "totalCanceladas");
    boolean tieneFiltroCliente = clienteFiltro != null && !clienteFiltro.isBlank();
    boolean tieneFiltroServicio = servicioFiltro != null && !"todos".equals(servicioFiltro);
    boolean tieneFiltroEstado = estadoFiltro != null && !"todos".equals(estadoFiltro);
    boolean hayAtenciones = totalAtenciones > 0;
    String tituloAtenciones = tieneFiltroServicio
            ? "Atenciones de " + etiquetaServicio(servicioFiltro).toLowerCase()
            : "Todas las atenciones";
%>

<nav class="app-topbar">
    <div class="app-topbar-inner">
        <div class="brand-stack">
            <span class="brand-title">Panel Administrativo</span>
            <span class="brand-subtitle">Atenciones, clientes y exportacion operativa del taller</span>
        </div>
        <div class="topbar-actions">
            <a href="inicio" class="app-button app-button-secondary">Inicio</a>
            <a href="servicio?tipo=dashboard" class="app-button app-button-info">Dashboard</a>
            <a href="admin-citas" class="app-button app-button-info">Agenda</a>
            <a href="servicio?tipo=reportes" class="app-button app-button-info">Atenciones</a>
            <a href="servicios-admin" class="app-button app-button-info">Servicios</a>
            <a href="usuarios" class="app-button app-button-info">Usuarios</a>
            <a href="logout" class="app-button app-button-outline">Cerrar sesion</a>
        </div>
    </div>
</nav>

<main class="app-shell page-section reports-page">
    <section class="reports-hero">
        <div>
            <span class="eyebrow">Zona protegida</span>
            <h1 class="form-title mt-3">Atenciones registradas</h1>
            <p class="form-subtitle">Revisa el estado del taller, filtra solicitudes y exporta la informacion visible.</p>
        </div>
        <div class="reports-hero-actions">
            <form action="servicio" method="get">
                <input type="hidden" name="tipo" value="exportarCsv">
                <input type="hidden" name="cliente" value="<%= clienteFiltro == null ? "" : clienteFiltro %>">
                <input type="hidden" name="servicioFiltro" value="<%= servicioFiltro == null ? "todos" : servicioFiltro %>">
                <input type="hidden" name="estadoFiltro" value="<%= estadoFiltro == null ? "todos" : estadoFiltro %>">
                <button type="submit" class="app-button app-button-primary">Exportar CSV</button>
            </form>
            <a href="servicio?tipo=actualizarReporte" class="app-button app-button-secondary">Modificar datos</a>
            <a href="servicio?tipo=dashboard" class="app-button app-button-outline">Dashboard</a>
        </div>
    </section>

    <section class="report-kpi-grid" aria-label="Resumen de atenciones filtradas">
        <article class="report-kpi-card report-kpi-card-main">
            <span class="report-kpi-label">Atenciones visibles</span>
            <strong class="report-kpi-value"><%= totalAtenciones %></strong>
            <span class="report-kpi-help"><%= etiquetaServicio(servicioFiltro) %></span>
        </article>
        <article class="report-kpi-card">
            <span class="report-kpi-label">Pendientes</span>
            <strong class="report-kpi-value"><%= totalPendientes %></strong>
        </article>
        <article class="report-kpi-card">
            <span class="report-kpi-label">En proceso</span>
            <strong class="report-kpi-value"><%= totalEnProceso %></strong>
        </article>
        <article class="report-kpi-card">
            <span class="report-kpi-label">Terminadas</span>
            <strong class="report-kpi-value"><%= totalTerminadas %></strong>
        </article>
        <article class="report-kpi-card report-kpi-card-danger">
            <span class="report-kpi-label">Canceladas</span>
            <strong class="report-kpi-value"><%= totalCanceladas %></strong>
        </article>
    </section>

    <section class="report-filter-panel">
        <div class="table-title">
            <h3>Filtros</h3>
            <span class="report-result-count"><%= totalAtenciones %> atenciones encontradas</span>
        </div>
        <form action="servicio" method="get" class="report-filter-grid">
            <input type="hidden" name="tipo" value="reportes">
            <div>
                <label class="form-label" for="cliente">Buscar por cliente</label>
                <input type="text" id="cliente" name="cliente" value="<%= clienteFiltro == null ? "" : clienteFiltro %>"
                       class="form-control app-field" placeholder="Ejemplo: Juan Perez">
            </div>
            <div>
                <label class="form-label" for="servicioFiltro">Servicio</label>
                <select id="servicioFiltro" name="servicioFiltro" class="form-select app-field">
                    <option value="todos" <%= "todos".equals(servicioFiltro) ? "selected" : "" %>>Todos</option>
                    <option value="polarizado" <%= "polarizado".equals(servicioFiltro) ? "selected" : "" %>>Polarizado</option>
                    <option value="logotipo" <%= "logotipo".equals(servicioFiltro) ? "selected" : "" %>>Logotipo</option>
                    <option value="instalacion" <%= "instalacion".equals(servicioFiltro) ? "selected" : "" %>>Instalacion</option>
                </select>
            </div>
            <div>
                <label class="form-label" for="estadoFiltro">Estado</label>
                <select id="estadoFiltro" name="estadoFiltro" class="form-select app-field">
                    <option value="todos" <%= "todos".equals(estadoFiltro) ? "selected" : "" %>>Todos</option>
                    <option value="pendiente" <%= "pendiente".equals(estadoFiltro) ? "selected" : "" %>>Pendiente</option>
                    <option value="en_proceso" <%= "en_proceso".equals(estadoFiltro) ? "selected" : "" %>>En proceso</option>
                    <option value="terminado" <%= "terminado".equals(estadoFiltro) ? "selected" : "" %>>Terminado</option>
                    <option value="cancelado" <%= "cancelado".equals(estadoFiltro) ? "selected" : "" %>>Cancelado</option>
                </select>
            </div>
            <div class="filter-actions">
                <button type="submit" class="app-button app-button-primary">Filtrar</button>
                <a href="servicio?tipo=reportes" class="app-button app-button-secondary">Limpiar</a>
            </div>
        </form>
        <div class="filter-chip-row" aria-label="Filtros activos">
            <% if (tieneFiltroCliente) { %>
            <span class="filter-chip">Cliente: <%= clienteFiltro %></span>
            <% } %>
            <% if (tieneFiltroServicio) { %>
            <span class="filter-chip">Servicio: <%= etiquetaServicio(servicioFiltro) %></span>
            <% } %>
            <% if (tieneFiltroEstado) { %>
            <span class="filter-chip">Estado: <%= etiquetaEstado(estadoFiltro) %></span>
            <% } %>
            <% if (!tieneFiltroCliente && !tieneFiltroServicio && !tieneFiltroEstado) { %>
            <span class="filter-chip filter-chip-neutral">Sin filtros activos</span>
            <% } %>
        </div>
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

    <section class="table-card report-table-card">
        <div class="table-title">
            <div>
                <h3><%= tituloAtenciones %></h3>
                <span class="table-note"><%= totalAtenciones %> registros visibles con los filtros actuales</span>
            </div>
            <a href="servicio?tipo=actualizarReporte" class="app-button app-button-outline app-button-sm">Editar datos</a>
        </div>

        <% if (hayAtenciones) { %>
        <div class="table-responsive-shell">
            <table class="admin-table report-attention-table">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Cliente</th>
                    <th>Servicio</th>
                    <th>Detalle</th>
                    <th>Estado</th>
                    <th>Fecha</th>
                    <th>Accion</th>
                </tr>
                </thead>
                <tbody>
                <% if (pedidos != null) {
                    for (Pedido p : pedidos) { %>
                <tr>
                    <td data-label="ID">POL-<%= p.getIdPedido() %></td>
                    <td data-label="Cliente"><%= p.getNombreCliente() %></td>
                    <td data-label="Servicio"><span class="service-badge service-badge-polarizado">Polarizado</span></td>
                    <td data-label="Detalle"><%= p.getMaterial() %> / <%= p.getLuzVisible() %></td>
                    <td data-label="Estado"><span class="status-pill status-<%= p.getEstado() %>"><%= p.getEstado() %></span></td>
                    <td data-label="Fecha"><%= p.getFechaPedido() %></td>
                    <td data-label="Accion">
                        <a href="servicio?tipo=historialCliente&idCliente=<%= p.getIdCliente() %>"
                           class="app-button app-button-outline app-button-sm">Ver historial</a>
                    </td>
                </tr>
                <% }
                } %>
                <% if (pedidosLogotipo != null) {
                    for (PedidoLogotipo pl : pedidosLogotipo) { %>
                <tr>
                    <td data-label="ID">LOG-<%= pl.getIdPedidoLogotipo() %></td>
                    <td data-label="Cliente"><%= pl.getNombreCliente() %></td>
                    <td data-label="Servicio"><span class="service-badge service-badge-logotipo">Logotipo</span></td>
                    <td data-label="Detalle"><%= pl.getServicioSeleccionado() %></td>
                    <td data-label="Estado"><span class="status-pill status-<%= pl.getEstado() %>"><%= pl.getEstado() %></span></td>
                    <td data-label="Fecha"><%= pl.getFechaPedido() %></td>
                    <td data-label="Accion">
                        <a href="servicio?tipo=historialCliente&idCliente=<%= pl.getIdCliente() %>"
                           class="app-button app-button-outline app-button-sm">Ver historial</a>
                    </td>
                </tr>
                <% }
                } %>
                <% if (pedidosInstalacion != null) {
                    for (PedidoInstalacion pi : pedidosInstalacion) { %>
                <tr>
                    <td data-label="ID">INS-<%= pi.getIdPedidoInstalacion() %></td>
                    <td data-label="Cliente"><%= pi.getNombreCliente() %></td>
                    <td data-label="Servicio"><span class="service-badge service-badge-instalacion">Instalacion</span></td>
                    <td data-label="Detalle"><%= pi.getServicioSeleccionado() %></td>
                    <td data-label="Estado"><span class="status-pill status-<%= pi.getEstado() %>"><%= pi.getEstado() %></span></td>
                    <td data-label="Fecha"><%= pi.getFechaPedido() %></td>
                    <td data-label="Accion">
                        <a href="servicio?tipo=historialCliente&idCliente=<%= pi.getIdCliente() %>"
                           class="app-button app-button-outline app-button-sm">Ver historial</a>
                    </td>
                </tr>
                <% }
                } %>
                </tbody>
            </table>
        </div>
        <% } else { %>
        <div class="empty-state">
            <h4>No hay atenciones con estos filtros</h4>
            <p>Prueba con otro cliente, servicio o estado para ampliar los resultados.</p>
            <a href="servicio?tipo=reportes" class="app-button app-button-primary">Limpiar filtros</a>
        </div>
        <% } %>
    </section>

    <section class="table-card report-client-card">
        <div class="table-title">
            <div>
                <h3>Clientes relacionados</h3>
                <span class="table-note">Acceso rapido al historial completo del cliente</span>
            </div>
        </div>
        <div class="table-responsive-shell">
            <table class="admin-table report-client-table">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Nombre</th>
                    <th>Accion</th>
                </tr>
                </thead>
                <tbody>
                <% if (clientes != null && !clientes.isEmpty()) {
                    for (Cliente c : clientes) { %>
                <tr>
                    <td data-label="ID"><%= c.getIdCliente() %></td>
                    <td data-label="Nombre"><%= c.getNombre() %></td>
                    <td data-label="Accion">
                        <a href="servicio?tipo=historialCliente&idCliente=<%= c.getIdCliente() %>"
                           class="app-button app-button-outline app-button-sm">Ver historial</a>
                    </td>
                </tr>
                <% }
                } else { %>
                <tr>
                    <td colspan="3">No hay clientes relacionados con la busqueda actual.</td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </section>
</main>
</body>
</html>
