<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="util.SessionUtil" %>
<!DOCTYPE html>
<html>
<head>
    <title>Tapasol / Polarizado</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/styles.css" rel="stylesheet">
</head>
<body class="app-body theme-polarizado">
<%
    boolean admin = SessionUtil.esAdministrador(request);
%>

<nav class="app-topbar">
    <div class="app-topbar-inner">
        <div class="brand-stack">
            <span class="brand-title">Polarizado Vehicular</span>
            <span class="brand-subtitle">Selecciona material, intensidad y solicita tu atencion</span>
        </div>
        <div class="topbar-actions">
            <a href="inicio" class="app-button app-button-secondary">Inicio</a>
            <% if (admin) { %>
            <a href="servicio?tipo=reportes" class="app-button app-button-info">Atenciones</a>
            <a href="logout" class="app-button app-button-outline">Cerrar sesion</a>
            <% } %>
        </div>
    </div>
</nav>

<main class="form-shell">
    <section class="section-hero hero-accent">
        <span class="eyebrow">Servicio 3M</span>
        <h1 class="form-title mt-3">Polarizado profesional</h1>
        <p class="form-subtitle">Completa tus datos y deja registrada tu solicitud de atencion para este servicio.</p>
    </section>

    <section class="form-card content-panel">
        <form action="servicio" method="post">
            <input type="hidden" name="tipo" value="polarizado">

            <div class="mb-4">
                <label class="form-label" for="nombre">Nombre del cliente</label>
                <input type="text" id="nombre" name="nombre" class="form-control app-field"
                       placeholder="Ingresa tu nombre completo" required>
            </div>

            <div class="mb-4">
                <label class="form-label">Tipo de material</label>
                <div class="choice-grid">
                    <div>
                        <input type="radio" class="btn-check" name="material" id="nanoCarbono" value="nanoCarbono" required>
                        <label class="choice-card" for="nanoCarbono">
                            <div class="choice-title">NanoCarbono</div>
                            <div class="choice-caption">Alta durabilidad y aspecto oscuro</div>
                        </label>
                    </div>
                    <div>
                        <input type="radio" class="btn-check" name="material" id="nanoCeramico" value="nanoCeramico">
                        <label class="choice-card" for="nanoCeramico">
                            <div class="choice-title">NanoCeramico</div>
                            <div class="choice-caption">Mayor control de calor</div>
                        </label>
                    </div>
                    <div>
                        <input type="radio" class="btn-check" name="material" id="crystalline" value="Crystalline">
                        <label class="choice-card" for="crystalline">
                            <div class="choice-title">Crystalline</div>
                            <div class="choice-caption">Linea premium y acabado claro</div>
                        </label>
                    </div>
                </div>
            </div>

            <div class="mb-4">
                <label class="form-label">Porcentaje de luz visible</label>
                <div class="choice-grid">
                    <div>
                        <input type="radio" class="btn-check" name="luzVisible" id="luz5" value="5%" required>
                        <label class="choice-card" for="luz5">
                            <div class="choice-title">5%</div>
                            <div class="choice-caption">Muy oscuro</div>
                        </label>
                    </div>
                    <div>
                        <input type="radio" class="btn-check" name="luzVisible" id="luz20" value="20%">
                        <label class="choice-card" for="luz20">
                            <div class="choice-title">20%</div>
                            <div class="choice-caption">Oscuro</div>
                        </label>
                    </div>
                    <div>
                        <input type="radio" class="btn-check" name="luzVisible" id="luz35" value="35%">
                        <label class="choice-card" for="luz35">
                            <div class="choice-title">35%</div>
                            <div class="choice-caption">Intermedio</div>
                        </label>
                    </div>
                    <div>
                        <input type="radio" class="btn-check" name="luzVisible" id="luz50" value="50%">
                        <label class="choice-card" for="luz50">
                            <div class="choice-title">50%</div>
                            <div class="choice-caption">Claro</div>
                        </label>
                    </div>
                </div>
            </div>

            <div class="stack-actions">
                <button type="submit" class="app-button app-button-info">Registrar solicitud</button>
                <a href="inicio" class="app-button app-button-secondary">Cancelar</a>
            </div>

            <div class="page-footer-note">Garantia visual mejorada, flujo funcional intacto.</div>
        </form>
    </section>
</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
