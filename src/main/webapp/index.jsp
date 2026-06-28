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
    boolean tecnico = SessionUtil.esTecnico(request);
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
            <span class="brand-subtitle">Agenda tu cita y prepara la atencion de tu vehiculo</span>
        </div>
        <div class="topbar-actions">
            <a href="inicio" class="app-button app-button-secondary">Inicio</a>
            <% if (admin) { %>
            <a href="servicio?tipo=dashboard" class="app-button app-button-info">Dashboard</a>
            <a href="admin-citas" class="app-button app-button-info">Agenda</a>
            <a href="servicio?tipo=reportes" class="app-button app-button-info">Atenciones</a>
            <a href="servicios-admin" class="app-button app-button-info">Servicios</a>
            <a href="usuarios" class="app-button app-button-info">Usuarios</a>
            <a href="logout" class="app-button app-button-outline">Cerrar sesion</a>
            <% } else if (tecnico) { %>
            <a href="tecnico" class="app-button app-button-info">Panel tecnico</a>
            <a href="logout" class="app-button app-button-outline">Cerrar sesion</a>
            <% } else { %>
            <a href="login" class="app-button app-button-outline">Acceso interno</a>
            <% } %>
        </div>
    </div>
</nav>

<main class="app-shell">
    <section class="hero-panel">
        <div class="hero-cover">
            <div class="hero-copy">
                <span class="eyebrow">Agenda tu visita</span>
                <h1 class="hero-title">Agenda tu cita vehicular</h1>
                <p class="hero-text">
                    Elige un servicio, indica los detalles de tu vehiculo y reserva un horario preferido para llegar al taller con todo listo.
                </p>
                <div class="hero-actions">
                    <a href="citas" class="app-button app-button-success">Agendar cita</a>
                </div>
                <% if (!admin && !tecnico) { %>
                <a href="login" class="internal-access">Acceso interno para administracion y tecnicos</a>
                <% } %>
            </div>
        </div>

        <div class="section-block">
            <h2 class="section-title">Servicios disponibles</h2>
            <p class="section-text">Selecciona una categoria para iniciar tu reserva. El precio final puede ajustarse luego de revisar el vehiculo.</p>

            <% if (servicio != null) { %>
            <div class="service-grid mt-4">
                <article class="service-card">
                    <div class="service-kicker">Servicio 01</div>
                    <h3 class="service-title">Logotipos</h3>
                    <p class="service-description">Diseno y aplicacion de piezas graficas vehiculares con cita previa.</p>
                    <div class="service-benefits">
                        <span><strong>Incluye:</strong> placas, tapasol, forrados y detalles visuales.</span>
                        <span><strong>Conviene si:</strong> necesitas personalizar o renovar acabados.</span>
                    </div>
                    <a href="citas" class="app-button app-button-success">Ver opciones de logotipo</a>
                </article>

                <article class="service-card">
                    <div class="service-kicker">Servicio 02</div>
                    <h3 class="service-title">Polarizados</h3>
                    <p class="service-description">Laminas para controlar privacidad, visibilidad y calor dentro del vehiculo.</p>
                    <div class="service-benefits">
                        <span><strong>Incluye:</strong> seleccion de material y porcentaje de luz.</span>
                        <span><strong>Conviene si:</strong> buscas confort, privacidad o proteccion solar.</span>
                    </div>
                    <a href="citas" class="app-button app-button-info">Ver opciones de polarizado</a>
                </article>

                <article class="service-card">
                    <div class="service-kicker">Servicio 03</div>
                    <h3 class="service-title">Instalaciones</h3>
                    <p class="service-description">Instalacion tecnica de accesorios, tapizados, radio, GPS y acabados interiores.</p>
                    <div class="service-benefits">
                        <span><strong>Incluye:</strong> revision del accesorio o trabajo solicitado.</span>
                        <span><strong>Conviene si:</strong> necesitas preparar una instalacion presencial.</span>
                    </div>
                    <a href="citas" class="app-button app-button-warning">Ver opciones de instalacion</a>
                </article>
            </div>
            <% } %>

            <div class="info-strip">
                <div class="info-item">
                    <strong>Flujo cliente</strong>
                    <div class="muted-text mt-2">Elige servicio, define detalles, selecciona horario y recibe tu constancia.</div>
                </div>
                <div class="info-item">
                    <strong>Al llegar al taller</strong>
                    <div class="muted-text mt-2">Presenta tu codigo o QR para validar rapidamente tu cita.</div>
                </div>
                <div class="info-item">
                    <strong>Precio estimado</strong>
                    <div class="muted-text mt-2">El monto se confirma luego de revisar el vehiculo y el alcance real.</div>
                </div>
            </div>

            <div class="hero-actions">
                <% if (admin) { %>
                <a href="usuarios" class="app-button app-button-info">Gestionar Usuarios</a>
                <a href="servicios-admin" class="app-button app-button-outline">Gestionar Servicios</a>
                <% } else if (tecnico) { %>
                <a href="tecnico" class="app-button app-button-info">Abrir panel tecnico</a>
                <% } %>
                <a href="citas" class="app-button app-button-primary">Comenzar una cita</a>
            </div>
        </div>
    </section>
</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
