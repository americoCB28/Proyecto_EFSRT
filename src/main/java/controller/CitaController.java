package controller;

import dao.CitaDAO;
import dao.CatalogoServicioDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Cita;
import model.CatalogoServicio;
import util.CitaCodeUtil;
import util.EmailCitaUtil;
import util.InputValidator;
import util.PdfCitaUtil;
import util.PriceEstimatorUtil;
import util.QrCitaUtil;
import util.SessionUtil;
import util.WhatsAppCitaUtil;

import java.io.IOException;

@WebServlet("/citas")
public class CitaController extends HttpServlet {

    private static final String CITA_DRAFT = "citaDraft";
    private static final String CITA_CONFIRMADA = "citaConfirmada";

    private final CitaDAO citaDAO = new CitaDAO();
    private final CatalogoServicioDAO catalogoServicioDAO = new CatalogoServicioDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String paso = request.getParameter("paso");

        if (paso == null || paso.isBlank() || "servicio".equals(paso)) {
            limpiarCitaConfirmada(request);
            request.setAttribute("catalogoServicios", catalogoServicioDAO.listarServicios(false));
            request.getRequestDispatcher("/seleccionarCita.jsp").forward(request, response);
            return;
        }

        if ("detalle".equals(paso)) {
            mostrarPasoDetalle(request, response);
            return;
        }

        if ("horario".equals(paso)) {
            mostrarPasoHorario(request, response);
            return;
        }

        if ("preliminar".equals(paso)) {
            mostrarPasoResumen(request, response);
            return;
        }

        if ("confirmacion".equals(paso)) {
            mostrarConfirmacion(request, response);
            return;
        }

        response.sendRedirect("citas");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");

        if ("detalle".equals(accion)) {
            procesarPasoDetalle(request, response);
            return;
        }

        if ("horario".equals(accion)) {
            procesarPasoHorario(request, response);
            return;
        }

        if ("confirmar".equals(accion)) {
            confirmarCita(request, response);
            return;
        }

