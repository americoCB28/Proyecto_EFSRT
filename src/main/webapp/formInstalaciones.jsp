<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="util.SessionUtil" %>
<!DOCTYPE html>
<html>
<head>
    <title>Instalaciones Vehiculares</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/styles.css" rel="stylesheet">
</head>
<body class="app-body theme-instalaciones">
<%
    boolean admin = SessionUtil.esAdministrador(request);
%>

<nav class="app-topbar">
    <div class="app-topbar-inner">
        <div class="brand-stack">
            <span class="brand-title">Instalaciones Automotrices</span>
            <span class="brand-subtitle">Solicita la instalacion y prepara la atencion de tu vehiculo</span>
        </div>
        <div class="topbar-actions">
            <a href="inicio" class="app-button app-button-secondary">Inicio</a>
            <% if (admin) { %>
            <a href="servicio?tipo=reportes" class="app-button app-button-info">Reportes</a>
            <a href="logout" class="app-button app-button-outline">Cerrar sesion</a>
            <% } %>
        </div>
    </div>
</nav>

<main class="form-shell">
    <section class="section-hero hero-accent">
        <span class="eyebrow">Servicio tecnico</span>
        <h1 class="form-title mt-3">Instalaciones vehiculares</h1>
        <p class="form-subtitle">Selecciona la instalacion necesaria y registra la solicitud de atencion.</p>
    </section>

    <section class="form-card content-panel">
        <form action="servicio" method="post">
            <input type="hidden" name="tipo" value="instalaciones">

            <div class="mb-4">
                <label class="form-label" for="nombre">Nombre del cliente</label>
                <input type="text" id="nombre" name="nombre" class="form-control app-field"
                       placeholder="Ingresa tu nombre completo" required>
            </div>

            <div class="mb-4">
                <label class="form-label">Selecciona una instalacion</label>
                <div class="choice-grid">
                    <div>
                        <input type="radio" class="btn-check" name="opcionInstalacion" id="tapizadoTecho" value="Tapizado de Techo" required>
                        <label class="choice-card" for="tapizadoTecho">
                            <div class="choice-title">Tapizado de Techo</div>
                            <div class="choice-caption">Trabajo interior de acabado superior</div>
                        </label>
                    </div>
                    <div>
                        <input type="radio" class="btn-check" name="opcionInstalacion" id="tapizadoPiso" value="Tapizado de Piso">
                        <label class="choice-card" for="tapizadoPiso">
                            <div class="choice-title">Tapizado de Piso</div>
                            <div class="choice-caption">Proteccion y presentacion de la zona inferior</div>
                        </label>
                    </div>
                    <div>
                        <input type="radio" class="btn-check" name="opcionInstalacion" id="fundas" value="Confeccion de Fundas">
                        <label class="choice-card" for="fundas">
                            <div class="choice-title">Confeccion de Fundas</div>
                            <div class="choice-caption">Personalizacion para asientos y acabados</div>
                        </label>
                    </div>
                    <div>
                        <input type="radio" class="btn-check" name="opcionInstalacion" id="radio" value="Instalacion de Radio">
                        <label class="choice-card" for="radio">
                            <div class="choice-title">Instalacion de Radio</div>
                            <div class="choice-caption">Montaje y configuracion basica de audio</div>
                        </label>
                    </div>
                    <div>
                        <input type="radio" class="btn-check" name="opcionInstalacion" id="gps" value="Instalacion de GPS">
                        <label class="choice-card" for="gps">
                            <div class="choice-title">Instalacion de GPS</div>
                            <div class="choice-caption">Asistencia de ubicacion y conectividad</div>
                        </label>
                    </div>
                </div>
            </div>

            <div class="stack-actions">
                <button type="submit" class="app-button app-button-warning">Registrar solicitud</button>
                <a href="inicio" class="app-button app-button-secondary">Cancelar</a>
            </div>

            <div class="page-footer-note">La experiencia visual mejora, pero el flujo y la persistencia siguen iguales.</div>
        </form>
    </section>
</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
