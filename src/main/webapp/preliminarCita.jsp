<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Cita" %>
<!DOCTYPE html>
<html>
<head>
    <title>Resumen final de cita</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/styles.css" rel="stylesheet">
</head>
<body class="app-body">
<%
    Cita citaDraft = (Cita) request.getAttribute("citaDraft");
    String error = (String) request.getAttribute("error");
%>

<nav class="app-topbar">
    <div class="app-topbar-inner">
        <div class="brand-stack">
            <span class="brand-title">Resumen Final de la Cita</span>
            <span class="brand-subtitle">Confirma tus datos antes de registrar la atencion para tu vehiculo</span>
        </div>
        <div class="topbar-actions">
            <a href="citas?paso=horario" class="app-button app-button-secondary">Editar horario</a>
            <a href="inicio" class="app-button app-button-outline">Cancelar</a>
        </div>
    </div>
</nav>

<main class="form-shell">
    <div class="step-progress" aria-label="Progreso de reserva">
        <div class="step-item"><span class="step-number">Paso 1</span><span class="step-label">Servicio</span></div>
        <div class="step-item"><span class="step-number">Paso 2</span><span class="step-label">Detalles</span></div>
        <div class="step-item"><span class="step-number">Paso 3</span><span class="step-label">Horario</span></div>
        <div class="step-item step-item-active"><span class="step-number">Paso 4</span><span class="step-label">Datos</span></div>
        <div class="step-item"><span class="step-number">Paso 5</span><span class="step-label">Confirmacion</span></div>
    </div>

    <section class="section-hero">
        <span class="eyebrow">Paso 4 de 5</span>
        <h1 class="form-title mt-3">Precio estimado y datos del cliente</h1>
        <p class="form-subtitle">Revisa el servicio elegido, el horario preferido y deja tus datos para confirmar la cita.</p>
    </section>

    <section class="form-card content-panel">
        <% if (error != null && !error.isBlank()) { %>
        <div class="app-alert alert alert-danger" role="alert"><%= error %></div>
        <% } %>

        <div class="summary-section">
            <h3 class="summary-section-title">Datos del servicio</h3>
            <div class="detail-grid">
            <article class="detail-card">
                <div class="detail-label">Servicio</div>
                <div class="detail-value"><%= citaDraft.getNombreCatalogoServicio() == null || citaDraft.getNombreCatalogoServicio().isBlank() ? citaDraft.getTipoServicio() : citaDraft.getNombreCatalogoServicio() %></div>
            </article>
            <article class="detail-card">
                <div class="detail-label">Detalle</div>
                <div class="detail-value"><%= citaDraft.getDetalleServicio() %></div>
            </article>
            <article class="detail-card">
                <div class="detail-label">Precio estimado</div>
                <div class="detail-value">S/ <%= String.format(java.util.Locale.US, "%.2f", citaDraft.getPrecioEstimado()) %></div>
            </article>
            </div>
        </div>

        <div class="summary-section">
            <h3 class="summary-section-title">Datos de la cita</h3>
            <div class="detail-grid">
            <article class="detail-card">
                <div class="detail-label">Fecha</div>
                <div class="detail-value"><%= citaDraft.getFechaCita() %></div>
            </article>
            <article class="detail-card">
                <div class="detail-label">Horario</div>
                <div class="detail-value"><%= citaDraft.getFranjaHoraria() %></div>
            </article>
            <article class="detail-card">
                <div class="detail-label">Estado inicial</div>
                <div class="detail-value"><%= citaDraft.getEstadoCita() %></div>
            </article>
            </div>
        </div>

        <form action="citas" method="post">
            <input type="hidden" name="accion" value="confirmar">

            <div class="summary-section">
                <h3 class="summary-section-title">Datos del cliente</h3>
            </div>

            <div class="mb-4">
                <label for="nombreCliente" class="form-label">Nombre completo</label>
                <input type="text" id="nombreCliente" name="nombreCliente" class="form-control app-field"
                       value="<%= citaDraft.getNombreCliente() == null ? "" : citaDraft.getNombreCliente() %>"
                       placeholder="Ingresa tu nombre completo" required>
            </div>

            <div class="mb-4">
                <label for="correoCliente" class="form-label">Correo electronico</label>
                <input type="email" id="correoCliente" name="correoCliente" class="form-control app-field"
                       value="<%= citaDraft.getCorreoCliente() == null ? "" : citaDraft.getCorreoCliente() %>"
                       placeholder="correo@dominio.com" required>
            </div>

            <div class="mb-4">
                <label for="telefonoCliente" class="form-label">Telefono</label>
                <input type="text" id="telefonoCliente" name="telefonoCliente" class="form-control app-field"
                       value="<%= citaDraft.getTelefonoCliente() == null ? "" : citaDraft.getTelefonoCliente() %>"
                       placeholder="999 999 999" required>
            </div>

            <div class="mb-4">
                <label for="observaciones" class="form-label">Observaciones adicionales</label>
                <textarea id="observaciones" name="observaciones" class="form-control app-field" rows="3"
                          placeholder="Ejemplo: vehiculo camioneta blanca, confirmar una hora antes"><%= citaDraft.getObservaciones() == null ? "" : citaDraft.getObservaciones() %></textarea>
            </div>

            <div class="mb-4">
                <label for="canalEntrega" class="form-label">Canal de entrega de la constancia</label>
                <select id="canalEntrega" name="canalEntrega" class="form-select app-field">
                    <option value="correo+whatsapp" <%= "correo+whatsapp".equals(citaDraft.getCanalEntrega()) || citaDraft.getCanalEntrega() == null ? "selected" : "" %>>Correo + WhatsApp</option>
                    <option value="correo" <%= "correo".equals(citaDraft.getCanalEntrega()) ? "selected" : "" %>>Solo correo</option>
                    <option value="whatsapp" <%= "whatsapp".equals(citaDraft.getCanalEntrega()) ? "selected" : "" %>>Solo WhatsApp</option>
                    <option value="web" <%= "web".equals(citaDraft.getCanalEntrega()) ? "selected" : "" %>>Solo descarga web</option>
                </select>
                <div class="page-footer-note">WhatsApp automatico se envia mediante n8n y Evolution si el entorno ya esta configurado.</div>
            </div>

            <div class="form-helper-card mb-4">
                El precio mostrado es referencial. El equipo confirmara el monto final luego de revisar el vehiculo y el alcance del trabajo.
            </div>

            <div class="stack-actions">
                <button type="submit" class="app-button app-button-primary">Confirmar y guardar cita</button>
                <a href="citas?paso=horario" class="app-button app-button-secondary">Volver</a>
            </div>

        </form>
    </section>
</main>
</body>
</html>
