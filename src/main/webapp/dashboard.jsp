<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
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
    List<ResumenPedidoReciente> pedidosRecientes = (List<ResumenPedidoReciente>) request.getAttribute("pedidosRecientes");
%>

<nav class="app-topbar">
    <div class="app-topbar-inner">
        <div class="brand-stack">
            <span class="brand-title">Dashboard Administrativo</span>
            <span class="brand-subtitle">Resumen rapido de actividad, volumen y ultimos movimientos</span>
        </div>
        <div class="topbar-actions">
            <a href="inicio" class="app-button app-button-secondary">Inicio</a>
            <a href="servicio?tipo=reportes" class="app-button app-button-info">Reportes</a>
            <a href="servicio?tipo=actualizarReporte" class="app-button app-button-outline">Actualizar</a>
            <a href="logout" class="app-button app-button-outline">Cerrar sesion</a>
        </div>
    </div>
</nav>

<main class="app-shell page-section">
    <section class="section-hero">
        <span class="eyebrow">Vista ejecutiva</span>
        <h1 class="form-title mt-3">Resumen general del sistema</h1>
        <p class="form-subtitle">Consulta metricas clave y revisa los ultimos pedidos registrados sin tocar el flujo operativo actual.</p>
    </section>

    <section class="stats-grid">
        <article class="stat-card">
            <div class="stat-label">Total clientes</div>
            <div class="stat-value"><%= totalClientes %></div>
            <div class="stat-help">Clientes registrados en la base actual.</div>
        </article>
        <article class="stat-card">
            <div class="stat-label">Pedidos polarizado</div>
            <div class="stat-value"><%= totalPolarizado %></div>
            <div class="stat-help">Solicitudes del modulo de polarizados.</div>
        </article>
        <article class="stat-card">
            <div class="stat-label">Pedidos logotipo</div>
            <div class="stat-value"><%= totalLogotipo %></div>
            <div class="stat-help">Solicitudes del modulo de logotipos.</div>
        </article>
        <article class="stat-card">
            <div class="stat-label">Pedidos instalaciones</div>
            <div class="stat-value"><%= totalInstalacion %></div>
            <div class="stat-help">Solicitudes del modulo de instalaciones.</div>
        </article>
        <article class="stat-card stat-card-highlight">
            <div class="stat-label">Total general de pedidos</div>
            <div class="stat-value"><%= totalGeneral %></div>
            <div class="stat-help">Suma de pedidos registrados en los tres servicios.</div>
        </article>
    </section>

    <section class="table-card">
        <div class="table-title">
            <h3>Ultimos pedidos registrados</h3>
            <a href="servicio?tipo=reportes" class="app-button app-button-outline">Ir a reportes</a>
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
