<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Cliente" %>
<%@ page import="model.Pedido" %>
<%@ page import="model.PedidoLogotipo" %>
<%@ page import="model.PedidoInstalacion" %>
<%@ page import="util.CsrfUtil" %>
<!DOCTYPE html>
<html>
<head>
    <title>Actualizar Reportes</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/styles.css" rel="stylesheet">
</head>
<body class="app-body">
<%
    List<Cliente> clientes = (List<Cliente>) request.getAttribute("clientes");
    List<Pedido> pedidos = (List<Pedido>) request.getAttribute("pedidos");
    List<PedidoLogotipo> pedidosLogotipo = (List<PedidoLogotipo>) request.getAttribute("pedidosLogotipo");
    List<PedidoInstalacion> pedidosInstalacion = (List<PedidoInstalacion>) request.getAttribute("pedidosInstalacion");
    String csrfToken = CsrfUtil.obtenerToken(request);
%>

<nav class="app-topbar">
    <div class="app-topbar-inner">
        <div class="brand-stack">
            <span class="brand-title">Actualizar Reportes</span>
            <span class="brand-subtitle">Gestiona la informacion y vuelve automaticamente al panel principal</span>
        </div>
        <div class="topbar-actions">
            <a href="servicio?tipo=dashboard" class="app-button app-button-info">Dashboard</a>
            <a href="usuarios" class="app-button app-button-info">Usuarios</a>
            <a href="servicio?tipo=reportes" class="app-button app-button-info">Volver a Reportes</a>
            <a href="logout" class="app-button app-button-outline">Cerrar sesion</a>
        </div>
    </div>
</nav>