        response.sendRedirect("citas");
    }

    private void mostrarPasoDetalle(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idCatalogoServicioParam = request.getParameter("idCatalogoServicio");
        if (!InputValidator.esIdPositivo(idCatalogoServicioParam)) {
            response.sendRedirect("citas");
            return;
        }

        CatalogoServicio catalogoServicio = catalogoServicioDAO.buscarPorId(Integer.parseInt(idCatalogoServicioParam));
        if (catalogoServicio == null || !catalogoServicio.isActivo() || !catalogoServicio.isRequiereCita()) {
            response.sendRedirect("citas");
            return;
        }

        String servicio = catalogoServicio.getTipoBase();
        Cita cita = obtenerCitaDraft(request);
        cita.setIdCatalogoServicio(catalogoServicio.getIdCatalogoServicio());
        cita.setTipoServicio(servicio);
        cita.setNombreCatalogoServicio(catalogoServicio.getNombre());
        guardarCitaDraft(request, cita);

        request.setAttribute("servicio", servicio);
        request.setAttribute("catalogoServicio", catalogoServicio);
        request.setAttribute("citaDraft", cita);
        request.getRequestDispatcher("/detalleCita.jsp").forward(request, response);
    }

    private void mostrarPasoHorario(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Cita cita = obtenerCitaDraft(request);
        if (!InputValidator.esTipoCitaValido(cita.getTipoServicio()) || cita.getDetalleServicio() == null) {
            response.sendRedirect("citas");
            return;
        }

        request.setAttribute("citaDraft", cita);
        request.getRequestDispatcher("/horarioCita.jsp").forward(request, response);
    }

    private void mostrarPasoResumen(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Cita cita = obtenerCitaDraft(request);
        if (!flujoBaseCompleto(cita)) {
            response.sendRedirect("citas");
            return;
        }

        cita.setPrecioEstimado(PriceEstimatorUtil.estimar(cita));
        guardarCitaDraft(request, cita);

        request.setAttribute("citaDraft", cita);
        request.getRequestDispatcher("/preliminarCita.jsp").forward(request, response);
    }

    private void mostrarConfirmacion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Cita cita = consumirCitaConfirmada(request);
        if (cita == null) {
            response.sendRedirect("citas");
            return;
        }

        request.setAttribute("citaConfirmada", cita);
        request.setAttribute("flashSuccess", SessionUtil.consumirFlashSuccess(request));
        request.setAttribute("flashWarning", SessionUtil.consumirFlashWarning(request));
        request.setAttribute("flashError", SessionUtil.consumirFlashError(request));
        request.getRequestDispatcher("/confirmacionCita.jsp").forward(request, response);
    }

    private void procesarPasoDetalle(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        String idCatalogoServicioParam = request.getParameter("idCatalogoServicio");
        if (!InputValidator.esIdPositivo(idCatalogoServicioParam)) {
            response.sendRedirect("citas");
            return;
        }

        CatalogoServicio catalogoServicio = catalogoServicioDAO.buscarPorId(Integer.parseInt(idCatalogoServicioParam));
        if (catalogoServicio == null || !catalogoServicio.isActivo()) {
            response.sendRedirect("citas");
            return;
        }
        String servicio = catalogoServicio.getTipoBase();
        if (!InputValidator.esTipoCitaValido(servicio)) {
            response.sendRedirect("citas");
            return;
        }

        Cita cita = obtenerCitaDraft(request);
        cita.setIdCatalogoServicio(catalogoServicio.getIdCatalogoServicio());
        cita.setTipoServicio(servicio);
        cita.setNombreCatalogoServicio(catalogoServicio.getNombre());

        if ("polarizado".equals(servicio)) {
            String material = request.getParameter("material");
            String luzVisible = request.getParameter("luzVisible");
            if (!InputValidator.esMaterialValido(material) || !InputValidator.esLuzVisibleValida(luzVisible)) {
                request.setAttribute("error", "Selecciona un material y una intensidad validos para continuar.");
                request.setAttribute("servicio", servicio);
                request.setAttribute("catalogoServicio", catalogoServicio);
                request.setAttribute("citaDraft", cita);
                request.getRequestDispatcher("/detalleCita.jsp").forward(request, response);
                return;
            }
            cita.setMaterial(material);
            cita.setLuzVisible(luzVisible);
            cita.setServicioSeleccionado(null);
            cita.setDetalleServicio("Material: " + material + " | Luz visible: " + luzVisible);
        } else {
            String servicioSeleccionado = request.getParameter("servicioSeleccionado");
            boolean valido = "logotipo".equals(servicio)
                    ? InputValidator.esServicioLogotipoValido(servicioSeleccionado)
                    : InputValidator.esServicioInstalacionValido(servicioSeleccionado);
            if (!valido) {
                request.setAttribute("error", "Selecciona una opcion valida para continuar.");
                request.setAttribute("servicio", servicio);
                request.setAttribute("catalogoServicio", catalogoServicio);
                request.setAttribute("citaDraft", cita);
                request.getRequestDispatcher("/detalleCita.jsp").forward(request, response);
                return;
            }
            cita.setServicioSeleccionado(servicioSeleccionado);
            cita.setMaterial(null);
            cita.setLuzVisible(null);
            cita.setDetalleServicio(servicioSeleccionado);
        }

        guardarCitaDraft(request, cita);
        response.sendRedirect("citas?paso=horario");
    }

    private void procesarPasoHorario(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        Cita cita = obtenerCitaDraft(request);
        if (!InputValidator.esTipoCitaValido(cita.getTipoServicio()) || cita.getDetalleServicio() == null) {
            response.sendRedirect("citas");
            return;
        }

        String fechaCita = request.getParameter("fechaCita");
        String franjaHoraria = request.getParameter("franjaHoraria");

        if (!InputValidator.esFechaCitaValida(fechaCita) || !InputValidator.esFranjaHorariaValida(franjaHoraria)) {
            request.setAttribute("error", "Selecciona una fecha vigente y una franja horaria valida.");
            request.setAttribute("citaDraft", cita);
            request.getRequestDispatcher("/horarioCita.jsp").forward(request, response);
            return;
        }

        cita.setFechaCita(fechaCita);
        cita.setFranjaHoraria(franjaHoraria);
        cita.setEstadoCita("pendiente");
        guardarCitaDraft(request, cita);
        response.sendRedirect("citas?paso=preliminar");
    }

    private void confirmarCita(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        Cita cita = obtenerCitaDraft(request);
        if (!flujoBaseCompleto(cita)) {
            response.sendRedirect("citas");
            return;
        }

        String nombre = InputValidator.normalizarNombre(request.getParameter("nombreCliente"));
        String correo = normalizarTexto(request.getParameter("correoCliente"));
        String telefono = normalizarTexto(request.getParameter("telefonoCliente"));
        String observaciones = normalizarTexto(request.getParameter("observaciones"));
        String canalEntrega = InputValidator.normalizarCanalEntregaCita(request.getParameter("canalEntrega"));

        cita.setPrecioEstimado(PriceEstimatorUtil.estimar(cita));
        cita.setNombreCliente(nombre);
        cita.setCorreoCliente(correo);
        cita.setTelefonoCliente(telefono);
        cita.setObservaciones(observaciones);
        cita.setCanalEntrega(canalEntrega);
        cita.setEstadoCita("pendiente");

        if (!InputValidator.esNombreValido(nombre)
                || !InputValidator.esCorreoValido(correo)
                || !InputValidator.esTelefonoValido(telefono)
                || !InputValidator.esCanalEntregaCitaValido(canalEntrega)) {
            request.setAttribute("error", "Completa nombre, correo, telefono y canal de entrega con datos validos.");
            request.setAttribute("citaDraft", cita);
            request.getRequestDispatcher("/preliminarCita.jsp").forward(request, response);
            return;
        }

        cita.setTokenVerificacion(CitaCodeUtil.generarToken());
        int idCita = citaDAO.crearCita(cita);
        if (idCita <= 0) {
            request.setAttribute("error", "No se pudo registrar la cita. Intenta nuevamente.");
            request.setAttribute("citaDraft", cita);
            request.getRequestDispatcher("/preliminarCita.jsp").forward(request, response);
            return;
        }

        String codigo = CitaCodeUtil.generarCodigo(idCita);
        citaDAO.actualizarCodigoVerificacion(idCita, codigo);
        cita.setIdCita(idCita);
        cita.setCodigoVerificacion(codigo);

        procesarEntregas(request, cita);

        guardarCitaConfirmada(request, cita);
        limpiarCitaDraft(request);
        response.sendRedirect("citas?paso=confirmacion");
    }

    private void procesarEntregas(HttpServletRequest request, Cita cita) {
        try {
            String baseUrl = construirBaseUrl(request);
            String urlVerificacion = QrCitaUtil.construirUrlVerificacion(baseUrl, cita.getTokenVerificacion());
            byte[] pdfBytes = PdfCitaUtil.generarPdf(cita, urlVerificacion);
            String canalSolicitado = cita.getCanalEntrega();
            boolean correoSolicitado = "correo".equals(canalSolicitado) || "correo+whatsapp".equals(canalSolicitado);
            boolean whatsappSolicitado = "whatsapp".equals(canalSolicitado) || "correo+whatsapp".equals(canalSolicitado);

            boolean correoEnviado = false;
            boolean whatsappEnviado = false;

            if (correoSolicitado) {
                EmailCitaUtil.ResultadoEnvio correo = EmailCitaUtil.enviarConfirmacion(cita, pdfBytes);
                correoEnviado = correo.enviado();
                guardarMensajeEntrega(request, correo);
            }

            if (whatsappSolicitado) {
                WhatsAppCitaUtil.ResultadoEnvio whatsapp = WhatsAppCitaUtil.enviarConfirmacion(cita, baseUrl);
                whatsappEnviado = whatsapp.enviado();
                cita.setWhatsappUrl(whatsapp.enlaceManual());
                guardarMensajeEntrega(request, whatsapp);
            }

            String canalFinal = resolverCanalFinal(correoEnviado, whatsappEnviado);
            cita.setCanalEntrega(canalFinal);
            citaDAO.actualizarCanalEntrega(cita.getIdCita(), canalFinal);
        } catch (Exception e) {
            cita.setCanalEntrega("web");
            citaDAO.actualizarCanalEntrega(cita.getIdCita(), "web");
            SessionUtil.guardarFlashWarning(request, "La cita se registro, pero no se pudieron preparar los canales de entrega solicitados.");
        }
    }

    private boolean flujoBaseCompleto(Cita cita) {
        return cita != null
                && InputValidator.esTipoCitaValido(cita.getTipoServicio())
                && cita.getDetalleServicio() != null
                && !cita.getDetalleServicio().isBlank()
                && InputValidator.esFechaCitaValida(cita.getFechaCita())
                && InputValidator.esFranjaHorariaValida(cita.getFranjaHoraria());
    }

    private Cita obtenerCitaDraft(HttpServletRequest request) {
        HttpSession session = request.getSession(true);
        Object draft = session.getAttribute(CITA_DRAFT);
        if (draft instanceof Cita cita) {
            return cita;
        }

        Cita cita = new Cita();
        session.setAttribute(CITA_DRAFT, cita);
        return cita;
    }

    private void guardarCitaDraft(HttpServletRequest request, Cita cita) {
        request.getSession(true).setAttribute(CITA_DRAFT, cita);
    }

    private void limpiarCitaDraft(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.removeAttribute(CITA_DRAFT);
        }
    }

    private void guardarCitaConfirmada(HttpServletRequest request, Cita cita) {
        request.getSession(true).setAttribute(CITA_CONFIRMADA, cita);
    }

    private Cita consumirCitaConfirmada(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        Object cita = session.getAttribute(CITA_CONFIRMADA);
        session.removeAttribute(CITA_CONFIRMADA);
        return cita instanceof Cita citaConfirmada ? citaConfirmada : null;
    }

    private void limpiarCitaConfirmada(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.removeAttribute(CITA_CONFIRMADA);
        }
    }

    private String normalizarTexto(String valor) {
        return valor == null ? null : valor.trim();
    }

    private String construirBaseUrl(HttpServletRequest request) {
        return request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
                + request.getContextPath();
    }

    private void guardarMensajeEntrega(HttpServletRequest request, EmailCitaUtil.ResultadoEnvio resultado) {
        if (resultado.enviado()) {
            SessionUtil.guardarFlashSuccess(request, resultado.mensaje());
        } else {
            SessionUtil.guardarFlashWarning(request, resultado.mensaje());
        }
    }

    private void guardarMensajeEntrega(HttpServletRequest request, WhatsAppCitaUtil.ResultadoEnvio resultado) {
        if (resultado.enviado()) {
            SessionUtil.guardarFlashSuccess(request, resultado.mensaje());
        } else {
            SessionUtil.guardarFlashWarning(request, resultado.mensaje());
        }
    }

    private String resolverCanalFinal(boolean correoEnviado, boolean whatsappEnviado) {
        if (correoEnviado && whatsappEnviado) {
            return "correo+whatsapp";
        }
        if (correoEnviado) {
            return "correo";
        }
        if (whatsappEnviado) {
            return "whatsapp";
        }
        return "web";
    }
}
