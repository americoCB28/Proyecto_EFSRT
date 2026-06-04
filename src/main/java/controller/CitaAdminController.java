package controller;

import dao.CitaDAO;
import dao.UsuarioDAO;
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

@WebServlet("/admin-citas")
public class CitaAdminController extends HttpServlet {

    private final CitaDAO citaDAO = new CitaDAO();
    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");

        if ("verificar".equals(accion)) {
            verificarCita(request);
        } else if ("buscar".equals(accion)) {
            buscarCita(request);
        }

        cargarResumenCitas(request);
        request.setAttribute("flashSuccess", SessionUtil.consumirFlashSuccess(request));
        request.setAttribute("flashWarning", SessionUtil.consumirFlashWarning(request));
        request.setAttribute("flashError", SessionUtil.consumirFlashError(request));
        request.getRequestDispatcher("/adminCitas.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!CsrfUtil.esTokenValido(request)) {
            SessionUtil.guardarFlashError(request, "La solicitud administrativa no es valida o ha expirado.");
            response.sendRedirect("admin-citas");
            return;
        }

        String accion = request.getParameter("accion");
        if ("actualizarEstado".equals(accion)) {
            actualizarEstado(request, response);
            return;
        }
        if ("asignarTecnico".equals(accion)) {
            asignarTecnico(request, response);
            return;
        }

        response.sendRedirect("admin-citas");
    }

    private void cargarResumenCitas(HttpServletRequest request) {
        String fechaFiltro = InputValidator.normalizarFechaConsulta(request.getParameter("fechaCita"));
        String estadoFiltro = InputValidator.normalizarEstadoCitaFiltro(request.getParameter("estadoCita"));
        String estadoConsulta = "todos".equals(estadoFiltro) ? null : estadoFiltro;

        request.setAttribute("fechaCitaFiltro", fechaFiltro);
        request.setAttribute("estadoCitaFiltro", estadoFiltro);
        request.setAttribute("totalCitas", citaDAO.contarCitas());
        request.setAttribute("citasPendientes", citaDAO.contarCitasPorEstado("pendiente"));
        request.setAttribute("citasConfirmadas", citaDAO.contarCitasPorEstado("confirmada"));
        request.setAttribute("citasHoy", citaDAO.contarCitasPorFecha(LocalDate.now().toString()));
        request.setAttribute("ultimasCitas", citaDAO.listarCitasFiltradas(fechaFiltro, estadoConsulta, 20));
        request.setAttribute("tecnicos", usuarioDAO.listarTecnicosActivos());
    }

    private void verificarCita(HttpServletRequest request) {
        String token = request.getParameter("token");
        if (token == null || token.isBlank()) {
            request.setAttribute("flashWarning", "No se recibio un token de verificacion valido.");
            return;
        }

        Cita cita = citaDAO.buscarPorToken(token);
        if (cita == null) {
            request.setAttribute("flashWarning", "No se encontro una cita asociada al QR escaneado.");
            return;
        }

        request.setAttribute("citaVerificada", cita);
        request.setAttribute("validacionExitosa", Boolean.TRUE);
    }

    private void buscarCita(HttpServletRequest request) {
        String codigo = request.getParameter("codigo");
        if (codigo == null || codigo.isBlank()) {
            request.setAttribute("flashWarning", "Ingresa un codigo de cita para buscar.");
            return;
        }

        Cita cita = citaDAO.buscarPorCodigo(codigo.trim());
        if (cita == null) {
            request.setAttribute("flashWarning", "No se encontro una cita con el codigo ingresado.");
            return;
        }

        request.setAttribute("citaVerificada", cita);
        request.setAttribute("validacionExitosa", Boolean.TRUE);
    }

    private void actualizarEstado(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idCita = request.getParameter("idCita");
        String estadoCita = request.getParameter("estadoCita");

        if (!InputValidator.esIdPositivo(idCita) || !InputValidator.esEstadoCitaValido(estadoCita)) {
            SessionUtil.guardarFlashWarning(request, "No se pudo actualizar el estado de la cita. Verifica los datos enviados.");
            response.sendRedirect("admin-citas");
            return;
        }

        boolean actualizado = citaDAO.actualizarEstadoCita(Integer.parseInt(idCita), estadoCita);
        if (actualizado) {
            SessionUtil.guardarFlashSuccess(request, "Estado de la cita actualizado correctamente.");
        } else {
            SessionUtil.guardarFlashError(request, "No se pudo actualizar el estado de la cita.");
        }
        response.sendRedirect("admin-citas");
    }

    private void asignarTecnico(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idCita = request.getParameter("idCita");
        String idTecnicoAsignado = request.getParameter("idTecnicoAsignado");

        if (!InputValidator.esIdPositivo(idCita)) {
            SessionUtil.guardarFlashWarning(request, "No se pudo asignar el tecnico. Verifica la cita seleccionada.");
            response.sendRedirect("admin-citas");
            return;
        }

        Integer tecnicoAsignado = null;
        if (idTecnicoAsignado != null && !idTecnicoAsignado.isBlank() && !"0".equals(idTecnicoAsignado)) {
            if (!InputValidator.esIdPositivo(idTecnicoAsignado)) {
                SessionUtil.guardarFlashWarning(request, "Selecciona un tecnico valido para asignar la cita.");
                response.sendRedirect("admin-citas");
                return;
            }

            Usuario tecnico = usuarioDAO.buscarUsuarioActivoPorId(Integer.parseInt(idTecnicoAsignado));
            if (tecnico == null || !"TECNICO".equalsIgnoreCase(tecnico.getRol())) {
                SessionUtil.guardarFlashWarning(request, "El tecnico seleccionado no esta disponible.");
                response.sendRedirect("admin-citas");
                return;
            }
            tecnicoAsignado = tecnico.getIdUsuario();
        }

        boolean actualizado = citaDAO.actualizarTecnicoAsignado(Integer.parseInt(idCita), tecnicoAsignado);
        if (actualizado) {
            SessionUtil.guardarFlashSuccess(request, tecnicoAsignado == null
                    ? "Tecnico desasignado correctamente."
                    : "Tecnico asignado correctamente.");
        } else {
            SessionUtil.guardarFlashError(request, "No se pudo actualizar la asignacion tecnica.");
        }
        response.sendRedirect("admin-citas");
    }
}
