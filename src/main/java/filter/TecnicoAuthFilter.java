package filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import util.SessionUtil;

import java.io.IOException;

@WebFilter(urlPatterns = {"/tecnico", "/tecnico.jsp"})
public class TecnicoAuthFilter implements Filter {

    @Override
    public void doFilter(jakarta.servlet.ServletRequest request, jakarta.servlet.ServletResponse response,
                         FilterChain chain) throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        if (SessionUtil.esAdministradorOTecnico(httpRequest)) {
            chain.doFilter(request, response);
            return;
        }

        SessionUtil.guardarRedireccionPendiente(httpRequest, httpRequest.getRequestURI());
        SessionUtil.guardarFlashError(httpRequest, "Debes iniciar sesion para acceder al panel tecnico.");
        httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
    }
}
