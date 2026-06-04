package controller;

import dao.CatalogoServicioDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.CatalogoServicio;
import util.CsrfUtil;
import util.InputValidator;
import util.SessionUtil;

import java.io.IOException;
import java.util.List;

@WebServlet("/servicios-admin")
public class ServiciosAdminController extends HttpServlet {

    private final CatalogoServicioDAO catalogoServicioDAO = new CatalogoServicioDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        cargarVista(request);
        request.getRequestDispatcher("/serviciosAdmin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!CsrfUtil.esTokenValido(request)) {
            SessionUtil.guardarFlashError(request, "La solicitud administrativa no es valida o ha expirado.");
            response.sendRedirect(request.getContextPath() + "/servicios-admin");
            return;
        }

        String accion = request.getParameter("accion");
        if ("crear".equals(accion)) {
            crearServicio(request, response);
            return;
        }
        if ("actualizar".equals(accion)) {
            actualizarServicio(request, response);
            return;
        }
        if ("toggle".equals(accion)) {
            cambiarEstadoServicio(request, response);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/servicios-admin");
    }

    private void crearServicio(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        CatalogoServicio servicio = construirServicioDesdeRequest(request, false);
        request.setAttribute("draftServicio", servicio);

        if (!validarServicio(request, servicio, false)) {
            cargarVista(request);
            request.getRequestDispatcher("/serviciosAdmin.jsp").forward(request, response);
            return;
        }

        if (catalogoServicioDAO.existeSlug(servicio.getSlug())) {
            request.setAttribute("flashError", "El slug del servicio ya existe. Usa un identificador diferente.");
            cargarVista(request);
            request.getRequestDispatcher("/serviciosAdmin.jsp").forward(request, response);
            return;
        }

        if (catalogoServicioDAO.crearServicio(servicio)) {
            SessionUtil.guardarFlashSuccess(request, "Servicio creado correctamente.");
            response.sendRedirect(request.getContextPath() + "/servicios-admin");
            return;
        }

        request.setAttribute("flashError", "No se pudo crear el servicio. Intenta nuevamente.");
        cargarVista(request);
        request.getRequestDispatcher("/serviciosAdmin.jsp").forward(request, response);
    }

    private void actualizarServicio(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        CatalogoServicio servicio = construirServicioDesdeRequest(request, true);

        if (!validarServicio(request, servicio, true)) {
            SessionUtil.guardarFlashWarning(request, "No se pudo actualizar el servicio. Verifica los datos enviados.");
            response.sendRedirect(request.getContextPath() + "/servicios-admin");
            return;
        }

        if (catalogoServicioDAO.existeSlugEnOtroRegistro(servicio.getIdCatalogoServicio(), servicio.getSlug())) {
            SessionUtil.guardarFlashWarning(request, "El slug ya esta siendo usado por otro servicio.");
            response.sendRedirect(request.getContextPath() + "/servicios-admin");
            return;
        }

        if (catalogoServicioDAO.actualizarServicio(servicio)) {
            SessionUtil.guardarFlashSuccess(request, "Servicio actualizado correctamente.");
        } else {
            SessionUtil.guardarFlashError(request, "No se pudo actualizar el servicio.");
        }
        response.sendRedirect(request.getContextPath() + "/servicios-admin");
    }

    private void cambiarEstadoServicio(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idParam = request.getParameter("idCatalogoServicio");
        String activoParam = request.getParameter("activo");
        if (!InputValidator.esIdPositivo(idParam) || (!"1".equals(activoParam) && !"0".equals(activoParam))) {
            SessionUtil.guardarFlashWarning(request, "No se pudo cambiar el estado del servicio.");
            response.sendRedirect(request.getContextPath() + "/servicios-admin");
            return;
        }

        boolean activo = "1".equals(activoParam);
        if (catalogoServicioDAO.actualizarEstadoServicio(Integer.parseInt(idParam), activo)) {
            SessionUtil.guardarFlashSuccess(request, activo
                    ? "Servicio activado correctamente."
                    : "Servicio desactivado correctamente.");
        } else {
            SessionUtil.guardarFlashError(request, "No se pudo actualizar el estado del servicio.");
        }
        response.sendRedirect(request.getContextPath() + "/servicios-admin");
    }

    private CatalogoServicio construirServicioDesdeRequest(HttpServletRequest request, boolean conId) {
        CatalogoServicio servicio = new CatalogoServicio();
        if (conId && InputValidator.esIdPositivo(request.getParameter("idCatalogoServicio"))) {
            servicio.setIdCatalogoServicio(Integer.parseInt(request.getParameter("idCatalogoServicio")));
        }
        servicio.setNombre(InputValidator.normalizarNombreServicio(request.getParameter("nombre")));
        servicio.setSlug(InputValidator.normalizarSlugServicio(request.getParameter("slug")));
        servicio.setTipoBase(InputValidator.normalizarTipoBaseServicio(request.getParameter("tipoBase")));
        servicio.setDescripcionCorta(InputValidator.normalizarDescripcionCorta(request.getParameter("descripcionCorta")));
        servicio.setPrecioBase(InputValidator.esPrecioBaseValido(request.getParameter("precioBase"))
                ? Double.parseDouble(request.getParameter("precioBase")) : -1);
        servicio.setDuracionMinutos(InputValidator.esDuracionMinutosValida(request.getParameter("duracionMinutos"))
                ? Integer.parseInt(request.getParameter("duracionMinutos")) : -1);
        servicio.setOrdenVisual(InputValidator.esOrdenVisualValido(request.getParameter("ordenVisual"))
                ? Integer.parseInt(request.getParameter("ordenVisual")) : -1);
        servicio.setActivo("1".equals(request.getParameter("activo")) || "on".equalsIgnoreCase(request.getParameter("activo")));
        servicio.setRequiereCita("1".equals(request.getParameter("requiereCita")) || "on".equalsIgnoreCase(request.getParameter("requiereCita")));
        return servicio;
    }

    private boolean validarServicio(HttpServletRequest request, CatalogoServicio servicio, boolean conId) {
        if (conId && servicio.getIdCatalogoServicio() <= 0) {
            return false;
        }
        if (!InputValidator.esNombreServicioValido(servicio.getNombre())
                || !InputValidator.esSlugServicioValido(servicio.getSlug())
                || !InputValidator.esTipoCitaValido(servicio.getTipoBase())
                || !InputValidator.esDescripcionCortaValida(servicio.getDescripcionCorta())
                || servicio.getPrecioBase() < 0
                || servicio.getDuracionMinutos() < 15
                || servicio.getOrdenVisual() < 1) {
            if (!conId) {
                request.setAttribute("flashError", "Completa nombre, slug, descripcion, precio, duracion y orden con valores validos.");
            }
            return false;
        }
        return true;
    }

    private void cargarVista(HttpServletRequest request) {
        List<CatalogoServicio> servicios = catalogoServicioDAO.listarServicios(true);
        request.setAttribute("catalogoServicios", servicios);
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
