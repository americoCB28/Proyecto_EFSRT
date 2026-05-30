package controller;

import dao.ClienteDAO;
import dao.DashboardDAO;
import dao.PedidoDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Cliente;
import model.Pedido;
import model.PedidoInstalacion;
import model.PedidoLogotipo;
import model.ResumenPedidoReciente;
import util.InputValidator;
import util.SessionUtil;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.Collections;
import java.util.List;

@WebServlet("/servicio")
public class PedidoController extends HttpServlet {

    private final ClienteDAO clienteDAO = new ClienteDAO();
    private final PedidoDAO pedidoDAO = new PedidoDAO();
    private final DashboardDAO dashboardDAO = new DashboardDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String tipo = request.getParameter("tipo");
        request.setAttribute("tipo", tipo);

        if ("logotipos".equals(tipo)) {
            request.getRequestDispatcher("/formLogotipo.jsp").forward(request, response);
            return;
        }

        if ("polarizado".equals(tipo)) {
            request.getRequestDispatcher("/formPolarizado.jsp").forward(request, response);
            return;
        }

        if ("instalaciones".equals(tipo)) {
            request.getRequestDispatcher("/formInstalaciones.jsp").forward(request, response);
            return;
        }

        if ("reportes".equals(tipo)) {
            cargarDatosReporte(request);
            request.getRequestDispatcher("/reportes.jsp").forward(request, response);
            return;
        }

        if ("actualizarReporte".equals(tipo)) {
            cargarDatosReporte(request);
            request.getRequestDispatcher("/actualizarReporte.jsp").forward(request, response);
            return;
        }

        if ("dashboard".equals(tipo)) {
            cargarDashboard(request);
            request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
            return;
        }

        if ("exportarCsv".equals(tipo)) {
            exportarCsv(request, response);
            return;
        }

        response.sendRedirect("inicio");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String tipo = request.getParameter("tipo");

        if ("logotipos".equals(tipo)) {
            registrarPedidoLogotipo(request, response);
            return;
        }

        if ("instalaciones".equals(tipo)) {
            registrarPedidoInstalacion(request, response);
            return;
        }

        if ("polarizado".equals(tipo)) {
            registrarPedidoPolarizado(request, response);
            return;
        }

        if ("actualizarCliente".equals(tipo)) {
            actualizarCliente(request, response);
            return;
        }

        if ("actualizarPolarizado".equals(tipo)) {
            actualizarPolarizado(request, response);
            return;
        }

        if ("actualizarLogotipo".equals(tipo)) {
            actualizarLogotipo(request, response);
            return;
        }

        if ("actualizarInstalacion".equals(tipo)) {
            actualizarInstalacion(request, response);
            return;
        }

        if ("eliminarCliente".equals(tipo)) {
            eliminarCliente(request, response);
            return;
        }

