<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Cliente" %>
<%@ page import="model.Pedido" %>
<%@ page import="model.PedidoLogotipo" %>
<%@ page import="model.PedidoInstalacion" %>
<!DOCTYPE html>
<html>
<head>
    <title>Actualizar Reportes</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body style="background-color: #111111;">

<!-- Navbar -->
<nav class="navbar navbar-dark border-bottom border-secondary" style="background-color: #1a1a1a;">
    <div class="container">
        <span class="navbar-brand fw-bold fs-4 text-white">✏️ Actualizar Reportes</span>
        <a href="servicio?tipo=reportes" class="btn btn-outline-light btn-sm">← Volver a Reportes</a>
    </div>
</nav>

<div class="container py-5">

    <!-- Clientes -->
    <div class="card border border-secondary shadow mb-5" style="background-color: #1a1a1a;">
        <div class="card-header fw-bold text-white border-bottom border-secondary" style="background-color: #2a2a2a;">
            👥 Clientes Registrados
        </div>
        <div class="card-body p-0">
            <table class="table table-dark table-striped table-hover mb-0">
                <thead>
                    <tr><th class="text-secondary">ID</th><th class="text-secondary">Nombre</th><th class="text-secondary">Guardar</th><th class="text-secondary">Eliminar</th></tr>
                </thead>
                <tbody>
                <%
                    List<Cliente> clientes = (List<Cliente>) request.getAttribute("clientes");
                    if (clientes != null) {
                        for (Cliente c : clientes) {
                %>
                <tr>
                    <form action="servicio" method="post">
                        <input type="hidden" name="tipo" value="actualizarCliente">
                        <input type="hidden" name="idCliente" value="<%= c.getIdCliente() %>">
                        <td class="text-white-50"><%= c.getIdCliente() %></td>
                        <td><input type="text" name="nombre" value="<%= c.getNombre() %>" class="form-control form-control-sm bg-dark text-white border-secondary"></td>
                        <td><button type="submit" class="btn btn-sm btn-outline-light">💾 Guardar</button></td>
                    </form>
                    <form action="servicio" method="post" onsubmit="return confirm('¿Seguro que deseas eliminar este cliente y todos sus pedidos?')">
                        <input type="hidden" name="tipo" value="eliminarCliente">
                        <input type="hidden" name="idCliente" value="<%= c.getIdCliente() %>">
                        <td><button type="submit" class="btn btn-sm btn-outline-danger">🗑️ Eliminar</button></td>
                    </form>
                </tr>
                <%
                        }
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Pedidos Polarizado -->
    <div class="card border border-secondary shadow mb-5" style="background-color: #1a1a1a;">
        <div class="card-header fw-bold text-white border-bottom border-secondary" style="background-color: #2a2a2a;">
            🚗 Pedidos - Polarizados
        </div>
        <div class="card-body p-0">
            <table class="table table-dark table-striped table-hover mb-0">
                <thead>
                    <tr><th class="text-secondary">ID</th><th class="text-secondary">Cliente</th><th class="text-secondary">Material</th><th class="text-secondary">Luz Visible</th><th class="text-secondary">Fecha</th><th class="text-secondary">Acción</th></tr>
                </thead>
                <tbody>
                <%
                    List<Pedido> pedidos = (List<Pedido>) request.getAttribute("pedidos");
                    if (pedidos != null) {
                        for (Pedido p : pedidos) {
                %>
                <tr>
                    <form action="servicio" method="post">
                        <input type="hidden" name="tipo" value="actualizarPolarizado">
                        <input type="hidden" name="idPedido" value="<%= p.getIdPedido() %>">
                        <td class="text-white-50"><%= p.getIdPedido() %></td>
                        <td class="text-white"><%= p.getNombreCliente() %></td>
                        <td>
                            <select name="material" class="form-select form-select-sm bg-dark text-white border-secondary">
                                <option value="nanoCarbono" <%= "nanoCarbono".equals(p.getMaterial()) ? "selected" : "" %>>nanoCarbono</option>
                                <option value="nanoCeramico" <%= "nanoCeramico".equals(p.getMaterial()) ? "selected" : "" %>>nanoCeramico</option>
                                <option value="Crystalline" <%= "Crystalline".equals(p.getMaterial()) ? "selected" : "" %>>Crystalline</option>
                            </select>
                        </td>
                        <td>
                            <select name="luzVisible" class="form-select form-select-sm bg-dark text-white border-secondary">
                                <option value="5%" <%= "5%".equals(p.getLuzVisible()) ? "selected" : "" %>>5%</option>
                                <option value="20%" <%= "20%".equals(p.getLuzVisible()) ? "selected" : "" %>>20%</option>
                                <option value="35%" <%= "35%".equals(p.getLuzVisible()) ? "selected" : "" %>>35%</option>
                                <option value="50%" <%= "50%".equals(p.getLuzVisible()) ? "selected" : "" %>>50%</option>
                            </select>
                        </td>
                        <td class="text-white-50"><%= p.getFechaPedido() %></td>
                        <td><button type="submit" class="btn btn-sm btn-outline-light">💾 Guardar</button></td>
                    </form>
                </tr>
                <%
                        }
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Pedidos Logotipo -->
    <div class="card border border-secondary shadow mb-5" style="background-color: #1a1a1a;">
        <div class="card-header fw-bold text-white border-bottom border-secondary" style="background-color: #2a2a2a;">
            🎨 Pedidos - Logotipos
        </div>
        <div class="card-body p-0">
            <table class="table table-dark table-striped table-hover mb-0">
                <thead>
                    <tr><th class="text-secondary">ID</th><th class="text-secondary">Cliente</th><th class="text-secondary">Servicio</th><th class="text-secondary">Fecha</th><th class="text-secondary">Acción</th></tr>
                </thead>
                <tbody>
                <%
                    List<PedidoLogotipo> pedidosLogotipo = (List<PedidoLogotipo>) request.getAttribute("pedidosLogotipo");
                    if (pedidosLogotipo != null) {
                        for (PedidoLogotipo pl : pedidosLogotipo) {
                %>
                <tr>
                    <form action="servicio" method="post">
                        <input type="hidden" name="tipo" value="actualizarLogotipo">
                        <input type="hidden" name="idPedidoLogotipo" value="<%= pl.getIdPedidoLogotipo() %>">
                        <td class="text-white-50"><%= pl.getIdPedidoLogotipo() %></td>
                        <td class="text-white"><%= pl.getNombreCliente() %></td>
                        <td>
                            <select name="servicioSeleccionado" class="form-select form-select-sm bg-dark text-white border-secondary">
                                <option value="Placa Provisional" <%= "Placa Provisional".equals(pl.getServicioSeleccionado()) ? "selected" : "" %>>Placa Provisional</option>
                                <option value="Tapasol" <%= "Tapasol".equals(pl.getServicioSeleccionado()) ? "selected" : "" %>>Tapasol</option>
                                <option value="Forrado de faros" <%= "Forrado de faros".equals(pl.getServicioSeleccionado()) ? "selected" : "" %>>Forrado de faros</option>
                                <option value="Forrado de techo" <%= "Forrado de techo".equals(pl.getServicioSeleccionado()) ? "selected" : "" %>>Forrado de techo</option>
                                <option value="Forrado de pisaderas" <%= "Forrado de pisaderas".equals(pl.getServicioSeleccionado()) ? "selected" : "" %>>Forrado de pisaderas</option>
                                <option value="Manijas" <%= "Manijas".equals(pl.getServicioSeleccionado()) ? "selected" : "" %>>Manijas</option>
                            </select>
                        </td>
                        <td class="text-white-50"><%= pl.getFechaPedido() %></td>
                        <td><button type="submit" class="btn btn-sm btn-outline-light">💾 Guardar</button></td>
                    </form>
                </tr>
                <%
                        }
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Pedidos Instalaciones -->
    <div class="card border border-secondary shadow mb-5" style="background-color: #1a1a1a;">
        <div class="card-header fw-bold text-white border-bottom border-secondary" style="background-color: #2a2a2a;">
            ⚡ Pedidos - Instalaciones
        </div>
        <div class="card-body p-0">
            <table class="table table-dark table-striped table-hover mb-0">
                <thead>
                    <tr><th class="text-secondary">ID</th><th class="text-secondary">Cliente</th><th class="text-secondary">Servicio</th><th class="text-secondary">Fecha</th><th class="text-secondary">Acción</th></tr>
                </thead>
                <tbody>
                <%
                    List<PedidoInstalacion> pedidosInstalacion = (List<PedidoInstalacion>) request.getAttribute("pedidosInstalacion");
                    if (pedidosInstalacion != null) {
                        for (PedidoInstalacion pi : pedidosInstalacion) {
                %>
                <tr>
                    <form action="servicio" method="post">
                        <input type="hidden" name="tipo" value="actualizarInstalacion">
                        <input type="hidden" name="idPedidoInstalacion" value="<%= pi.getIdPedidoInstalacion() %>">
                        <td class="text-white-50"><%= pi.getIdPedidoInstalacion() %></td>
                        <td class="text-white"><%= pi.getNombreCliente() %></td>
                        <td>
                            <select name="servicioSeleccionado" class="form-select form-select-sm bg-dark text-white border-secondary">
                                <option value="Tapizado de Techo" <%= "Tapizado de Techo".equals(pi.getServicioSeleccionado()) ? "selected" : "" %>>Tapizado de Techo</option>
                                <option value="Tapizado de Piso" <%= "Tapizado de Piso".equals(pi.getServicioSeleccionado()) ? "selected" : "" %>>Tapizado de Piso</option>
                                <option value="Confeccion de Fundas" <%= "Confeccion de Fundas".equals(pi.getServicioSeleccionado()) ? "selected" : "" %>>Confeccion de Fundas</option>
                                <option value="Instalacion de Radio" <%= "Instalacion de Radio".equals(pi.getServicioSeleccionado()) ? "selected" : "" %>>Instalacion de Radio</option>
                                <option value="Instalacion de GPS" <%= "Instalacion de GPS".equals(pi.getServicioSeleccionado()) ? "selected" : "" %>>Instalacion de GPS</option>
                            </select>
                        </td>
                        <td class="text-white-50"><%= pi.getFechaPedido() %></td>
                        <td><button type="submit" class="btn btn-sm btn-outline-light">💾 Guardar</button></td>
                    </form>
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

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>