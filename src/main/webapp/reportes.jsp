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
</head>
<body style="background-color: #111111;">
<%
    String flashSuccess = (String) request.getAttribute("flashSuccess");
    String flashWarning = (String) request.getAttribute("flashWarning");
    String flashError = (String) request.getAttribute("flashError");
%>

<nav class="navbar navbar-dark border-bottom border-secondary" style="background-color: #1a1a1a;">
    <div class="container">
        <span class="navbar-brand fw-bold fs-4 text-white">Panel de Reportes</span>
        <div class="d-flex gap-2">
            <a href="inicio" class="btn btn-outline-light btn-sm">Volver al inicio</a>
            <a href="logout" class="btn btn-outline-warning btn-sm">Cerrar sesion</a>
        </div>
    </div>
</nav>

<div class="container py-5">

    <% if (flashSuccess != null && !flashSuccess.isBlank()) { %>
    <div class="alert alert-success border-0 shadow-sm" role="alert"><%= flashSuccess %></div>
    <% } %>

    <% if (flashWarning != null && !flashWarning.isBlank()) { %>
    <div class="alert alert-warning border-0 shadow-sm" role="alert"><%= flashWarning %></div>
    <% } %>

    <% if (flashError != null && !flashError.isBlank()) { %>
    <div class="alert alert-danger border-0 shadow-sm" role="alert"><%= flashError %></div>
    <% } %>

    <div class="row mb-5">
        <div class="col-md-3">
            <div class="card border border-secondary shadow" style="background-color: #1a1a1a;">
                <div class="card-header fw-bold text-white border-bottom border-secondary" style="background-color: #2a2a2a;">
                    Clientes Registrados
                </div>
                <div class="card-body p-0">
                    <table class="table table-dark table-striped table-hover mb-0">
                        <thead>
                        <tr class="border-secondary">
                            <th class="text-secondary">ID</th>
                            <th class="text-secondary">Nombre</th>
                        </tr>
                        </thead>
                        <tbody>
                        <%
                            List<Cliente> clientes = (List<Cliente>) request.getAttribute("clientes");
                            if (clientes != null) {
                                for (Cliente c : clientes) {
                        %>
                        <tr>
                            <td class="text-white-50"><%= c.getIdCliente() %></td>
                            <td class="text-white"><%= c.getNombre() %></td>
                        </tr>
                        <%
                                }
                            }
                        %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="col-md-9">
            <div class="card border border-secondary shadow mb-4" style="background-color: #1a1a1a;">
                <div class="card-header fw-bold text-white border-bottom border-secondary" style="background-color: #2a2a2a;">
                    Pedidos Registrados - Polarizados
                </div>
                <div class="card-body p-0">
                    <table class="table table-dark table-striped table-hover mb-0">
                        <thead>
                        <tr>
                            <th class="text-secondary">ID Pedido</th>
                            <th class="text-secondary">Cliente</th>
                            <th class="text-secondary">Material</th>
                            <th class="text-secondary">Luz Visible</th>
                            <th class="text-secondary">Fecha</th>
                        </tr>
                        </thead>
                        <tbody>
                        <%
                            List<Pedido> pedidos = (List<Pedido>) request.getAttribute("pedidos");
                            if (pedidos != null) {
                                for (Pedido p : pedidos) {
                        %>
                        <tr>
                            <td class="text-white-50"><%= p.getIdPedido() %></td>
                            <td class="text-white"><%= p.getNombreCliente() %></td>
                            <td class="text-white"><%= p.getMaterial() %></td>
                            <td class="text-white"><%= p.getLuzVisible() %></td>
                            <td class="text-white-50"><%= p.getFechaPedido() %></td>
                        </tr>
                        <%
                                }
                            }
                        %>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="card border border-secondary shadow mb-4" style="background-color: #1a1a1a;">
                <div class="card-header fw-bold text-white border-bottom border-secondary" style="background-color: #2a2a2a;">
                    Pedidos Registrados - Logotipos
                </div>
                <div class="card-body p-0">
                    <table class="table table-dark table-striped table-hover mb-0">
                        <thead>
                        <tr>
                            <th class="text-secondary">ID Pedido</th>
                            <th class="text-secondary">Cliente</th>
                            <th class="text-secondary">Servicio</th>
                            <th class="text-secondary">Fecha</th>
                        </tr>
                        </thead>
                        <tbody>
                        <%
                            List<PedidoLogotipo> pedidosLogotipo = (List<PedidoLogotipo>) request.getAttribute("pedidosLogotipo");
                            if (pedidosLogotipo != null) {
                                for (PedidoLogotipo pl : pedidosLogotipo) {
                        %>
                        <tr>
                            <td class="text-white-50"><%= pl.getIdPedidoLogotipo() %></td>
                            <td class="text-white"><%= pl.getNombreCliente() %></td>
                            <td class="text-white"><%= pl.getServicioSeleccionado() %></td>
                            <td class="text-white-50"><%= pl.getFechaPedido() %></td>
                        </tr>
                        <%
                                }
                            }
                        %>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="card border border-secondary shadow mb-4" style="background-color: #1a1a1a;">
                <div class="card-header fw-bold text-white border-bottom border-secondary" style="background-color: #2a2a2a;">
                    Pedidos Registrados - Instalaciones
                </div>
                <div class="card-body p-0">
                    <table class="table table-dark table-striped table-hover mb-0">
                        <thead>
                        <tr>
                            <th class="text-secondary">ID Pedido</th>
                            <th class="text-secondary">Cliente</th>
                            <th class="text-secondary">Servicio</th>
                            <th class="text-secondary">Fecha</th>
                        </tr>
                        </thead>
                        <tbody>
                        <%
                            List<PedidoInstalacion> pedidosInstalacion = (List<PedidoInstalacion>) request.getAttribute("pedidosInstalacion");
                            if (pedidosInstalacion != null) {
                                for (PedidoInstalacion pi : pedidosInstalacion) {
                        %>
                        <tr>
                            <td class="text-white-50"><%= pi.getIdPedidoInstalacion() %></td>
                            <td class="text-white"><%= pi.getNombreCliente() %></td>
                            <td class="text-white"><%= pi.getServicioSeleccionado() %></td>
                            <td class="text-white-50"><%= pi.getFechaPedido() %></td>
                        </tr>
                        <%
                                }
                            }
                        %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <div class="text-center mb-3">
        <a href="servicio?tipo=actualizarReporte" class="btn btn-outline-light px-4 me-2">Modificar</a>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
