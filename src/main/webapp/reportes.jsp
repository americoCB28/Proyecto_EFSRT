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
                </tr>
                </thead>
                <tbody>
                <% if (clientes != null) {
                    for (Cliente c : clientes) { %>
                <tr>
                    <td><%= c.getIdCliente() %></td>
                    <td><%= c.getNombre() %></td>
                </tr>
                <% }
                } %>
                </tbody>
            </table>
        </div>
    </section>

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
                    <td><%= p.getFechaPedido() %></td>
                </tr>
                <% }
                } %>
                </tbody>
            </table>
        </div>
    </section>

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
                    <td><%= pl.getFechaPedido() %></td>
                </tr>
                <% }
                } %>
                </tbody>
            </table>
        </div>
    </section>

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
                    <td><%= pi.getFechaPedido() %></td>
                </tr>
                <% }
                } %>
                </tbody>
            </table>
        </div>
    </section>
</main>
</body>
</html>
