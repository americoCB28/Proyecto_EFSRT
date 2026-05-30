package util;

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
    private static final Set<String> ESTADOS_VALIDOS = Set.of(
            "pendiente",
            "en_proceso",
            "terminado",
            "cancelado"
    );

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
        return ESTADOS_VALIDOS.contains(estado);
    }

    public static String normalizarEstadoFiltro(String estado) {
        if (estado == null || estado.isBlank()) {
            return "todos";
        }
        return ESTADOS_VALIDOS.contains(estado) ? estado : "todos";
    }

    public static boolean esIdPositivo(String valor) {
        try {
            return Integer.parseInt(valor) > 0;
        } catch (NumberFormatException e) {
            return false;
        }
    }
}
