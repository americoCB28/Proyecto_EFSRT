package controller;

import dao.UsuarioDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Usuario;
import util.CsrfUtil;
import util.InputValidator;
import util.PasswordUtil;
import util.SessionUtil;

import java.io.IOException;
import java.util.List;

@WebServlet("/usuarios")
public class UsuarioAdminController extends HttpServlet {

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        cargarVistaUsuarios(request);
        request.getRequestDispatcher("/usuarios.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        if (!CsrfUtil.esTokenValido(request)) {
            SessionUtil.guardarFlashError(request, "La solicitud administrativa no es valida o ha expirado.");
            response.sendRedirect(request.getContextPath() + "/usuarios");
            return;
        }

        String accion = request.getParameter("accion");

        if ("crear".equals(accion)) {
            crearAdministrador(request, response);
            return;
        }

        if ("toggle".equals(accion)) {
            cambiarEstadoUsuario(request, response);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/usuarios");
    }

    private void crearAdministrador(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        String username = InputValidator.normalizarUsername(request.getParameter("username"));
        String password = request.getParameter("password");

        request.setAttribute("nuevoUsername", username == null ? "" : username);

        if (!InputValidator.esUsernameValido(username)) {
            request.setAttribute("flashError", "El username es obligatorio y solo permite letras, numeros, punto, guion y guion bajo.");
            cargarVistaUsuarios(request);
            request.getRequestDispatcher("/usuarios.jsp").forward(request, response);
            return;
        }

        if (!InputValidator.esPasswordAdminValida(password)) {
            request.setAttribute("flashError", "La contrasena es obligatoria y debe tener minimo 8 caracteres.");
            cargarVistaUsuarios(request);
            request.getRequestDispatcher("/usuarios.jsp").forward(request, response);
            return;
        }

        if (usuarioDAO.existeUsername(username)) {
            request.setAttribute("flashError", "El username ya existe. Usa otro valor.");
            cargarVistaUsuarios(request);
            request.getRequestDispatcher("/usuarios.jsp").forward(request, response);
            return;
        }

        boolean creado = usuarioDAO.crearAdministrador(username, PasswordUtil.hashPassword(password));
        if (creado) {
            SessionUtil.guardarFlashSuccess(request, "Administrador creado correctamente.");
            response.sendRedirect(request.getContextPath() + "/usuarios");
            return;
        }

        request.setAttribute("flashError", "No se pudo crear el administrador. Intenta nuevamente.");
        cargarVistaUsuarios(request);
        request.getRequestDispatcher("/usuarios.jsp").forward(request, response);
    }

    private void cambiarEstadoUsuario(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idUsuarioParam = request.getParameter("idUsuario");
        String nuevoEstadoParam = request.getParameter("activo");
        Usuario usuarioActual = SessionUtil.obtenerUsuario(request);

        if (!InputValidator.esIdPositivo(idUsuarioParam)) {
            SessionUtil.guardarFlashWarning(request, "El usuario seleccionado no es valido.");
            response.sendRedirect(request.getContextPath() + "/usuarios");
            return;
        }

        int idUsuario = Integer.parseInt(idUsuarioParam);
        if (!"1".equals(nuevoEstadoParam) && !"0".equals(nuevoEstadoParam)) {
            SessionUtil.guardarFlashWarning(request, "El estado solicitado no es valido.");
            response.sendRedirect(request.getContextPath() + "/usuarios");
            return;
        }
        boolean activar = "1".equals(nuevoEstadoParam);
        Usuario usuarioObjetivo = usuarioDAO.buscarUsuarioPorId(idUsuario);

        if (usuarioObjetivo == null || !"ADMIN".equalsIgnoreCase(usuarioObjetivo.getRol())) {
            SessionUtil.guardarFlashWarning(request, "No se encontro el administrador solicitado.");
            response.sendRedirect(request.getContextPath() + "/usuarios");
            return;
        }

        if (!activar && usuarioActual != null && usuarioActual.getIdUsuario() == idUsuario) {
            SessionUtil.guardarFlashWarning(request, "No puedes desactivar tu propio usuario.");
            response.sendRedirect(request.getContextPath() + "/usuarios");
            return;
        }

        boolean actualizado = usuarioDAO.actualizarEstadoUsuario(idUsuario, activar);
        if (actualizado) {
            SessionUtil.guardarFlashSuccess(request, activar
                    ? "Administrador activado correctamente."
                    : "Administrador desactivado correctamente.");
        } else {
            SessionUtil.guardarFlashError(request, "No se pudo actualizar el estado del administrador.");
        }
        response.sendRedirect(request.getContextPath() + "/usuarios");
    }

    private void cargarVistaUsuarios(HttpServletRequest request) {
        List<Usuario> usuarios = usuarioDAO.listarAdministradores();
        request.setAttribute("usuarios", usuarios);
        request.setAttribute("usuarioActual", SessionUtil.obtenerUsuario(request));
        if (request.getAttribute("flashSuccess") == null) {
            request.setAttribute("flashSuccess", SessionUtil.consumirFlashSuccess(request));
        }
        if (request.getAttribute("flashWarning") == null) {
            request.setAttribute("flashWarning", SessionUtil.consumirFlashWarning(request));
        }
        if (request.getAttribute("flashError") == null) {
            request.setAttribute("flashError", SessionUtil.consumirFlashError(request));
        }
    }
}
