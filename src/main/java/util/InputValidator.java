package util;

import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.Locale;
import java.util.Set;

public final class InputValidator {

    private static final int MAX_NOMBRE = 100;
    private static final Set<String> MATERIALES_VALIDOS = Set.of("nanoCarbono", "nanoCeramico", "Crystalline");
    private static final Set<String> LUCES_VALIDAS = Set.of("5%", "20%", "35%", "50%");
    private static final Set<String> LOGOTIPOS_VALIDOS = Set.of(
            "Placa Provisional",
            "Tapasol",
            "Forrado de faros",
            "Forrado de techo",
            "Forrado de pisaderas",
            "Manijas"
    );
    private static final Set<String> INSTALACIONES_VALIDAS = Set.of(
            "Tapizado de Techo",
            "Tapizado de Piso",
            "Confeccion de Fundas",
            "Instalacion de Radio",
            "Instalacion de GPS"
    );
    private static final Set<String> ESTADOS_PEDIDO_VALIDOS = Set.of(
            "pendiente",
            "en_proceso",
            "terminado",
            "cancelado"
    );
    private static final Set<String> ESTADOS_CITA_VALIDOS = Set.of(
            "pendiente",
            "confirmada",
            "atendida",
            "cancelada",
            "vencida"
    );
    private static final Set<String> TIPOS_CITA_VALIDOS = Set.of(
            "logotipo",
            "polarizado",
            "instalacion"
    );
    private static final Set<String> FRANJAS_VALIDAS = Set.of(
            "09:00 - 10:00",
            "10:00 - 11:00",
            "11:00 - 12:00",
            "15:00 - 16:00",
            "16:00 - 17:00"
    );
    private static final Set<String> CANALES_ENTREGA_CITA_VALIDOS = Set.of(
            "correo",
            "whatsapp",
            "correo+whatsapp",
            "web"
    );
    private static final String USERNAME_REGEX = "^[A-Za-z0-9._-]{3,50}$";
    private static final String EMAIL_REGEX = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$";
    private static final String TELEFONO_REGEX = "^[0-9+\\-\\s]{7,20}$";
    private static final String SLUG_REGEX = "^[a-z0-9-]{3,50}$";

    private InputValidator() {
    }

    public static boolean esNombreValido(String nombre) {
        return nombre != null && !nombre.trim().isEmpty() && nombre.trim().length() <= MAX_NOMBRE;
    }

    public static String normalizarNombre(String nombre) {
        return nombre == null ? null : nombre.trim().replaceAll("\\s+", " ");
    }

    public static boolean esMaterialValido(String material) {
        return MATERIALES_VALIDOS.contains(material);
    }

    public static boolean esLuzVisibleValida(String luzVisible) {
        return LUCES_VALIDAS.contains(luzVisible);
    }

    public static boolean esServicioLogotipoValido(String servicioSeleccionado) {
        return LOGOTIPOS_VALIDOS.contains(servicioSeleccionado);
    }

    public static boolean esServicioInstalacionValido(String servicioSeleccionado) {
        return INSTALACIONES_VALIDAS.contains(servicioSeleccionado);
    }

    public static boolean esEstadoPedidoValido(String estado) {
        return ESTADOS_PEDIDO_VALIDOS.contains(estado);
    }

    public static String normalizarEstadoFiltro(String estado) {
        if (estado == null || estado.isBlank()) {
            return "todos";
        }
        return ESTADOS_PEDIDO_VALIDOS.contains(estado) ? estado : "todos";
    }

    public static boolean esEstadoCitaValido(String estado) {
        return ESTADOS_CITA_VALIDOS.contains(estado);
    }

    public static String normalizarEstadoCitaFiltro(String estado) {
        if (estado == null || estado.isBlank()) {
            return "todos";
        }
        return ESTADOS_CITA_VALIDOS.contains(estado) ? estado : "todos";
    }

    public static boolean esIdPositivo(String valor) {
        try {
            return Integer.parseInt(valor) > 0;
        } catch (NumberFormatException e) {
            return false;
        }
    }

    public static boolean esUsernameValido(String username) {
        return username != null && username.matches(USERNAME_REGEX);
    }

