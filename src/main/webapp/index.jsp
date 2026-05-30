<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Servicio" %>
<%@ page import="util.SessionUtil" %>
<!DOCTYPE html>
<html>
<head>
    <title>Gestion Servicios</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/styles.css" rel="stylesheet">
</head>
<body class="app-body">
<%
    boolean admin = SessionUtil.esAdministrador(request);
    List<Servicio> servicios = (List<Servicio>) request.getAttribute("servicios");
    Servicio servicio = null;
    if (servicios != null && !servicios.isEmpty()) {
        servicio = servicios.get(0);
    }
%>

<nav class="app-topbar">
    <div class="app-topbar-inner">
        <div class="brand-stack">
            <span class="brand-title">Grafica Vehicular</span>
            <span class="brand-subtitle">Servicios, pedidos y seguimiento en un solo lugar</span>
        </div>
        <div class="topbar-actions">
            <a href="inicio" class="app-button app-button-secondary">Inicio</a>
            <% if (admin) { %>
            <a href="servicio?tipo=dashboard" class="app-button app-button-info">Dashboard</a>
            <a href="servicio?tipo=reportes" class="app-button app-button-outline">Reportes</a>
            <a href="logout" class="app-button app-button-outline">Cerrar sesion</a>
            <% } else { %>
            <a href="login" class="app-button app-button-outline">Login Admin</a>
            <% } %>
        </div>
    </div>
</nav>

<main class="app-shell">
    <section class="hero-panel">
        <div class="hero-cover">
            <div class="hero-copy">
                <span class="eyebrow">Experiencia moderna</span>
                <h1 class="hero-title">Selecciona el servicio ideal para tu vehiculo</h1>
                <p class="hero-text">
                    La aplicacion mantiene el flujo actual de pedidos, pero ahora ofrece una navegacion mas clara
                    para clientes y administradores.
                </p>
                <div class="hero-actions">
                    <a href="servicio?tipo=logotipos" class="app-button app-button-success">Ir a Logotipos</a>
                    <a href="servicio?tipo=polarizado" class="app-button app-button-info">Ir a Polarizados</a>
                    <a href="servicio?tipo=instalaciones" class="app-button app-button-warning">Ir a Instalaciones</a>
                </div>
            </div>
        </div>

        <div class="section-block">
            <h2 class="section-title">Servicios disponibles</h2>
            <p class="section-text">Accede al formulario correspondiente y registra tu pedido en pocos pasos.</p>

            <% if (servicio != null) { %>
            <div class="service-grid mt-4">
                <article class="service-card">
                    <div class="service-kicker">Servicio 01</div>
                    <h3 class="service-title">Logotipos</h3>
                    <p class="service-description">Diseno y aplicacion de logotipos vehiculares con opciones rapidas de solicitud.</p>
                    <a href="servicio?tipo=logotipos" class="app-button app-button-success"><%= servicio.getLogotipos() %></a>
                </article>

                <article class="service-card">
                    <div class="service-kicker">Servicio 02</div>
                    <h3 class="service-title">Polarizados</h3>
                    <p class="service-description">Selecciona material y porcentaje de luz visible en un formulario simple y guiado.</p>
                    <a href="servicio?tipo=polarizado" class="app-button app-button-info"><%= servicio.getPolarizado() %></a>
                </article>

                <article class="service-card">
                    <div class="service-kicker">Servicio 03</div>
                    <h3 class="service-title">Instalaciones</h3>
                    <p class="service-description">Registra accesorios e instalaciones automotrices con opciones claras y ordenadas.</p>
                    <a href="servicio?tipo=instalaciones" class="app-button app-button-warning"><%= servicio.getInstalaciones() %></a>
                </article>
            </div>
            <% } %>

            <div class="info-strip">
                <div class="info-item">
                    <strong>Flujo cliente</strong>
                    <div class="muted-text mt-2">Inicio, formulario, confirmacion y regreso rapido al menu principal.</div>
                </div>
                <div class="info-item">
                    <strong>Flujo administrador</strong>
                    <div class="muted-text mt-2">Login, reportes, actualizacion y cierre de sesion visibles desde la cabecera.</div>
                </div>
                <div class="info-item">
                    <strong>Compatibilidad</strong>
                    <div class="muted-text mt-2">La aplicacion sigue siendo ligera y compatible con Maven, Docker y Tomcat 11.</div>
                </div>
            </div>

            <div class="hero-actions">
                <a href="servicio?tipo=reportes" class="app-button app-button-outline">Ver Reportes</a>
            </div>
        </div>
    </section>
</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
