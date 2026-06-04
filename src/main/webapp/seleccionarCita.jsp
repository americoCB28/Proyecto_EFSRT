<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.CatalogoServicio" %>
<%@ page import="util.SessionUtil" %>
<!DOCTYPE html>
<html>
<head>
    <title>Agenda tu cita</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/styles.css" rel="stylesheet">
</head>
<body class="app-body">
<%
    boolean admin = SessionUtil.esAdministrador(request);
    List<CatalogoServicio> catalogoServicios = (List<CatalogoServicio>) request.getAttribute("catalogoServicios");
%>

<nav class="app-topbar">
    <div class="app-topbar-inner">
        <div class="brand-stack">
            <span class="brand-title">Agendamiento de Citas</span>
            <span class="brand-subtitle">Elige el servicio que deseas realizar a tu vehiculo</span>
        </div>
        <div class="topbar-actions">
            <a href="inicio" class="app-button app-button-secondary">Inicio</a>
            <% if (admin) { %>
            <a href="servicio?tipo=dashboard" class="app-button app-button-info">Dashboard</a>
            <a href="logout" class="app-button app-button-outline">Cerrar sesion</a>
            <% } %>
        </div>
    </div>
</nav>

<main class="app-shell page-section">
    <section class="section-hero">
        <span class="eyebrow">Paso 1 de 3</span>
        <h1 class="form-title mt-3">Reserva tu cita de servicio</h1>
        <p class="form-subtitle">Selecciona la categoria que mejor se ajuste a tu necesidad. En los siguientes pasos definiras el detalle y el horario preferido.</p>
    </section>

    <section class="table-card">
        <div class="service-grid">
            <% if (catalogoServicios != null && !catalogoServicios.isEmpty()) {
                int indice = 1;
                for (CatalogoServicio servicio : catalogoServicios) { %>
            <article class="service-card">
                <div class="service-kicker">Cita <%= indice++ %></div>
                <h3 class="service-title"><%= servicio.getNombre() %></h3>
                <p class="service-description"><%= servicio.getDescripcionCorta() %></p>
                <div class="service-meta mb-3">
                    <span>Desde S/ <%= String.format(java.util.Locale.US, "%.2f", servicio.getPrecioBase()) %></span>
                    <span><%= servicio.getDuracionMinutos() %> min</span>
                </div>
                <a href="citas?paso=detalle&idCatalogoServicio=<%= servicio.getIdCatalogoServicio() %>" class="app-button app-button-primary">Elegir servicio</a>
            </article>
            <% }
            } else { %>
            <article class="service-card">
                <h3 class="service-title">No hay servicios disponibles</h3>
                <p class="service-description">El catalogo de servicios no tiene registros activos para citas en este momento.</p>
                <% if (admin) { %>
                <a href="servicios-admin" class="app-button app-button-info">Gestionar catalogo</a>
                <% } %>
            </article>
            <% } %>
        </div>
    </section>
</main>
</body>
</html>
