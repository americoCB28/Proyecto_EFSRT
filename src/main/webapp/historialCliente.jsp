<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Cliente" %>
<%@ page import="model.Pedido" %>
<%@ page import="model.PedidoLogotipo" %>
<%@ page import="model.PedidoInstalacion" %>
<!DOCTYPE html>
<html>
<head>
    <title>Historial del cliente</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/styles.css" rel="stylesheet">
</head>
<body class="app-body">
<%
    String flashSuccess = (String) request.getAttribute("flashSuccess");
    String flashWarning = (String) request.getAttribute("flashWarning");
    String flashError = (String) request.getAttribute("flashError");
    Cliente cliente = (Cliente) request.getAttribute("clienteHistorial");
    List<Pedido> pedidos = (List<Pedido>) request.getAttribute("pedidos");
    List<PedidoLogotipo> pedidosLogotipo = (List<PedidoLogotipo>) request.getAttribute("pedidosLogotipo");
    List<PedidoInstalacion> pedidosInstalacion = (List<PedidoInstalacion>) request.getAttribute("pedidosInstalacion");
%>

<nav class="app-topbar">
    <div class="app-topbar-inner">
        <div class="brand-stack">
            <span class="brand-title">Historial por Cliente</span>
            <span class="brand-subtitle">Consulta consolidada de citas y atenciones asociadas a un cliente</span>
        </div>
        <div class="topbar-actions">
            <a href="inicio" class="app-button app-button-secondary">Inicio</a>
            <a href="servicio?tipo=dashboard" class="app-button app-button-info">Dashboard</a>
            <a href="servicio?tipo=reportes" class="app-button app-button-info">Atenciones</a>
            <a href="admin-citas" class="app-button app-button-info">Validar citas</a>
            <a href="servicios-admin" class="app-button app-button-info">Servicios</a>
            <a href="usuarios" class="app-button app-button-info">Usuarios</a>
            <a href="logout" class="app-button app-button-outline">Cerrar sesion</a>
        </div>
    </div>
</nav>

<main class="app-shell page-section">
    <section class="section-hero">
        <span class="eyebrow">Vista protegida</span>
        <h1 class="form-title mt-3">Historial del cliente</h1>
        <p class="form-subtitle">Revisa todas las atenciones asociadas al cliente seleccionado sin salir del panel administrativo.</p>
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

    <section class="detail-grid">
        <article class="detail-card">
            <div class="detail-label">ID cliente</div>
            <div class="detail-value"><%= cliente.getIdCliente() %></div>
        </article>
        <article class="detail-card">
            <div class="detail-label">Nombre</div>
            <div class="detail-value"><%= cliente.getNombre() %></div>
        </article>
        <article class="detail-card">
            <div class="detail-label">Resumen</div>
            <div class="detail-value"><%= pedidos.size() + pedidosLogotipo.size() + pedidosInstalacion.size() %> atenciones registradas</div>
        </article>
    </section>

    <section class="table-card">
        <div class="table-title">
            <h3>Atenciones de polarizado</h3>
            <a href="servicio?tipo=reportes" class="app-button app-button-outline">Volver a atenciones</a>
        </div>
        <div class="table-responsive-shell">
            <table class="admin-table">
                <thead>
                <tr>
                    <th>ID Registro</th>
                    <th>Material</th>
                    <th>Luz Visible</th>
                    <th>Estado</th>
                    <th>Fecha</th>
                </tr>
                </thead>
                <tbody>
                <% if (pedidos != null && !pedidos.isEmpty()) {
                    for (Pedido pedido : pedidos) { %>
                <tr>
                    <td><%= pedido.getIdPedido() %></td>
                    <td><%= pedido.getMaterial() %></td>
                    <td><%= pedido.getLuzVisible() %></td>
                    <td><span class="status-pill status-<%= pedido.getEstado() %>"><%= pedido.getEstado() %></span></td>
                    <td><%= pedido.getFechaPedido() %></td>
                </tr>
                <% }
                } else { %>
                <tr>
                    <td colspan="5">No hay atenciones de polarizado para este cliente.</td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </section>

    <section class="table-card">
        <div class="table-title">
            <h3>Atenciones de logotipo</h3>
        </div>
        <div class="table-responsive-shell">
            <table class="admin-table">
                <thead>
                <tr>
                    <th>ID Registro</th>
                    <th>Servicio</th>
                    <th>Estado</th>
                    <th>Fecha</th>
                </tr>
                </thead>
                <tbody>
                <% if (pedidosLogotipo != null && !pedidosLogotipo.isEmpty()) {
                    for (PedidoLogotipo pedido : pedidosLogotipo) { %>
                <tr>
                    <td><%= pedido.getIdPedidoLogotipo() %></td>
                    <td><%= pedido.getServicioSeleccionado() %></td>
                    <td><span class="status-pill status-<%= pedido.getEstado() %>"><%= pedido.getEstado() %></span></td>
                    <td><%= pedido.getFechaPedido() %></td>
                </tr>
                <% }
                } else { %>
                <tr>
                    <td colspan="4">No hay atenciones de logotipo para este cliente.</td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </section>

    <section class="table-card">
        <div class="table-title">
            <h3>Atenciones de instalaciones</h3>
        </div>
        <div class="table-responsive-shell">
            <table class="admin-table">
                <thead>
                <tr>
                    <th>ID Registro</th>
                    <th>Servicio</th>
                    <th>Estado</th>
                    <th>Fecha</th>
                </tr>
                </thead>
                <tbody>
                <% if (pedidosInstalacion != null && !pedidosInstalacion.isEmpty()) {
                    for (PedidoInstalacion pedido : pedidosInstalacion) { %>
                <tr>
                    <td><%= pedido.getIdPedidoInstalacion() %></td>
                    <td><%= pedido.getServicioSeleccionado() %></td>
                    <td><span class="status-pill status-<%= pedido.getEstado() %>"><%= pedido.getEstado() %></span></td>
                    <td><%= pedido.getFechaPedido() %></td>
                </tr>
                <% }
                } else { %>
                <tr>
                    <td colspan="4">No hay atenciones de instalaciones para este cliente.</td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </section>
</main>
</body>
</html>
