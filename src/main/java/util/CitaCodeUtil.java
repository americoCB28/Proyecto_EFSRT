package util;

import java.security.SecureRandom;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Base64;

public final class CitaCodeUtil {

    private static final SecureRandom RANDOM = new SecureRandom();
    private static final DateTimeFormatter DATE_FORMAT = DateTimeFormatter.ofPattern("yyyyMMdd");

    private CitaCodeUtil() {
    }

    public static String generarCodigo(int idCita) {
        return "CITA-" + LocalDate.now().format(DATE_FORMAT) + "-" + String.format("%04d", idCita);
    }

    public static String generarToken() {
        byte[] bytes = new byte[24];
        RANDOM.nextBytes(bytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
    }
}
