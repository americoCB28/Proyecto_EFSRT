<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Cliente" %>
<%@ page import="model.Pedido" %>
<%@ page import="model.PedidoLogotipo" %>
<%@ page import="model.PedidoInstalacion" %>
<!DOCTYPE html>
<html>
<head>
    <title>Reportes</title>
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
%>

<nav class="app-topbar">
    <div class="app-topbar-inner">
        <div class="brand-stack">
            <span class="brand-title">Panel Administrativo</span>
            <span class="brand-subtitle">Consulta clientes y pedidos registrados desde una sola vista</span>
        </div>
        <div class="topbar-actions">
            <a href="inicio" class="app-button app-button-secondary">Inicio</a>
            <a href="servicio?tipo=dashboard" class="app-button app-button-info">Dashboard</a>
            <a href="servicio?tipo=actualizarReporte" class="app-button app-button-info">Modificar</a>
            <a href="logout" class="app-button app-button-outline">Cerrar sesion</a>
        </div>
    </div>
</nav>

<main class="app-shell page-section">
    <section class="section-hero">
        <span class="eyebrow">Zona protegida</span>
        <h1 class="form-title mt-3">Reportes y seguimiento</h1>
        <p class="form-subtitle">Esta pantalla prioriza legibilidad, espaciado y navegacion clara para revisar la informacion actual.</p>
    </section>

    <section class="table-card">
        <div class="table-title">
            <h3>Filtros de reportes</h3>
        </div>
        <form action="servicio" method="get" class="filter-grid">
            <input type="hidden" name="tipo" value="reportes">
            <div>
                <label class="form-label" for="cliente">Buscar por cliente</label>
                <input type="text" id="cliente" name="cliente" value="<%= clienteFiltro == null ? "" : clienteFiltro %>"
                       class="form-control app-field" placeholder="Ejemplo: Juan Perez">
            </div>
            <div>
                <label class="form-label" for="servicioFiltro">Tipo de servicio</label>
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
                <button type="submit" class="app-button app-button-primary">Aplicar filtros</button>
                <a href="servicio?tipo=reportes" class="app-button app-button-secondary">Limpiar</a>
            </div>
        </form>
        <form action="servicio" method="get" class="export-actions">
            <input type="hidden" name="tipo" value="exportarCsv">
            <input type="hidden" name="cliente" value="<%= clienteFiltro == null ? "" : clienteFiltro %>">
            <input type="hidden" name="servicioFiltro" value="<%= servicioFiltro == null ? "todos" : servicioFiltro %>">
            <input type="hidden" name="estadoFiltro" value="<%= estadoFiltro == null ? "todos" : estadoFiltro %>">
            <button type="submit" class="app-button app-button-info">Exportar CSV</button>
        </form>
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
            <h3>Clientes registrados</h3>
            <a href="servicio?tipo=actualizarReporte" class="app-button app-button-outline">Editar datos</a>
        </div>
        <div class="table-responsive-shell">
            <table class="admin-table">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Nombre</th>
                    <th>Accion</th>
                </tr>
                </thead>
                <tbody>
                <% if (clientes != null) {
                    for (Cliente c : clientes) { %>
                <tr>
                    <td><%= c.getIdCliente() %></td>
                    <td><%= c.getNombre() %></td>
                    <td>
                        <a href="servicio?tipo=historialCliente&idCliente=<%= c.getIdCliente() %>"
                           class="app-button app-button-outline app-button-sm">Ver historial</a>
                    </td>
                </tr>
                <% }
                } %>
                </tbody>
            </table>
        </div>
    </section>

    <% if ("todos".equals(servicioFiltro) || "polarizado".equals(servicioFiltro)) { %>
    <section class="table-card">
        <div class="table-title">
            <h3>Pedidos de polarizado</h3>
        </div>
        <div class="table-responsive-shell">
            <table class="admin-table">
                <thead>
                <tr>
                    <th>ID Pedido</th>
                    <th>Cliente</th>
                    <th>Material</th>
                    <th>Luz Visible</th>
                    <th>Estado</th>
                    <th>Fecha</th>
                </tr>
                </thead>
                <tbody>
                <% if (pedidos != null) {
                    for (Pedido p : pedidos) { %>
                <tr>
                    <td><%= p.getIdPedido() %></td>
                    <td><%= p.getNombreCliente() %></td>
                    <td><%= p.getMaterial() %></td>
                    <td><%= p.getLuzVisible() %></td>
                    <td><span class="status-pill status-<%= p.getEstado() %>"><%= p.getEstado() %></span></td>
                    <td><%= p.getFechaPedido() %></td>
                </tr>
                <% }
                } %>
                </tbody>
            </table>
        </div>
    </section>
    <% } %>

    <% if ("todos".equals(servicioFiltro) || "logotipo".equals(servicioFiltro)) { %>
    <section class="table-card">
        <div class="table-title">
            <h3>Pedidos de logotipos</h3>
        </div>
        <div class="table-responsive-shell">
            <table class="admin-table">
                <thead>
                <tr>
                    <th>ID Pedido</th>
                    <th>Cliente</th>
                    <th>Servicio</th>
                    <th>Estado</th>
                    <th>Fecha</th>
                </tr>
                </thead>
                <tbody>
                <% if (pedidosLogotipo != null) {
                    for (PedidoLogotipo pl : pedidosLogotipo) { %>
                <tr>
                    <td><%= pl.getIdPedidoLogotipo() %></td>
                    <td><%= pl.getNombreCliente() %></td>
                    <td><%= pl.getServicioSeleccionado() %></td>
                    <td><span class="status-pill status-<%= pl.getEstado() %>"><%= pl.getEstado() %></span></td>
                    <td><%= pl.getFechaPedido() %></td>
                </tr>
                <% }
                } %>
                </tbody>
            </table>
        </div>
    </section>
    <% } %>

    <% if ("todos".equals(servicioFiltro) || "instalacion".equals(servicioFiltro)) { %>
    <section class="table-card">
        <div class="table-title">
            <h3>Pedidos de instalaciones</h3>
        </div>
        <div class="table-responsive-shell">
            <table class="admin-table">
                <thead>
                <tr>
                    <th>ID Pedido</th>
                    <th>Cliente</th>
                    <th>Servicio</th>
                    <th>Estado</th>
                    <th>Fecha</th>
                </tr>
                </thead>
                <tbody>
                <% if (pedidosInstalacion != null) {
                    for (PedidoInstalacion pi : pedidosInstalacion) { %>
                <tr>
                    <td><%= pi.getIdPedidoInstalacion() %></td>
                    <td><%= pi.getNombreCliente() %></td>
                    <td><%= pi.getServicioSeleccionado() %></td>
                    <td><span class="status-pill status-<%= pi.getEstado() %>"><%= pi.getEstado() %></span></td>
                    <td><%= pi.getFechaPedido() %></td>
                </tr>
                <% }
                } %>
                </tbody>
            </table>
        </div>
    </section>
    <% } %>
</main>
</body>
</html>
