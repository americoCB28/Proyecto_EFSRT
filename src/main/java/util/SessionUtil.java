package util;

import dao.UsuarioDAO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import model.Usuario;

public final class SessionUtil {

    private static final UsuarioDAO USUARIO_DAO = new UsuarioDAO();

    public static final String AUTH_USER = "authUser";
    public static final String PENDING_REDIRECT = "pendingRedirect";
    public static final String FLASH_ERROR = "flashError";
    public static final String FLASH_SUCCESS = "flashSuccess";
    public static final String FLASH_WARNING = "flashWarning";

    private SessionUtil() {
    }

    public static void iniciarSesion(HttpServletRequest request, Usuario usuario) {
        HttpSession session = request.getSession(true);
        session.setAttribute(AUTH_USER, usuario);
    }

    public static void cerrarSesion(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
    }

    public static Usuario obtenerUsuario(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        Object usuario = session.getAttribute(AUTH_USER);
        return usuario instanceof Usuario ? (Usuario) usuario : null;
    }

    public static boolean estaAutenticado(HttpServletRequest request) {
        return obtenerUsuario(request) != null;
    }

    public static boolean esAdministrador(HttpServletRequest request) {
        return tieneRol(request, "ADMIN");
    }

    public static boolean esTecnico(HttpServletRequest request) {
        return tieneRol(request, "TECNICO");
    }

    public static boolean esAdministradorOTecnico(HttpServletRequest request) {
        return tieneRol(request, "ADMIN", "TECNICO");
    }

    public static void guardarRedireccionPendiente(HttpServletRequest request, String redirect) {
        HttpSession session = request.getSession(true);
        session.setAttribute(PENDING_REDIRECT, redirect);
    }

    public static String consumirRedireccionPendiente(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        Object redirect = session.getAttribute(PENDING_REDIRECT);
        session.removeAttribute(PENDING_REDIRECT);
        return redirect instanceof String ? (String) redirect : null;
    }

    public static void guardarFlashError(HttpServletRequest request, String message) {
        guardarFlash(request, FLASH_ERROR, message);
    }

    public static void guardarFlashSuccess(HttpServletRequest request, String message) {
        guardarFlash(request, FLASH_SUCCESS, message);
    }

    public static String consumirFlashError(HttpServletRequest request) {
        return consumirFlash(request, FLASH_ERROR);
    }

    public static String consumirFlashSuccess(HttpServletRequest request) {
        return consumirFlash(request, FLASH_SUCCESS);
    }

    public static void guardarFlashWarning(HttpServletRequest request, String message) {
        guardarFlash(request, FLASH_WARNING, message);
    }

    public static String consumirFlashWarning(HttpServletRequest request) {
        return consumirFlash(request, FLASH_WARNING);
    }

    private static void guardarFlash(HttpServletRequest request, String key, String message) {
        HttpSession session = request.getSession(true);
        session.setAttribute(key, message);
    }

    private static String consumirFlash(HttpServletRequest request, String key) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        Object message = session.getAttribute(key);
        session.removeAttribute(key);
        return message instanceof String ? (String) message : null;
    }

    private static boolean tieneRol(HttpServletRequest request, String... rolesPermitidos) {
        Usuario usuario = obtenerUsuario(request);
        if (usuario == null) {
            return false;
        }

        Usuario usuarioActualizado = USUARIO_DAO.buscarUsuarioActivoPorId(usuario.getIdUsuario());
        if (usuarioActualizado == null) {
            cerrarSesion(request);
            return false;
        }

        HttpSession session = request.getSession(false);
        if (session != null) {
            session.setAttribute(AUTH_USER, usuarioActualizado);
        }

        for (String rol : rolesPermitidos) {
            if (rol.equalsIgnoreCase(usuarioActualizado.getRol())) {
                return true;
            }
        }
        return false;
    }
}