        response.sendRedirect("inicio");
    }

    private void registrarPedidoLogotipo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String nombre = InputValidator.normalizarNombre(request.getParameter("nombre"));
        String servicioSeleccionado = request.getParameter("opcionLogotipo");

        if (!InputValidator.esNombreValido(nombre)
                || !InputValidator.esServicioLogotipoValido(servicioSeleccionado)) {
            response.sendRedirect("servicio?tipo=logotipos");
            return;
        }

        int idCliente = crearCliente(nombre);
        if (idCliente <= 0) {
            response.sendRedirect("servicio?tipo=logotipos");
            return;
        }

        PedidoLogotipo pedido = new PedidoLogotipo();
        pedido.setIdCliente(idCliente);
        pedido.setServicioSeleccionado(servicioSeleccionado);
        pedido.setEstado("pendiente");
        pedidoDAO.crearPedidoLogotipo(pedido);

        request.setAttribute("tituloConfirmacion", "Pedido registrado correctamente");
        request.setAttribute("mensajeConfirmacion", "Tu solicitud de logotipo fue registrada. Puedes volver al inicio o registrar otro pedido.");
        request.setAttribute("areaConfirmacion", "Por favor aproximarse al area de Diseno.");
        request.setAttribute("rutaNuevoPedido", "servicio?tipo=logotipos");
        request.getRequestDispatcher("/confirmacionLogotipo.jsp").forward(request, response);
    }

    private void registrarPedidoInstalacion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String nombre = InputValidator.normalizarNombre(request.getParameter("nombre"));
        String servicioSeleccionado = request.getParameter("opcionInstalacion");

        if (!InputValidator.esNombreValido(nombre)
                || !InputValidator.esServicioInstalacionValido(servicioSeleccionado)) {
            response.sendRedirect("servicio?tipo=instalaciones");
            return;
        }

        int idCliente = crearCliente(nombre);
        if (idCliente <= 0) {
            response.sendRedirect("servicio?tipo=instalaciones");
            return;
        }

        PedidoInstalacion pedido = new PedidoInstalacion();
        pedido.setIdCliente(idCliente);
        pedido.setServicioSeleccionado(servicioSeleccionado);
        pedido.setEstado("pendiente");
        pedidoDAO.crearPedidoInstalacion(pedido);

        request.setAttribute("tituloConfirmacion", "Pedido registrado correctamente");
        request.setAttribute("mensajeConfirmacion", "Tu solicitud de instalacion fue registrada. Puedes volver al inicio o registrar otro pedido.");
        request.setAttribute("areaConfirmacion", "Por favor aproximarse al area de Instalaciones.");
        request.setAttribute("rutaNuevoPedido", "servicio?tipo=instalaciones");
        request.getRequestDispatcher("/confirmacionInstalaciones.jsp").forward(request, response);
    }

    private void registrarPedidoPolarizado(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String nombre = InputValidator.normalizarNombre(request.getParameter("nombre"));
        String material = request.getParameter("material");
        String luzVisible = request.getParameter("luzVisible");

        if (!InputValidator.esNombreValido(nombre)
                || !InputValidator.esMaterialValido(material)
                || !InputValidator.esLuzVisibleValida(luzVisible)) {
            response.sendRedirect("servicio?tipo=polarizado");
            return;
        }

        int idCliente = crearCliente(nombre);
        if (idCliente <= 0) {
            response.sendRedirect("servicio?tipo=polarizado");
            return;
        }

        Pedido pedido = new Pedido();
        pedido.setMaterial(material);
        pedido.setLuzVisible(luzVisible);
        pedido.setEstado("pendiente");
        pedido.setIdCliente(idCliente);
        pedidoDAO.crearPedidoPolarizado(pedido);

        request.setAttribute("tituloConfirmacion", "Pedido registrado correctamente");
        request.setAttribute("mensajeConfirmacion", "Tu solicitud de polarizado fue registrada. Puedes volver al inicio o registrar otro pedido.");
        request.setAttribute("areaConfirmacion", "Por favor aproximarse al area de Polarizado.");
        request.setAttribute("rutaNuevoPedido", "servicio?tipo=polarizado");
        request.getRequestDispatcher("/confirmacionPolarizado.jsp").forward(request, response);
    }

    private void actualizarCliente(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idCliente = request.getParameter("idCliente");
        String nombre = InputValidator.normalizarNombre(request.getParameter("nombre"));

        if (InputValidator.esIdPositivo(idCliente) && InputValidator.esNombreValido(nombre)) {
            clienteDAO.actualizarNombreCliente(Integer.parseInt(idCliente), nombre);
            SessionUtil.guardarFlashSuccess(request, "Cliente actualizado correctamente.");
        } else {
            SessionUtil.guardarFlashWarning(request, "No se pudo actualizar el cliente. Verifica los datos enviados.");
        }

        response.sendRedirect("servicio?tipo=reportes");
    }

    private void actualizarPolarizado(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idPedido = request.getParameter("idPedido");
        String material = request.getParameter("material");
        String luzVisible = request.getParameter("luzVisible");
        String estado = request.getParameter("estado");

        if (InputValidator.esIdPositivo(idPedido)
                && InputValidator.esMaterialValido(material)
                && InputValidator.esLuzVisibleValida(luzVisible)
                && InputValidator.esEstadoPedidoValido(estado)) {
            pedidoDAO.actualizarPedidoPolarizado(Integer.parseInt(idPedido), material, luzVisible, estado);
            SessionUtil.guardarFlashSuccess(request, "Pedido de polarizado actualizado correctamente.");
        } else {
            SessionUtil.guardarFlashWarning(request, "No se pudo actualizar el pedido de polarizado. Verifica los datos enviados.");
        }

        response.sendRedirect("servicio?tipo=reportes");
    }

    private void actualizarLogotipo(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idPedidoLogotipo = request.getParameter("idPedidoLogotipo");
        String servicioSeleccionado = request.getParameter("servicioSeleccionado");
        String estado = request.getParameter("estado");

        if (InputValidator.esIdPositivo(idPedidoLogotipo)
                && InputValidator.esServicioLogotipoValido(servicioSeleccionado)
                && InputValidator.esEstadoPedidoValido(estado)) {
            pedidoDAO.actualizarPedidoLogotipo(Integer.parseInt(idPedidoLogotipo), servicioSeleccionado, estado);
            SessionUtil.guardarFlashSuccess(request, "Pedido de logotipo actualizado correctamente.");
        } else {
            SessionUtil.guardarFlashWarning(request, "No se pudo actualizar el pedido de logotipo. Verifica los datos enviados.");
        }

        response.sendRedirect("servicio?tipo=reportes");
    }

    private void actualizarInstalacion(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idPedidoInstalacion = request.getParameter("idPedidoInstalacion");
        String servicioSeleccionado = request.getParameter("servicioSeleccionado");
        String estado = request.getParameter("estado");

        if (InputValidator.esIdPositivo(idPedidoInstalacion)
                && InputValidator.esServicioInstalacionValido(servicioSeleccionado)
                && InputValidator.esEstadoPedidoValido(estado)) {
            pedidoDAO.actualizarPedidoInstalacion(Integer.parseInt(idPedidoInstalacion), servicioSeleccionado, estado);
            SessionUtil.guardarFlashSuccess(request, "Pedido de instalacion actualizado correctamente.");
        } else {
            SessionUtil.guardarFlashWarning(request, "No se pudo actualizar el pedido de instalacion. Verifica los datos enviados.");
        }

        response.sendRedirect("servicio?tipo=reportes");
    }

    private void eliminarCliente(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idCliente = request.getParameter("idCliente");
        if (InputValidator.esIdPositivo(idCliente)) {
            clienteDAO.eliminarClientePorId(Integer.parseInt(idCliente));
            SessionUtil.guardarFlashSuccess(request, "Cliente y pedidos relacionados eliminados correctamente.");
        } else {
            SessionUtil.guardarFlashWarning(request, "No se pudo eliminar el cliente solicitado.");
        }
        response.sendRedirect("servicio?tipo=reportes");
    }

    private int crearCliente(String nombre) {
        Cliente cliente = new Cliente();
        cliente.setNombre(nombre);
        return clienteDAO.crearCliente(cliente);
    }

    private void cargarDatosReporte(HttpServletRequest request) {
        String filtroCliente = InputValidator.normalizarNombre(request.getParameter("cliente"));
        String filtroServicio = normalizarFiltroServicio(request.getParameter("servicioFiltro"));
        String filtroEstado = InputValidator.normalizarEstadoFiltro(request.getParameter("estadoFiltro"));

        request.setAttribute("clienteFiltro", filtroCliente == null ? "" : filtroCliente);
        request.setAttribute("servicioFiltro", filtroServicio);
        request.setAttribute("estadoFiltro", filtroEstado);
        request.setAttribute("clientes", clienteDAO.listarClientesPorNombre(filtroCliente));
        request.setAttribute("pedidos", mostrarPolarizado(filtroServicio)
                ? pedidoDAO.listarPedidosPolarizadoFiltrados(filtroCliente, filtroEstadoParaConsulta(filtroEstado))
                : Collections.emptyList());
        request.setAttribute("pedidosLogotipo", mostrarLogotipo(filtroServicio)
                ? pedidoDAO.listarPedidosLogotipoFiltrados(filtroCliente, filtroEstadoParaConsulta(filtroEstado))
                : Collections.emptyList());
        request.setAttribute("pedidosInstalacion", mostrarInstalacion(filtroServicio)
                ? pedidoDAO.listarPedidosInstalacionFiltrados(filtroCliente, filtroEstadoParaConsulta(filtroEstado))
                : Collections.emptyList());
        request.setAttribute("flashSuccess", SessionUtil.consumirFlashSuccess(request));
        request.setAttribute("flashWarning", SessionUtil.consumirFlashWarning(request));
        request.setAttribute("flashError", SessionUtil.consumirFlashError(request));
    }

    private void cargarDashboard(HttpServletRequest request) {
        int totalClientes = dashboardDAO.contarClientes();
        int totalPolarizado = dashboardDAO.contarPedidosPolarizado();
        int totalLogotipo = dashboardDAO.contarPedidosLogotipo();
        int totalInstalacion = dashboardDAO.contarPedidosInstalacion();
        int totalGeneral = totalPolarizado + totalLogotipo + totalInstalacion;
        List<ResumenPedidoReciente> pedidosRecientes = dashboardDAO.listarUltimosPedidos(8);

        request.setAttribute("totalClientes", totalClientes);
        request.setAttribute("totalPolarizado", totalPolarizado);
        request.setAttribute("totalLogotipo", totalLogotipo);
        request.setAttribute("totalInstalacion", totalInstalacion);
        request.setAttribute("totalGeneral", totalGeneral);
        request.setAttribute("pedidosRecientes", pedidosRecientes);
        request.setAttribute("flashSuccess", SessionUtil.consumirFlashSuccess(request));
        request.setAttribute("flashWarning", SessionUtil.consumirFlashWarning(request));
        request.setAttribute("flashError", SessionUtil.consumirFlashError(request));
    }

    private String normalizarFiltroServicio(String valor) {
        if (valor == null || valor.isBlank()) {
            return "todos";
        }
        return switch (valor) {
            case "todos", "polarizado", "logotipo", "instalacion" -> valor;
            default -> "todos";
        };
    }

    private boolean mostrarPolarizado(String filtroServicio) {
        return "todos".equals(filtroServicio) || "polarizado".equals(filtroServicio);
    }

    private boolean mostrarLogotipo(String filtroServicio) {
        return "todos".equals(filtroServicio) || "logotipo".equals(filtroServicio);
    }

    private boolean mostrarInstalacion(String filtroServicio) {
        return "todos".equals(filtroServicio) || "instalacion".equals(filtroServicio);
    }

    private String filtroEstadoParaConsulta(String filtroEstado) {
        return "todos".equals(filtroEstado) ? null : filtroEstado;
    }

    private void exportarCsv(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String filtroCliente = InputValidator.normalizarNombre(request.getParameter("cliente"));
        String filtroServicio = normalizarFiltroServicio(request.getParameter("servicioFiltro"));
        String filtroEstado = InputValidator.normalizarEstadoFiltro(request.getParameter("estadoFiltro"));
        String estadoConsulta = filtroEstadoParaConsulta(filtroEstado);

        try {
            StringBuilder csv = new StringBuilder();
            csv.append('\uFEFF');
            csv.append("cliente,servicio,fecha,estado,detalle_1,detalle_2\n");

            if (mostrarPolarizado(filtroServicio)) {
                for (Pedido pedido : pedidoDAO.listarPedidosPolarizadoFiltrados(filtroCliente, estadoConsulta)) {
                    agregarFilaCsv(csv,
                            pedido.getNombreCliente(),
                            "Polarizado",
                            pedido.getFechaPedido(),
                            pedido.getEstado(),
                            pedido.getMaterial(),
                            pedido.getLuzVisible());
                }
            }

            if (mostrarLogotipo(filtroServicio)) {
                for (PedidoLogotipo pedido : pedidoDAO.listarPedidosLogotipoFiltrados(filtroCliente, estadoConsulta)) {
                    agregarFilaCsv(csv,
                            pedido.getNombreCliente(),
                            "Logotipo",
                            pedido.getFechaPedido(),
                            pedido.getEstado(),
                            pedido.getServicioSeleccionado(),
                            "");
                }
            }

            if (mostrarInstalacion(filtroServicio)) {
                for (PedidoInstalacion pedido : pedidoDAO.listarPedidosInstalacionFiltrados(filtroCliente, estadoConsulta)) {
                    agregarFilaCsv(csv,
                            pedido.getNombreCliente(),
                            "Instalacion",
                            pedido.getFechaPedido(),
                            pedido.getEstado(),
                            pedido.getServicioSeleccionado(),
                            "");
                }
            }

            response.setCharacterEncoding(StandardCharsets.UTF_8.name());
            response.setContentType("text/csv; charset=UTF-8");
            response.setHeader("Content-Disposition", "attachment; filename=\"reporte_pedidos.csv\"");
            response.getWriter().write(csv.toString());
        } catch (Exception e) {
            SessionUtil.guardarFlashError(request, "No se pudo generar el archivo CSV. Intenta nuevamente.");
            response.sendRedirect("servicio?tipo=reportes");
        }
    }

    private void agregarFilaCsv(StringBuilder csv, String cliente, String servicio, String fecha,
                                String estado, String detalle1, String detalle2) {
        csv.append(escaparCsv(cliente)).append(',')
                .append(escaparCsv(servicio)).append(',')
                .append(escaparCsv(fecha)).append(',')
                .append(escaparCsv(estado)).append(',')
                .append(escaparCsv(detalle1)).append(',')
                .append(escaparCsv(detalle2)).append('\n');
    }

    private String escaparCsv(String valor) {
        if (valor == null) {
            return "\"\"";
        }
        return "\"" + valor.replace("\"", "\"\"") + "\"";
    }
}
