<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="util.SessionUtil" %>
<!DOCTYPE html>
<html>
<head>
    <title>Logotipo Vehicular</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/styles.css" rel="stylesheet">
</head>
<body class="app-body theme-logotipo">
<%
    boolean admin = SessionUtil.esAdministrador(request);
%>

<nav class="app-topbar">
    <div class="app-topbar-inner">
        <div class="brand-stack">
            <span class="brand-title">Logotipo Vehicular</span>
            <span class="brand-subtitle">Define tu servicio y deja lista tu solicitud de atencion</span>
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
        <span class="eyebrow">Servicio grafico</span>
        <h1 class="form-title mt-3">Diseno de logotipos</h1>
        <p class="form-subtitle">Selecciona el trabajo requerido y registra tu solicitud de forma clara y rapida.</p>
    </section>

    <section class="form-card content-panel">
        <form action="servicio" method="post">
            <input type="hidden" name="tipo" value="logotipos">

            <div class="mb-4">
                <label class="form-label" for="nombre">Nombre del cliente</label>
                <input type="text" id="nombre" name="nombre" class="form-control app-field"
                       placeholder="Ingresa tu nombre completo" required>
            </div>

            <div class="mb-4">
                <label class="form-label">Selecciona una opcion</label>
                <div class="choice-grid">
                    <div>
                        <input type="radio" class="btn-check" name="opcionLogotipo" id="placa" value="Placa Provisional" required>
                        <label class="choice-card" for="placa">
                            <div class="choice-title">Placa Provisional</div>
                            <div class="choice-caption">Ideal para entregas rapidas o identificacion temporal</div>
                        </label>
                    </div>
                    <div>
                        <input type="radio" class="btn-check" name="opcionLogotipo" id="tapasol" value="Tapasol">
                        <label class="choice-card" for="tapasol">
                            <div class="choice-title">Tapasol</div>
                            <div class="choice-caption">Personalizacion simple para visibilidad exterior</div>
                        </label>
                    </div>
                    <div>
                        <input type="radio" class="btn-check" name="opcionLogotipo" id="faros" value="Forrado de faros">
                        <label class="choice-card" for="faros">
                            <div class="choice-title">Forrado de faros</div>
                            <div class="choice-caption">Detalle visual para mejorar presencia del vehiculo</div>
                        </label>
                    </div>
                    <div>
                        <input type="radio" class="btn-check" name="opcionLogotipo" id="techo" value="Forrado de techo">
                        <label class="choice-card" for="techo">
                            <div class="choice-title">Forrado de techo</div>
                            <div class="choice-caption">Acabado superior con estilo mas deportivo</div>
                        </label>
                    </div>
                    <div>
                        <input type="radio" class="btn-check" name="opcionLogotipo" id="pisaderas" value="Forrado de pisaderas">
                        <label class="choice-card" for="pisaderas">
                            <div class="choice-title">Forrado de pisaderas</div>
                            <div class="choice-caption">Proteccion y presencia para zonas de alto contacto</div>
                        </label>
                    </div>
                    <div>
                        <input type="radio" class="btn-check" name="opcionLogotipo" id="manijas" value="Manijas">
                        <label class="choice-card" for="manijas">
                            <div class="choice-title">Manijas</div>
                            <div class="choice-caption">Detalle de acabado con alto contraste visual</div>
                        </label>
                    </div>
                </div>
            </div>

            <div class="stack-actions">
                <button type="submit" class="app-button app-button-success">Registrar solicitud</button>
                <a href="inicio" class="app-button app-button-secondary">Cancelar</a>
            </div>

            <div class="page-footer-note">El formulario conserva el mismo destino y procesamiento actual.</div>
        </form>
    </section>
</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
