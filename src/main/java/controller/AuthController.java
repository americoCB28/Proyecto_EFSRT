package controller;

import dao.UsuarioDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Usuario;
import util.PasswordUtil;
import util.SessionUtil;

import java.io.IOException;

@WebServlet(urlPatterns = {"/login", "/logout"})
public class AuthController extends HttpServlet {

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String servletPath = request.getServletPath();

        if ("/logout".equals(servletPath)) {
            SessionUtil.cerrarSesion(request);
            SessionUtil.guardarFlashSuccess(request, "Sesion cerrada correctamente.");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if (SessionUtil.esAdministrador(request)) {
            response.sendRedirect(request.getContextPath() + "/servicio?tipo=dashboard");
            return;
        }

        if (SessionUtil.esTecnico(request)) {
            response.sendRedirect(request.getContextPath() + "/tecnico");
            return;
        }

        request.setAttribute("error", SessionUtil.consumirFlashError(request));
        request.setAttribute("success", SessionUtil.consumirFlashSuccess(request));
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String servletPath = request.getServletPath();
        if (!"/login".equals(servletPath)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String username = normalizar(request.getParameter("username"));
        String password = request.getParameter("password");

        if (username == null || username.isBlank() || password == null || password.isBlank()) {
            request.setAttribute("error", "Usuario y contrasena son obligatorios.");
            request.setAttribute("username", username == null ? "" : username);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        Usuario usuario = usuarioDAO.buscarUsuarioActivoPorUsername(username);
        if (usuario == null || !PasswordUtil.verifyPassword(password, usuario.getPasswordHash())) {
            request.setAttribute("error", "Credenciales incorrectas.");
            request.setAttribute("username", username);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        SessionUtil.iniciarSesion(request, usuario);
        String redirect = SessionUtil.consumirRedireccionPendiente(request);
        if (redirect == null || redirect.isBlank()) {
            redirect = "TECNICO".equalsIgnoreCase(usuario.getRol())
                    ? request.getContextPath() + "/tecnico"
                    : request.getContextPath() + "/servicio?tipo=dashboard";
        }
        response.sendRedirect(redirect);
    }

    private String normalizar(String valor) {
        return valor == null ? null : valor.trim();
    }
}
