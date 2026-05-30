package filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import util.SessionUtil;

import java.io.IOException;
import java.util.Set;

@WebFilter(urlPatterns = {
        "/servicio",
        "/usuarios",
        "/dashboard.jsp",
        "/reportes.jsp",
        "/actualizarReporte.jsp",
        "/historialCliente.jsp",
        "/usuarios.jsp"
})
public class AdminAuthFilter implements Filter {

    private static final Set<String> TIPOS_PROTEGIDOS = Set.of(
            "dashboard",
            "reportes",
            "exportarCsv",
            "historialCliente",
            "actualizarReporte",
            "actualizarCliente",
            "actualizarPolarizado",
            "actualizarLogotipo",
            "actualizarInstalacion",
            "eliminarCliente"
    );

    @Override
    public void doFilter(jakarta.servlet.ServletRequest request, jakarta.servlet.ServletResponse response,
                         FilterChain chain) throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        if (!requiereAutenticacion(httpRequest)) {
            chain.doFilter(request, response);
            return;
        }

        if (SessionUtil.esAdministrador(httpRequest)) {
            chain.doFilter(request, response);
            return;
        }

        SessionUtil.guardarRedireccionPendiente(httpRequest, construirDestinoProtegido(httpRequest));
        SessionUtil.guardarFlashError(httpRequest, "Debes iniciar sesion para acceder a la zona administrativa.");
        httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
    }

    private boolean requiereAutenticacion(HttpServletRequest request) {
        String servletPath = request.getServletPath();
        if ("/dashboard.jsp".equals(servletPath)
                || "/reportes.jsp".equals(servletPath)
                || "/actualizarReporte.jsp".equals(servletPath)
                || "/historialCliente.jsp".equals(servletPath)
                || "/usuarios.jsp".equals(servletPath)
                || "/usuarios".equals(servletPath)) {
            return true;
        }

        if ("/servicio".equals(servletPath)) {
            String tipo = request.getParameter("tipo");
            return TIPOS_PROTEGIDOS.contains(tipo);
        }

        return false;
    }

    private String construirDestinoProtegido(HttpServletRequest request) {
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            if ("/usuarios".equals(request.getServletPath())) {
                return request.getContextPath() + "/usuarios";
            }
            return request.getContextPath() + "/servicio?tipo=reportes";
        }

        String query = request.getQueryString();
        if (query == null || query.isBlank()) {
            return request.getRequestURI();
        }
        return request.getRequestURI() + "?" + query;
    }
}
