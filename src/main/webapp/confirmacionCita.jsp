<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Cita" %>
<!DOCTYPE html>
<html>
<head>
    <title>Cita confirmada</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/styles.css" rel="stylesheet">
</head>
<body class="app-body">
<%
    Cita citaConfirmada = (Cita) request.getAttribute("citaConfirmada");
    String flashSuccess = (String) request.getAttribute("flashSuccess");
    String flashWarning = (String) request.getAttribute("flashWarning");
    String flashError = (String) request.getAttribute("flashError");
%>

<nav class="app-topbar">
    <div class="app-topbar-inner">
        <div class="brand-stack">
            <span class="brand-title">Cita Confirmada</span>
            <span class="brand-subtitle">Ya puedes presentar este codigo y QR al llegar al local</span>
        </div>
        <div class="topbar-actions">
            <a href="citas" class="app-button app-button-secondary">Nueva cita</a>
            <a href="inicio" class="app-button app-button-outline">Volver al inicio</a>
        </div>
    </div>
</nav>

<main class="confirm-shell">
    <section class="confirm-card content-panel">
        <div class="confirm-badge">Cita registrada</div>
        <h1 class="confirm-title">Tu cita fue guardada correctamente</h1>
        <p class="confirm-text">Conserva este codigo de verificacion y el QR. La administracion podra validar tu llegada escaneandolo directamente.</p>

        <div class="flash-wrap text-start">
            <% if (flashSuccess != null && !flashSuccess.isBlank()) { %>
            <div class="app-alert alert alert-success" role="alert"><%= flashSuccess %></div>
            <% } %>
            <% if (flashWarning != null && !flashWarning.isBlank()) { %>
            <div class="app-alert alert alert-warning" role="alert"><%= flashWarning %></div>
            <% } %>
            <% if (flashError != null && !flashError.isBlank()) { %>
            <div class="app-alert alert alert-danger" role="alert"><%= flashError %></div>
            <% } %>
        </div>

        <div class="detail-grid text-start">
            <article class="detail-card">
                <div class="detail-label">Codigo</div>
                <div class="detail-value"><%= citaConfirmada.getCodigoVerificacion() %></div>
            </article>
            <article class="detail-card">
                <div class="detail-label">Cliente</div>
                <div class="detail-value"><%= citaConfirmada.getNombreCliente() %></div>
            </article>
            <article class="detail-card">
                <div class="detail-label">Servicio</div>
                <div class="detail-value"><%= citaConfirmada.getNombreCatalogoServicio() == null || citaConfirmada.getNombreCatalogoServicio().isBlank() ? citaConfirmada.getTipoServicio() : citaConfirmada.getNombreCatalogoServicio() %></div>
            </article>
            <article class="detail-card">
                <div class="detail-label">Fecha y horario</div>
                <div class="detail-value"><%= citaConfirmada.getFechaCita() %> | <%= citaConfirmada.getFranjaHoraria() %></div>
            </article>
            <article class="detail-card">
                <div class="detail-label">Precio estimado</div>
                <div class="detail-value">S/ <%= String.format(java.util.Locale.US, "%.2f", citaConfirmada.getPrecioEstimado()) %></div>
            </article>
            <article class="detail-card">
                <div class="detail-label">Estado</div>
                <div class="detail-value"><span class="status-pill status-<%= citaConfirmada.getEstadoCita() %>"><%= citaConfirmada.getEstadoCita() %></span></div>
            </article>
            <article class="detail-card">
                <div class="detail-label">Entrega</div>
                <div class="detail-value"><%= citaConfirmada.getCanalEntrega() == null || citaConfirmada.getCanalEntrega().isBlank() ? "web" : citaConfirmada.getCanalEntrega() %></div>
            </article>
        </div>

        <div class="qr-panel mt-4">
            <img src="qr-cita?token=<%= citaConfirmada.getTokenVerificacion() %>" alt="QR de la cita" class="qr-image">
            <p class="page-footer-note">Si la administracion escanea este QR, abrira la validacion protegida de la cita.</p>
        </div>

        <div class="stack-actions justify-content-center">
            <a href="cita-pdf?token=<%= citaConfirmada.getTokenVerificacion() %>" class="app-button app-button-info">Descargar PDF</a>
            <% if (citaConfirmada.getWhatsappUrl() != null && !citaConfirmada.getWhatsappUrl().isBlank()) { %>
            <a href="<%= citaConfirmada.getWhatsappUrl() %>" target="_blank" rel="noopener noreferrer" class="app-button app-button-success">Abrir WhatsApp</a>
            <% } %>
            <a href="citas" class="app-button app-button-primary">Agendar otra cita</a>
            <a href="inicio" class="app-button app-button-secondary">Finalizar</a>
        </div>
    </section>
</main>
</body>
</html>