    public static String normalizarUsername(String username) {
        return username == null ? null : username.trim();
    }

    public static boolean esPasswordAdminValida(String password) {
        return password != null && password.length() >= 8;
    }

    public static boolean esRolInternoValido(String rol) {
        return "ADMIN".equalsIgnoreCase(rol) || "TECNICO".equalsIgnoreCase(rol);
    }

    public static String normalizarRolInterno(String rol) {
        if (!esRolInternoValido(rol)) {
            return "ADMIN";
        }
        return rol.toUpperCase(Locale.ROOT);
    }

    public static boolean esTipoCitaValido(String tipoCita) {
        return TIPOS_CITA_VALIDOS.contains(tipoCita);
    }

    public static String normalizarTipoBaseServicio(String tipoBase) {
        return esTipoCitaValido(tipoBase) ? tipoBase : null;
    }

    public static boolean esFranjaHorariaValida(String franja) {
        return FRANJAS_VALIDAS.contains(franja);
    }

    public static boolean esFechaCitaValida(String fecha) {
        if (fecha == null || fecha.isBlank()) {
            return false;
        }
        try {
            LocalDate fechaCita = LocalDate.parse(fecha);
            return !fechaCita.isBefore(LocalDate.now());
        } catch (DateTimeParseException e) {
            return false;
        }
    }

    public static boolean esFechaConsultaValida(String fecha) {
        if (fecha == null || fecha.isBlank()) {
            return false;
        }
        try {
            LocalDate.parse(fecha);
            return true;
        } catch (DateTimeParseException e) {
            return false;
        }
    }

    public static String normalizarFechaConsulta(String fecha) {
        return esFechaConsultaValida(fecha) ? fecha : "";
    }

    public static boolean esCorreoValido(String correo) {
        return correo != null && correo.matches(EMAIL_REGEX);
    }

    public static boolean esTelefonoValido(String telefono) {
        return telefono != null && telefono.matches(TELEFONO_REGEX);
    }

    public static boolean esCanalEntregaCitaValido(String canalEntrega) {
        return CANALES_ENTREGA_CITA_VALIDOS.contains(canalEntrega);
    }

    public static String normalizarCanalEntregaCita(String canalEntrega) {
        if (canalEntrega == null || canalEntrega.isBlank()) {
            return "correo+whatsapp";
        }
        return CANALES_ENTREGA_CITA_VALIDOS.contains(canalEntrega) ? canalEntrega : "correo+whatsapp";
    }

    public static String normalizarTelefonoWhatsapp(String telefono) {
        if (telefono == null) {
            return "";
        }
        return telefono.replaceAll("[^0-9]", "");
    }

    public static boolean esNombreServicioValido(String nombre) {
        return nombre != null && !nombre.isBlank() && nombre.trim().length() <= 100;
    }

    public static String normalizarNombreServicio(String nombre) {
        return nombre == null ? null : nombre.trim().replaceAll("\\s+", " ");
    }

    public static boolean esSlugServicioValido(String slug) {
        return slug != null && slug.matches(SLUG_REGEX);
    }

    public static String normalizarSlugServicio(String slug) {
        if (slug == null) {
            return null;
        }
        return slug.trim().toLowerCase(Locale.ROOT).replaceAll("\\s+", "-");
    }

    public static boolean esDescripcionCortaValida(String descripcion) {
        return descripcion != null && !descripcion.isBlank() && descripcion.trim().length() <= 180;
    }

    public static String normalizarDescripcionCorta(String descripcion) {
        return descripcion == null ? null : descripcion.trim().replaceAll("\\s+", " ");
    }

    public static boolean esPrecioBaseValido(String valor) {
        try {
            return Double.parseDouble(valor) >= 0.0;
        } catch (Exception e) {
            return false;
        }
    }

    public static boolean esDuracionMinutosValida(String valor) {
        try {
            int minutos = Integer.parseInt(valor);
            return minutos >= 15 && minutos <= 480;
        } catch (Exception e) {
            return false;
        }
    }

    public static boolean esOrdenVisualValido(String valor) {
        try {
            int orden = Integer.parseInt(valor);
            return orden >= 1 && orden <= 999;
        } catch (Exception e) {
            return false;
        }
    }
}
