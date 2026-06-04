package util;

import com.lowagie.text.Document;
import com.lowagie.text.DocumentException;
import com.lowagie.text.Font;
import com.lowagie.text.FontFactory;
import com.lowagie.text.Image;
import com.lowagie.text.Paragraph;
import com.lowagie.text.Phrase;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;
import model.Cita;

import java.awt.Color;
import java.io.ByteArrayOutputStream;
import java.nio.charset.StandardCharsets;
import java.util.Locale;

public final class PdfCitaUtil {

    private PdfCitaUtil() {
    }

    public static byte[] generarPdf(Cita cita, String urlVerificacion) throws Exception {
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        Document document = new Document();
        PdfWriter.getInstance(document, outputStream);
        document.open();

        Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 20, Color.BLACK);
        Font subtitleFont = FontFactory.getFont(FontFactory.HELVETICA, 11, new Color(70, 85, 105));
        Font labelFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10, Color.BLACK);
        Font valueFont = FontFactory.getFont(FontFactory.HELVETICA, 11, Color.BLACK);

        document.add(new Paragraph("Constancia de cita vehicular", titleFont));
        document.add(new Paragraph("Presenta este documento o el codigo de verificacion al llegar al local.", subtitleFont));
        document.add(new Paragraph(" "));

        PdfPTable table = new PdfPTable(2);
        table.setWidthPercentage(100);
        table.setSpacingBefore(8f);
        table.setSpacingAfter(16f);
        table.setWidths(new float[]{1.2f, 2.8f});

        agregarFila(table, "Codigo", cita.getCodigoVerificacion(), labelFont, valueFont);
        agregarFila(table, "Cliente", cita.getNombreCliente(), labelFont, valueFont);
        agregarFila(table, "Correo", cita.getCorreoCliente(), labelFont, valueFont);
        agregarFila(table, "Telefono", cita.getTelefonoCliente(), labelFont, valueFont);
        agregarFila(table, "Servicio", capitalizar(cita.getTipoServicio()), labelFont, valueFont);
        agregarFila(table, "Detalle", cita.getDetalleServicio(), labelFont, valueFont);
        agregarFila(table, "Fecha", cita.getFechaCita(), labelFont, valueFont);
        agregarFila(table, "Horario", cita.getFranjaHoraria(), labelFont, valueFont);
        agregarFila(table, "Estado", cita.getEstadoCita(), labelFont, valueFont);
        agregarFila(table, "Precio estimado", "S/ " + String.format(Locale.US, "%.2f", cita.getPrecioEstimado()), labelFont, valueFont);
        agregarFila(table, "Observaciones", valorSeguro(cita.getObservaciones()), labelFont, valueFont);
        document.add(table);

        byte[] qrBytes = QrCitaUtil.generarQrPng(urlVerificacion, 240, 240);
        Image qr = Image.getInstance(qrBytes);
        qr.scaleToFit(180f, 180f);
        qr.setAlignment(Image.ALIGN_CENTER);
        document.add(qr);
        document.add(new Paragraph("Verificacion segura: " + urlVerificacion, subtitleFont));
        document.add(new Paragraph(" "));
        document.add(new Paragraph("Documento generado automaticamente por el sistema.", subtitleFont));

        document.close();
        return outputStream.toByteArray();
    }

    private static void agregarFila(PdfPTable table, String etiqueta, String valor, Font labelFont, Font valueFont)
            throws DocumentException {
        PdfPCell labelCell = new PdfPCell(new Phrase(etiqueta, labelFont));
        labelCell.setPadding(8f);
        labelCell.setBackgroundColor(new Color(241, 245, 249));
        labelCell.setBorderColor(new Color(203, 213, 225));
        table.addCell(labelCell);

        PdfPCell valueCell = new PdfPCell(new Phrase(valorSeguro(valor), valueFont));
        valueCell.setPadding(8f);
        valueCell.setBorderColor(new Color(203, 213, 225));
        table.addCell(valueCell);
    }

    private static String valorSeguro(String valor) {
        if (valor == null || valor.isBlank()) {
            return "No especificado";
        }
        return new String(valor.getBytes(StandardCharsets.UTF_8), StandardCharsets.UTF_8);
    }

    private static String capitalizar(String valor) {
        if (valor == null || valor.isBlank()) {
            return "";
        }
        return valor.substring(0, 1).toUpperCase(Locale.ROOT) + valor.substring(1);
    }
}