<main class="app-shell page-section">
    <section class="section-hero">
        <span class="eyebrow">Modo edicion</span>
        <h1 class="form-title mt-3">Actualizacion controlada</h1>
        <p class="form-subtitle">Guarda un cambio por fila y el flujo te devolvera al panel de reportes con un mensaje visible.</p>
    </section>

    <section class="table-card">
        <div class="table-title">
            <h3>Clientes</h3>
        </div>
        <div class="table-responsive-shell">
            <table class="admin-table">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Nombre</th>
                    <th>Acciones</th>
                </tr>
                </thead>
                <tbody>
                <% if (clientes != null) {
                    for (Cliente c : clientes) { %>
                <tr>
                    <td><%= c.getIdCliente() %></td>
                    <td>
                        <form action="servicio" method="post">
                            <input type="hidden" name="tipo" value="actualizarCliente">
                            <input type="hidden" name="idCliente" value="<%= c.getIdCliente() %>">
                            <input type="hidden" name="<%= CsrfUtil.CSRF_REQUEST_PARAM %>" value="<%= csrfToken %>">
                            <input type="text" name="nombre" value="<%= c.getNombre() %>" class="form-control app-field">
                    </td>
                    <td>
                            <div class="stacked-forms">
                                <button type="submit" class="app-button app-button-secondary">Guardar</button>
                        </form>
                        <form action="servicio" method="post" onsubmit="return confirm('Seguro que deseas eliminar este cliente y todos sus pedidos?')">
                            <input type="hidden" name="tipo" value="eliminarCliente">
                            <input type="hidden" name="idCliente" value="<%= c.getIdCliente() %>">
                            <input type="hidden" name="<%= CsrfUtil.CSRF_REQUEST_PARAM %>" value="<%= csrfToken %>">
                            <button type="submit" class="app-button app-button-danger-outline">Eliminar</button>
                        </form>
                            </div>
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
            <h3>Pedidos de polarizado</h3>
        </div>
        <div class="table-responsive-shell">
            <table class="admin-table">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Cliente</th>
                    <th>Material</th>
                    <th>Luz Visible</th>
                    <th>Estado</th>
                    <th>Fecha</th>
                    <th>Accion</th>
                </tr>
                </thead>
                <tbody>
                <% if (pedidos != null) {
                    for (Pedido p : pedidos) { %>
                <tr>
                    <form action="servicio" method="post">
                        <input type="hidden" name="tipo" value="actualizarPolarizado">
                        <input type="hidden" name="idPedido" value="<%= p.getIdPedido() %>">
                        <input type="hidden" name="<%= CsrfUtil.CSRF_REQUEST_PARAM %>" value="<%= csrfToken %>">
                        <td><%= p.getIdPedido() %></td>
                        <td><%= p.getNombreCliente() %></td>
                        <td>
                            <select name="material" class="form-select app-field">
                                <option value="nanoCarbono" <%= "nanoCarbono".equals(p.getMaterial()) ? "selected" : "" %>>nanoCarbono</option>
                                <option value="nanoCeramico" <%= "nanoCeramico".equals(p.getMaterial()) ? "selected" : "" %>>nanoCeramico</option>
                                <option value="Crystalline" <%= "Crystalline".equals(p.getMaterial()) ? "selected" : "" %>>Crystalline</option>
                            </select>
                        </td>
                        <td>
                            <select name="luzVisible" class="form-select app-field">
                                <option value="5%" <%= "5%".equals(p.getLuzVisible()) ? "selected" : "" %>>5%</option>
                                <option value="20%" <%= "20%".equals(p.getLuzVisible()) ? "selected" : "" %>>20%</option>
                                <option value="35%" <%= "35%".equals(p.getLuzVisible()) ? "selected" : "" %>>35%</option>
                                <option value="50%" <%= "50%".equals(p.getLuzVisible()) ? "selected" : "" %>>50%</option>
                            </select>
                        </td>
                        <td>
                            <select name="estado" class="form-select app-field">
                                <option value="pendiente" <%= "pendiente".equals(p.getEstado()) ? "selected" : "" %>>pendiente</option>
                                <option value="en_proceso" <%= "en_proceso".equals(p.getEstado()) ? "selected" : "" %>>en_proceso</option>
                                <option value="terminado" <%= "terminado".equals(p.getEstado()) ? "selected" : "" %>>terminado</option>
                                <option value="cancelado" <%= "cancelado".equals(p.getEstado()) ? "selected" : "" %>>cancelado</option>
                            </select>
                        </td>
                        <td><%= p.getFechaPedido() %></td>
                        <td><button type="submit" class="app-button app-button-secondary">Guardar</button></td>
                    </form>
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
                    <th>ID</th>
                    <th>Cliente</th>
                    <th>Servicio</th>
                    <th>Estado</th>
                    <th>Fecha</th>
                    <th>Accion</th>
                </tr>
                </thead>
                <tbody>
                <% if (pedidosLogotipo != null) {
                    for (PedidoLogotipo pl : pedidosLogotipo) { %>
                <tr>
                    <form action="servicio" method="post">
                        <input type="hidden" name="tipo" value="actualizarLogotipo">
                        <input type="hidden" name="idPedidoLogotipo" value="<%= pl.getIdPedidoLogotipo() %>">
                        <input type="hidden" name="<%= CsrfUtil.CSRF_REQUEST_PARAM %>" value="<%= csrfToken %>">
                        <td><%= pl.getIdPedidoLogotipo() %></td>
                        <td><%= pl.getNombreCliente() %></td>
                        <td>
                            <select name="servicioSeleccionado" class="form-select app-field">
                                <option value="Placa Provisional" <%= "Placa Provisional".equals(pl.getServicioSeleccionado()) ? "selected" : "" %>>Placa Provisional</option>
                                <option value="Tapasol" <%= "Tapasol".equals(pl.getServicioSeleccionado()) ? "selected" : "" %>>Tapasol</option>
                                <option value="Forrado de faros" <%= "Forrado de faros".equals(pl.getServicioSeleccionado()) ? "selected" : "" %>>Forrado de faros</option>
                                <option value="Forrado de techo" <%= "Forrado de techo".equals(pl.getServicioSeleccionado()) ? "selected" : "" %>>Forrado de techo</option>
                                <option value="Forrado de pisaderas" <%= "Forrado de pisaderas".equals(pl.getServicioSeleccionado()) ? "selected" : "" %>>Forrado de pisaderas</option>
                                <option value="Manijas" <%= "Manijas".equals(pl.getServicioSeleccionado()) ? "selected" : "" %>>Manijas</option>
                            </select>
                        </td>
                        <td>
                            <select name="estado" class="form-select app-field">
                                <option value="pendiente" <%= "pendiente".equals(pl.getEstado()) ? "selected" : "" %>>pendiente</option>
                                <option value="en_proceso" <%= "en_proceso".equals(pl.getEstado()) ? "selected" : "" %>>en_proceso</option>
                                <option value="terminado" <%= "terminado".equals(pl.getEstado()) ? "selected" : "" %>>terminado</option>
                                <option value="cancelado" <%= "cancelado".equals(pl.getEstado()) ? "selected" : "" %>>cancelado</option>
                            </select>
                        </td>
                        <td><%= pl.getFechaPedido() %></td>
                        <td><button type="submit" class="app-button app-button-secondary">Guardar</button></td>
                    </form>
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
                    <th>ID</th>
                    <th>Cliente</th>
                    <th>Servicio</th>
                    <th>Estado</th>
                    <th>Fecha</th>
                    <th>Accion</th>
                </tr>
                </thead>
                <tbody>
                <% if (pedidosInstalacion != null) {
                    for (PedidoInstalacion pi : pedidosInstalacion) { %>
                <tr>
                    <form action="servicio" method="post">
                        <input type="hidden" name="tipo" value="actualizarInstalacion">
                        <input type="hidden" name="idPedidoInstalacion" value="<%= pi.getIdPedidoInstalacion() %>">
                        <input type="hidden" name="<%= CsrfUtil.CSRF_REQUEST_PARAM %>" value="<%= csrfToken %>">
                        <td><%= pi.getIdPedidoInstalacion() %></td>
                        <td><%= pi.getNombreCliente() %></td>
                        <td>
                            <select name="servicioSeleccionado" class="form-select app-field">
                                <option value="Tapizado de Techo" <%= "Tapizado de Techo".equals(pi.getServicioSeleccionado()) ? "selected" : "" %>>Tapizado de Techo</option>
                                <option value="Tapizado de Piso" <%= "Tapizado de Piso".equals(pi.getServicioSeleccionado()) ? "selected" : "" %>>Tapizado de Piso</option>
                                <option value="Confeccion de Fundas" <%= "Confeccion de Fundas".equals(pi.getServicioSeleccionado()) ? "selected" : "" %>>Confeccion de Fundas</option>
                                <option value="Instalacion de Radio" <%= "Instalacion de Radio".equals(pi.getServicioSeleccionado()) ? "selected" : "" %>>Instalacion de Radio</option>
                                <option value="Instalacion de GPS" <%= "Instalacion de GPS".equals(pi.getServicioSeleccionado()) ? "selected" : "" %>>Instalacion de GPS</option>
                            </select>
                        </td>
                        <td>
                            <select name="estado" class="form-select app-field">
                                <option value="pendiente" <%= "pendiente".equals(pi.getEstado()) ? "selected" : "" %>>pendiente</option>
                                <option value="en_proceso" <%= "en_proceso".equals(pi.getEstado()) ? "selected" : "" %>>en_proceso</option>
                                <option value="terminado" <%= "terminado".equals(pi.getEstado()) ? "selected" : "" %>>terminado</option>
                                <option value="cancelado" <%= "cancelado".equals(pi.getEstado()) ? "selected" : "" %>>cancelado</option>
                            </select>
                        </td>
                        <td><%= pi.getFechaPedido() %></td>
                        <td><button type="submit" class="app-button app-button-secondary">Guardar</button></td>
                    </form>
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
