<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Cita" %>
<!DOCTYPE html>
<html>
<head>
    <title>Horario de la cita</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/styles.css" rel="stylesheet">
</head>
<body class="app-body">
<%
    String error = (String) request.getAttribute("error");
    Cita citaDraft = (Cita) request.getAttribute("citaDraft");
%>

<nav class="app-topbar">
    <div class="app-topbar-inner">
        <div class="brand-stack">
            <span class="brand-title">Horario Preferido</span>
            <span class="brand-subtitle">Selecciona una fecha y franja de atencion para llevar tu vehiculo</span>
        </div>
        <div class="topbar-actions">
            <a href="citas?paso=detalle&servicio=<%= citaDraft.getTipoServicio() %>" class="app-button app-button-secondary">Volver al detalle</a>
            <a href="inicio" class="app-button app-button-outline">Cancelar</a>
        </div>
    </div>
</nav>

<main class="form-shell">
    <div class="step-progress" aria-label="Progreso de reserva">
        <div class="step-item"><span class="step-number">Paso 1</span><span class="step-label">Servicio</span></div>
        <div class="step-item"><span class="step-number">Paso 2</span><span class="step-label">Detalles</span></div>
        <div class="step-item step-item-active"><span class="step-number">Paso 3</span><span class="step-label">Horario</span></div>
        <div class="step-item"><span class="step-number">Paso 4</span><span class="step-label">Datos</span></div>
        <div class="step-item"><span class="step-number">Paso 5</span><span class="step-label">Confirmacion</span></div>
    </div>

    <section class="section-hero">
        <span class="eyebrow">Paso 3 de 5</span>
        <h1 class="form-title mt-3">Elige tu horario preferido</h1>
        <p class="form-subtitle">Selecciona una fecha y horario preferido; el taller podra confirmar o ajustar si es necesario.</p>
    </section>

    <section class="form-card content-panel">
        <% if (error != null && !error.isBlank()) { %>
        <div class="app-alert alert alert-danger" role="alert"><%= error %></div>
        <% } %>

        <div class="detail-grid mb-4">
            <article class="detail-card">
                <div class="detail-label">Servicio</div>
                <div class="detail-value"><%= citaDraft.getTipoServicio() %></div>
            </article>
            <article class="detail-card">
                <div class="detail-label">Detalle</div>
                <div class="detail-value"><%= citaDraft.getDetalleServicio() %></div>
            </article>
        </div>

        <form action="citas" method="post">
            <input type="hidden" name="accion" value="horario">

            <div class="form-helper-card mb-4">
                Tu cita todavia no esta registrada. Despues de elegir horario revisaras el resumen, dejaras tus datos y confirmaras la reserva.
            </div>

            <div class="mb-4">
                <label for="fechaCita" class="form-label">Fecha preferida</label>
                <input type="date" id="fechaCita" name="fechaCita" class="form-control app-field"
                       value="<%= citaDraft.getFechaCita() == null ? "" : citaDraft.getFechaCita() %>" required>
            </div>

            <div class="mb-4">
                <label class="form-label">Franja horaria</label>
                <div class="choice-grid">
                    <%
                        String[] franjas = {"09:00 - 10:00", "10:00 - 11:00", "11:00 - 12:00", "15:00 - 16:00", "16:00 - 17:00"};
                        for (int i = 0; i < franjas.length; i++) {
                            String franja = franjas[i];
                    %>
                    <div>
                        <input type="radio" class="btn-check" name="franjaHoraria" id="franja<%= i %>" value="<%= franja %>"
                               <%= franja.equals(citaDraft.getFranjaHoraria()) ? "checked" : "" %> <%= i == 0 ? "required" : "" %>>
                        <label class="choice-card" for="franja<%= i %>">
                            <div class="choice-title"><%= franja %></div>
                            <div class="choice-caption">Franja preferida de atencion.</div>
                        </label>
                    </div>
                    <% } %>
                </div>
            </div>

            <div class="stack-actions">
                <button type="submit" class="app-button app-button-primary">Ver resumen preliminar</button>
                <a href="citas?paso=detalle&servicio=<%= citaDraft.getTipoServicio() %>" class="app-button app-button-secondary">Volver</a>
            </div>
        </form>
    </section>
</main>
</body>
</html>
