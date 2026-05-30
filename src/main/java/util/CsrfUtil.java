package util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import java.security.SecureRandom;
import java.util.Base64;

public final class CsrfUtil {

    public static final String CSRF_SESSION_KEY = "csrfToken";
    public static final String CSRF_REQUEST_PARAM = "_csrf";

    private CsrfUtil() {
    }

    public static String obtenerToken(HttpServletRequest request) {
        HttpSession session = request.getSession(true);
        Object token = session.getAttribute(CSRF_SESSION_KEY);
        if (token instanceof String csrf && !csrf.isBlank()) {
            return csrf;
        }

        String nuevoToken = generarToken();
        session.setAttribute(CSRF_SESSION_KEY, nuevoToken);
        return nuevoToken;
    }

    public static boolean esTokenValido(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return false;
        }

        Object esperado = session.getAttribute(CSRF_SESSION_KEY);
        String recibido = request.getParameter(CSRF_REQUEST_PARAM);
        return esperado instanceof String tokenEsperado
                && recibido != null
                && !recibido.isBlank()
                && tokenEsperado.equals(recibido);
    }

    private static String generarToken() {
        byte[] bytes = new byte[32];
        new SecureRandom().nextBytes(bytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
    }
}
