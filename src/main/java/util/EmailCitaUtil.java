package util;

import jakarta.activation.DataHandler;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeBodyPart;
import jakarta.mail.internet.MimeMessage;
import jakarta.mail.internet.MimeMultipart;
import jakarta.mail.util.ByteArrayDataSource;
import model.Cita;

import java.util.Properties;

public final class EmailCitaUtil {

    public record ResultadoEnvio(boolean enviado, String mensaje) {}

    private EmailCitaUtil() {
    }

    public static ResultadoEnvio enviarConfirmacion(Cita cita, byte[] pdfBytes) {
        String host = obtenerConfig("SMTP_HOST");
        String port = obtenerConfig("SMTP_PORT");
        String username = obtenerConfig("SMTP_USER");
        String password = obtenerConfig("SMTP_PASSWORD");
        String from = obtenerConfig("SMTP_FROM");

        if (host == null || port == null || username == null || password == null || from == null) {
            return new ResultadoEnvio(false, "El envio por correo no esta configurado en el entorno actual.");
        }

        try {
            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.host", host);
            props.put("mail.smtp.port", port);

            Session session = Session.getInstance(props, new jakarta.mail.Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(username, password);
                }
            });

            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(from));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(cita.getCorreoCliente()));
            message.setSubject("Confirmacion de cita " + cita.getCodigoVerificacion());

            MimeBodyPart textPart = new MimeBodyPart();
            textPart.setText(construirMensaje(cita), "UTF-8");

            MimeBodyPart attachmentPart = new MimeBodyPart();
            attachmentPart.setFileName("cita_" + cita.getCodigoVerificacion() + ".pdf");
            attachmentPart.setDataHandler(new DataHandler(new ByteArrayDataSource(pdfBytes, "application/pdf")));

            MimeMultipart multipart = new MimeMultipart();
            multipart.addBodyPart(textPart);
            multipart.addBodyPart(attachmentPart);
            message.setContent(multipart);

            Transport.send(message);
            return new ResultadoEnvio(true, "Se envio la constancia de la cita al correo registrado.");
        } catch (MessagingException e) {
            return new ResultadoEnvio(false, "La cita se registro, pero el correo no pudo enviarse.");
        }
    }

    private static String construirMensaje(Cita cita) {
        return """
                Hola %s,

                Tu cita fue registrada correctamente.

                Codigo: %s
                Servicio: %s
                Fecha: %s
                Horario: %s
                Estado: %s
                Precio estimado: S/ %.2f

                Adjuntamos tu constancia en PDF.
                """
                .formatted(
                        cita.getNombreCliente(),
                        cita.getCodigoVerificacion(),
                        cita.getTipoServicio(),
                        cita.getFechaCita(),
                        cita.getFranjaHoraria(),
                        cita.getEstadoCita(),
                        cita.getPrecioEstimado()
                );
    }

    private static String obtenerConfig(String key) {
        String value = System.getenv(key);
        if (value == null || value.isBlank()) {
            value = System.getProperty(key);
        }
        return (value == null || value.isBlank()) ? null : value.trim();
    }
}
