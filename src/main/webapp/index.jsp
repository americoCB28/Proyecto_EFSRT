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
            <span class="brand-subtitle">Servicios, citas y seguimiento en un solo lugar</span>
        </div>
        <div class="topbar-actions">
            <a href="inicio" class="app-button app-button-secondary">Inicio</a>
            <% if (admin) { %>
            <a href="servicio?tipo=dashboard" class="app-button app-button-info">Dashboard</a>
            <a href="servicios-admin" class="app-button app-button-info">Servicios</a>
            <a href="admin-citas" class="app-button app-button-info">Validar citas</a>
            <a href="usuarios" class="app-button app-button-info">Usuarios</a>
            <a href="servicio?tipo=reportes" class="app-button app-button-outline">Reportes</a>
            <a href="logout" class="app-button app-button-outline">Cerrar sesion</a>
            <% } else if (tecnico) { %>
            <a href="tecnico" class="app-button app-button-info">Panel tecnico</a>
            <a href="admin-citas" class="app-button app-button-outline">Agenda de citas</a>
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
                <span class="eyebrow">Agenda tu visita</span>
                <h1 class="hero-title">Reserva la cita ideal para tu vehiculo</h1>
                <p class="hero-text">
                    Explora los servicios disponibles, define el trabajo que necesitas y deja listo el horario
                    preferido para llevar tu vehiculo al taller.
                </p>
                <div class="hero-actions">
                    <a href="citas" class="app-button app-button-success">Agendar cita</a>
                    <a href="servicio?tipo=reportes" class="app-button app-button-outline">Zona admin</a>
                </div>
            </div>
        </div>

        <div class="section-block">
            <h2 class="section-title">Servicios disponibles</h2>
            <p class="section-text">Elige el servicio y comienza un flujo de cita pensado para preparar la atencion de tu vehiculo.</p>

            <% if (servicio != null) { %>
            <div class="service-grid mt-4">
                <article class="service-card">
                    <div class="service-kicker">Servicio 01</div>
                    <h3 class="service-title">Logotipos</h3>
                    <p class="service-description">Diseno y aplicacion de logotipos vehiculares con cita previa para una atencion mas ordenada.</p>
                    <a href="citas?paso=detalle&servicio=logotipo" class="app-button app-button-success">Agendar logotipo</a>
                </article>

                <article class="service-card">
                    <div class="service-kicker">Servicio 02</div>
                    <h3 class="service-title">Polarizados</h3>
                    <p class="service-description">Selecciona material y porcentaje de luz visible para coordinar mejor la instalacion.</p>
                    <a href="citas?paso=detalle&servicio=polarizado" class="app-button app-button-info">Agendar polarizado</a>
                </article>

                <article class="service-card">
                    <div class="service-kicker">Servicio 03</div>
                    <h3 class="service-title">Instalaciones</h3>
                    <p class="service-description">Programa accesorios e instalaciones automotrices con horario preferido de atencion.</p>
                    <a href="citas?paso=detalle&servicio=instalacion" class="app-button app-button-warning">Agendar instalacion</a>
                </article>
            </div>
            <% } %>

            <div class="info-strip">
                <div class="info-item">
                    <strong>Flujo cliente</strong>
                    <div class="muted-text mt-2">Inicio, eleccion del servicio, detalle tecnico y horario preferido para la cita.</div>
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
