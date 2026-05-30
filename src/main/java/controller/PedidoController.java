package controller;

import dao.ClienteDAO;
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
import util.InputValidator;
import util.SessionUtil;

import java.io.IOException;

@WebServlet("/servicio")
public class PedidoController extends HttpServlet {

    private final ClienteDAO clienteDAO = new ClienteDAO();
    private final PedidoDAO pedidoDAO = new PedidoDAO();

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
        pedidoDAO.crearPedidoLogotipo(pedido);

        request.setAttribute("tituloConfirmacion", "Pedido registrado correctamente");
        request.setAttribute("mensajeConfirmacion", "Tu solicitud de logotipo fue registrada. Puedes volver al inicio o registrar otro pedido.");
        request.setAttribute("areaConfirmacion", "Por favor aproximarse al área de Diseño.");
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
        pedidoDAO.crearPedidoInstalacion(pedido);

        request.setAttribute("tituloConfirmacion", "Pedido registrado correctamente");
        request.setAttribute("mensajeConfirmacion", "Tu solicitud de instalación fue registrada. Puedes volver al inicio o registrar otro pedido.");
        request.setAttribute("areaConfirmacion", "Por favor aproximarse al área de Instalaciones.");
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
        pedido.setIdCliente(idCliente);
        pedidoDAO.crearPedidoPolarizado(pedido);

        request.setAttribute("tituloConfirmacion", "Pedido registrado correctamente");
        request.setAttribute("mensajeConfirmacion", "Tu solicitud de polarizado fue registrada. Puedes volver al inicio o registrar otro pedido.");
        request.setAttribute("areaConfirmacion", "Por favor aproximarse al área de Polarizado.");
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

        if (InputValidator.esIdPositivo(idPedido)
                && InputValidator.esMaterialValido(material)
                && InputValidator.esLuzVisibleValida(luzVisible)) {
            pedidoDAO.actualizarPedidoPolarizado(Integer.parseInt(idPedido), material, luzVisible);
            SessionUtil.guardarFlashSuccess(request, "Pedido de polarizado actualizado correctamente.");
        } else {
            SessionUtil.guardarFlashWarning(request, "No se pudo actualizar el pedido de polarizado. Verifica los datos enviados.");
        }

        response.sendRedirect("servicio?tipo=reportes");
    }

    private void actualizarLogotipo(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idPedidoLogotipo = request.getParameter("idPedidoLogotipo");
        String servicioSeleccionado = request.getParameter("servicioSeleccionado");

        if (InputValidator.esIdPositivo(idPedidoLogotipo)
                && InputValidator.esServicioLogotipoValido(servicioSeleccionado)) {
            pedidoDAO.actualizarPedidoLogotipo(Integer.parseInt(idPedidoLogotipo), servicioSeleccionado);
            SessionUtil.guardarFlashSuccess(request, "Pedido de logotipo actualizado correctamente.");
        } else {
            SessionUtil.guardarFlashWarning(request, "No se pudo actualizar el pedido de logotipo. Verifica los datos enviados.");
        }

        response.sendRedirect("servicio?tipo=reportes");
    }

    private void actualizarInstalacion(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idPedidoInstalacion = request.getParameter("idPedidoInstalacion");
        String servicioSeleccionado = request.getParameter("servicioSeleccionado");

        if (InputValidator.esIdPositivo(idPedidoInstalacion)
                && InputValidator.esServicioInstalacionValido(servicioSeleccionado)) {
            pedidoDAO.actualizarPedidoInstalacion(Integer.parseInt(idPedidoInstalacion), servicioSeleccionado);
            SessionUtil.guardarFlashSuccess(request, "Pedido de instalación actualizado correctamente.");
        } else {
            SessionUtil.guardarFlashWarning(request, "No se pudo actualizar el pedido de instalación. Verifica los datos enviados.");
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
        request.setAttribute("clientes", clienteDAO.listarClientes());
        request.setAttribute("pedidos", pedidoDAO.listarPedidosPolarizado());
        request.setAttribute("pedidosLogotipo", pedidoDAO.listarPedidosLogotipo());
        request.setAttribute("pedidosInstalacion", pedidoDAO.listarPedidosInstalacion());
        request.setAttribute("flashSuccess", SessionUtil.consumirFlashSuccess(request));
        request.setAttribute("flashWarning", SessionUtil.consumirFlashWarning(request));
        request.setAttribute("flashError", SessionUtil.consumirFlashError(request));
    }
}
