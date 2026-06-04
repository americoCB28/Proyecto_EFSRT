package util;

import model.Cita;

import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.time.Duration;

public final class WhatsAppCitaUtil {

    public record ResultadoEnvio(boolean enviado, String mensaje, String enlaceManual) {}

    private WhatsAppCitaUtil() {
    }

    public static ResultadoEnvio enviarConfirmacion(Cita cita, String baseUrl) {
        String webhookUrl = obtenerConfig("N8N_WHATSAPP_WEBHOOK_URL");
        String webhookToken = obtenerConfig("N8N_WHATSAPP_TOKEN");
        String telefonoNormalizado = InputValidator.normalizarTelefonoWhatsapp(cita.getTelefonoCliente());
        String enlaceManual = construirEnlaceManual(cita, telefonoNormalizado);
        String urlBasePublica = obtenerConfig("PUBLIC_BASE_URL");
        String urlBaseInterna = obtenerConfig("APP_INTERNAL_URL");

        if (urlBasePublica == null || urlBasePublica.isBlank()) {
            urlBasePublica = baseUrl;
        }
        if (urlBaseInterna == null || urlBaseInterna.isBlank()) {
            urlBaseInterna = baseUrl;
        }

        if (telefonoNormalizado.isBlank()) {
            return new ResultadoEnvio(false, "La cita se registro, pero el telefono no es valido para WhatsApp.", null);
        }

        if (webhookUrl == null || webhookUrl.isBlank()) {
            return new ResultadoEnvio(false, "WhatsApp automatico no esta configurado. Puedes usar el enlace manual.", enlaceManual);
        }

        try {
            String verificacionUrlPublica = QrCitaUtil.construirUrlVerificacion(urlBasePublica, cita.getTokenVerificacion());
            String verificacionUrlInterna = QrCitaUtil.construirUrlVerificacion(urlBaseInterna, cita.getTokenVerificacion());
            String qrUrlPublica = urlBasePublica + "/qr-cita?token=" + cita.getTokenVerificacion();
            String qrUrlInterna = urlBaseInterna + "/qr-cita?token=" + cita.getTokenVerificacion();
            String pdfUrlPublica = urlBasePublica + "/cita-pdf?token=" + cita.getTokenVerificacion();
            String pdfUrlInterna = urlBaseInterna + "/cita-pdf?token=" + cita.getTokenVerificacion();
            String payload = construirPayload(
                    cita,
                    telefonoNormalizado,
                    verificacionUrlPublica,
                    verificacionUrlInterna,
                    qrUrlPublica,
                    qrUrlInterna,
                    pdfUrlPublica,
                    pdfUrlInterna,
                    enlaceManual
            );

            HttpRequest.Builder builder = HttpRequest.newBuilder()
                    .uri(URI.create(webhookUrl))
                    .timeout(Duration.ofSeconds(12))
                    .header("Content-Type", "application/json; charset=UTF-8")
                    .POST(HttpRequest.BodyPublishers.ofString(payload, StandardCharsets.UTF_8));

            if (webhookToken != null && !webhookToken.isBlank()) {
                builder.header("Authorization", "Bearer " + webhookToken);
            }

            HttpClient client = HttpClient.newHttpClient();
            HttpResponse<String> response = client.send(builder.build(), HttpResponse.BodyHandlers.ofString(StandardCharsets.UTF_8));
            if (response.statusCode() >= 200 && response.statusCode() < 300) {
                return new ResultadoEnvio(true, "Se envio la confirmacion por WhatsApp mediante n8n.", enlaceManual);
            }

            return new ResultadoEnvio(false, "La cita se registro, pero n8n no confirmo el envio de WhatsApp.", enlaceManual);
        } catch (Exception e) {
            return new ResultadoEnvio(false, "La cita se registro, pero el envio automatico a WhatsApp fallo.", enlaceManual);
        }
    }

    private static String construirPayload(Cita cita, String telefonoNormalizado,
                                           String verificacionUrlPublica, String verificacionUrlInterna,
                                           String qrUrlPublica, String qrUrlInterna,
                                           String pdfUrlPublica, String pdfUrlInterna,
                                           String enlaceManual) {
        return """
                {
                  "source":"Proyecto_EFSRT",
                  "codigo":"%s",
                  "token":"%s",
                  "cliente":"%s",
                  "telefono":"%s",
                  "correo":"%s",
                  "servicio":"%s",
                  "detalle":"%s",
                  "fecha":"%s",
                  "franja":"%s",
                  "estado":"%s",
                  "precioEstimado":"%s",
                  "observaciones":"%s",
                  "canalEntrega":"%s",
                  "verificacionUrl":"%s",
                  "verificacionUrlPublica":"%s",
                  "verificacionUrlInterna":"%s",
                  "qrUrl":"%s",
                  "qrUrlPublica":"%s",
                  "qrUrlInterna":"%s",
                  "pdfUrl":"%s",
                  "pdfUrlPublica":"%s",
                  "pdfUrlInterna":"%s",
                  "whatsappManualUrl":"%s"
                }
                """
                .formatted(
                        escapeJson(cita.getCodigoVerificacion()),
                        escapeJson(cita.getTokenVerificacion()),
                        escapeJson(cita.getNombreCliente()),
                        escapeJson(telefonoNormalizado),
                        escapeJson(cita.getCorreoCliente()),
                        escapeJson(cita.getTipoServicio()),
                        escapeJson(cita.getDetalleServicio()),
                        escapeJson(cita.getFechaCita()),
                        escapeJson(cita.getFranjaHoraria()),
                        escapeJson(cita.getEstadoCita()),
                        cita.getPrecioEstimado() == null ? "" : String.format(java.util.Locale.US, "%.2f", cita.getPrecioEstimado()),
                        escapeJson(cita.getObservaciones()),
                        escapeJson(cita.getCanalEntrega()),
                        escapeJson(verificacionUrlPublica),
                        escapeJson(verificacionUrlPublica),
                        escapeJson(verificacionUrlInterna),
                        escapeJson(qrUrlPublica),
                        escapeJson(qrUrlPublica),
                        escapeJson(qrUrlInterna),
                        escapeJson(pdfUrlPublica),
                        escapeJson(pdfUrlPublica),
                        escapeJson(pdfUrlInterna),
                        escapeJson(enlaceManual)
                );
    }

    private static String construirEnlaceManual(Cita cita, String telefonoNormalizado) {
        if (telefonoNormalizado == null || telefonoNormalizado.isBlank()) {
            return null;
        }
        String mensaje = """
                Hola %s, tu cita fue registrada.
                Codigo: %s
                Servicio: %s
                Fecha: %s
                Horario: %s
                Precio estimado: S/ %.2f
                """
                .formatted(
                        cita.getNombreCliente(),
                        cita.getCodigoVerificacion(),
                        cita.getTipoServicio(),
                        cita.getFechaCita(),
                        cita.getFranjaHoraria(),
                        cita.getPrecioEstimado() == null ? 0.0 : cita.getPrecioEstimado()
                );
        return "https://wa.me/" + telefonoNormalizado + "?text="
                + URLEncoder.encode(mensaje, StandardCharsets.UTF_8);
    }

    private static String obtenerConfig(String key) {
        String value = System.getenv(key);
        if (value == null || value.isBlank()) {
            value = System.getProperty(key);
        }
        return (value == null || value.isBlank()) ? null : value.trim();
    }

    private static String escapeJson(String valor) {
        if (valor == null) {
            return "";
        }
        return valor
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\r", " ")
                .replace("\n", " ");
    }
}
