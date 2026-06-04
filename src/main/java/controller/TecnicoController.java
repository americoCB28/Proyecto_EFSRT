package controller;

import dao.CitaDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Cita;
import model.Usuario;
import util.CsrfUtil;
import util.InputValidator;
import util.SessionUtil;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/tecnico")
public class TecnicoController extends HttpServlet {

    private final CitaDAO citaDAO = new CitaDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Usuario usuarioActual = SessionUtil.obtenerUsuario(request);
        Integer tecnicoAsignado = obtenerTecnicoAsignado(usuarioActual);
        String fechaFiltro = InputValidator.normalizarFechaConsulta(request.getParameter("fechaCita"));
        String estadoFiltro = InputValidator.normalizarEstadoCitaFiltro(request.getParameter("estadoCita"));
        String estadoConsulta = "todos".equals(estadoFiltro) ? null : estadoFiltro;
        String fechaConsulta = fechaFiltro == null || fechaFiltro.isBlank() ? LocalDate.now().toString() : fechaFiltro;

        List<Cita> citas = citaDAO.listarCitasFiltradas(fechaConsulta, estadoConsulta, tecnicoAsignado, 25);
        cargarDetalleSiCorresponde(request, tecnicoAsignado);
        request.setAttribute("fechaCitaFiltro", fechaConsulta);
        request.setAttribute("estadoCitaFiltro", estadoFiltro);
        request.setAttribute("citasTecnico", citas);
        request.setAttribute("tecnicoActual", usuarioActual);
        request.setAttribute("citasHoy", (int) citas.stream()
                .filter(cita -> LocalDate.now().toString().equals(cita.getFechaCita()))
                .count());
        request.setAttribute("citasPendientes", (int) citas.stream()
                .filter(cita -> "pendiente".equals(cita.getEstadoCita()))
                .count());
        request.setAttribute("citasConfirmadas", (int) citas.stream()
                .filter(cita -> "confirmada".equals(cita.getEstadoCita()))
                .count());
        request.setAttribute("citasAtendidas", (int) citas.stream()
                .filter(cita -> "atendida".equals(cita.getEstadoCita()))
                .count());
        if (request.getAttribute("flashSuccess") == null) {
            request.setAttribute("flashSuccess", SessionUtil.consumirFlashSuccess(request));
        }
        if (request.getAttribute("flashWarning") == null) {
            request.setAttribute("flashWarning", SessionUtil.consumirFlashWarning(request));
        }
        if (request.getAttribute("flashError") == null) {
            request.setAttribute("flashError", SessionUtil.consumirFlashError(request));
        }
        request.getRequestDispatcher("/tecnico.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!CsrfUtil.esTokenValido(request)) {
            SessionUtil.guardarFlashError(request, "La solicitud tecnica no es valida o ha expirado.");
            response.sendRedirect("tecnico");
            return;
        }

        String accion = request.getParameter("accion");
        if ("actualizarEstado".equals(accion)) {
            actualizarEstadoTecnico(request, response);
            return;
        }

        response.sendRedirect("tecnico");
    }

    private void cargarDetalleSiCorresponde(HttpServletRequest request, Integer tecnicoAsignado) {
        String accion = request.getParameter("accion");
        String idCita = request.getParameter("idCita");
        if (!"detalle".equals(accion) || !InputValidator.esIdPositivo(idCita)) {
            return;
        }

        Cita cita = citaDAO.buscarPorId(Integer.parseInt(idCita));
        if (cita == null || !puedeGestionarCita(cita, tecnicoAsignado)) {
            request.setAttribute("flashWarning", "La cita solicitada no esta disponible para este panel.");
            return;
        }

        request.setAttribute("citaDetalle", cita);
    }

    private void actualizarEstadoTecnico(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Usuario usuarioActual = SessionUtil.obtenerUsuario(request);
        Integer tecnicoAsignado = obtenerTecnicoAsignado(usuarioActual);
        String idCita = request.getParameter("idCita");
        String estadoCita = request.getParameter("estadoCita");

        if (!InputValidator.esIdPositivo(idCita) || !InputValidator.esEstadoCitaValido(estadoCita)) {
            SessionUtil.guardarFlashWarning(request, "No se pudo actualizar la cita tecnica. Verifica los datos enviados.");
            response.sendRedirect("tecnico");
            return;
        }

        Cita cita = citaDAO.buscarPorId(Integer.parseInt(idCita));
        if (cita == null || !puedeGestionarCita(cita, tecnicoAsignado)) {
            SessionUtil.guardarFlashWarning(request, "La cita seleccionada no pertenece al tecnico actual.");
            response.sendRedirect("tecnico");
            return;
        }

        if (!estadoTecnicoPermitido(estadoCita)) {
            SessionUtil.guardarFlashWarning(request, "El tecnico solo puede marcar citas como confirmadas, atendidas o vencidas.");
            response.sendRedirect("tecnico?accion=detalle&idCita=" + cita.getIdCita());
            return;
        }

        boolean actualizado = citaDAO.actualizarEstadoCita(cita.getIdCita(), estadoCita);
        if (actualizado) {
            SessionUtil.guardarFlashSuccess(request, "Estado de la cita actualizado desde el panel tecnico.");
        } else {
            SessionUtil.guardarFlashError(request, "No se pudo actualizar el estado de la cita.");
        }
        response.sendRedirect("tecnico?accion=detalle&idCita=" + cita.getIdCita());
    }

    private Integer obtenerTecnicoAsignado(Usuario usuarioActual) {
        if (usuarioActual != null && "TECNICO".equalsIgnoreCase(usuarioActual.getRol())) {
            return usuarioActual.getIdUsuario();
        }
        return null;
    }

    private boolean puedeGestionarCita(Cita cita, Integer tecnicoAsignado) {
        return tecnicoAsignado == null || (cita.getIdTecnicoAsignado() != null && tecnicoAsignado.equals(cita.getIdTecnicoAsignado()));
    }

    private boolean estadoTecnicoPermitido(String estadoCita) {
        return "confirmada".equals(estadoCita)
                || "atendida".equals(estadoCita)
                || "vencida".equals(estadoCita);
    }
}
