package util;

import model.Cita;

public final class PriceEstimatorUtil {

    private PriceEstimatorUtil() {
    }

    public static double estimar(Cita cita) {
        if (cita == null || cita.getTipoServicio() == null) {
            return 0.0;
        }

        return switch (cita.getTipoServicio()) {
            case "polarizado" -> estimarPolarizado(cita.getMaterial(), cita.getLuzVisible());
            case "logotipo" -> estimarLogotipo(cita.getServicioSeleccionado());
            case "instalacion" -> estimarInstalacion(cita.getServicioSeleccionado());
            default -> 0.0;
        };
    }

    private static double estimarPolarizado(String material, String luzVisible) {
        double base = switch (material) {
            case "nanoCarbono" -> 450.0;
            case "nanoCeramico" -> 620.0;
            case "Crystalline" -> 880.0;
            default -> 0.0;
        };
        double ajuste = switch (luzVisible) {
            case "5%" -> 90.0;
            case "20%" -> 60.0;
            case "35%" -> 30.0;
            case "50%" -> 0.0;
            default -> 0.0;
        };
        return base + ajuste;
    }

    private static double estimarLogotipo(String servicioSeleccionado) {
        return switch (servicioSeleccionado) {
            case "Placa Provisional" -> 80.0;
            case "Tapasol" -> 140.0;
            case "Forrado de faros" -> 220.0;
            case "Forrado de techo" -> 420.0;
            case "Forrado de pisaderas" -> 180.0;
            case "Manijas" -> 120.0;
            default -> 0.0;
        };
    }

    private static double estimarInstalacion(String servicioSeleccionado) {
        return switch (servicioSeleccionado) {
            case "Tapizado de Techo" -> 550.0;
            case "Tapizado de Piso" -> 380.0;
            case "Confeccion de Fundas" -> 690.0;
            case "Instalacion de Radio" -> 260.0;
            case "Instalacion de GPS" -> 320.0;
            default -> 0.0;
        };
    }
}
