<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Cita" %>
<%@ page import="model.CatalogoServicio" %>
<!DOCTYPE html>
<html>
<head>
    <title>Detalle de la cita</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/styles.css" rel="stylesheet">
</head>
<body class="app-body">
<%
    String servicio = (String) request.getAttribute("servicio");
    String error = (String) request.getAttribute("error");
    Cita citaDraft = (Cita) request.getAttribute("citaDraft");
    CatalogoServicio catalogoServicio = (CatalogoServicio) request.getAttribute("catalogoServicio");
%>

<nav class="app-topbar">
    <div class="app-topbar-inner">
        <div class="brand-stack">
            <span class="brand-title">Detalle de la Cita</span>
            <span class="brand-subtitle">Selecciona la configuracion del servicio antes de elegir el horario</span>
        </div>
        <div class="topbar-actions">
            <a href="citas" class="app-button app-button-secondary">Cambiar servicio</a>
            <a href="inicio" class="app-button app-button-outline">Volver al inicio</a>
        </div>
    </div>
</nav>

<main class="form-shell">
    <div class="step-progress" aria-label="Progreso de reserva">
        <div class="step-item"><span class="step-number">Paso 1</span><span class="step-label">Servicio</span></div>
        <div class="step-item step-item-active"><span class="step-number">Paso 2</span><span class="step-label">Detalles</span></div>
        <div class="step-item"><span class="step-number">Paso 3</span><span class="step-label">Horario</span></div>
        <div class="step-item"><span class="step-number">Paso 4</span><span class="step-label">Datos</span></div>
        <div class="step-item"><span class="step-number">Paso 5</span><span class="step-label">Confirmacion</span></div>
    </div>

    <section class="section-hero">
        <span class="eyebrow">Paso 2 de 5</span>
        <h1 class="form-title mt-3">Define los detalles del servicio</h1>
        <p class="form-subtitle">
            Este paso nos ayuda a preparar mejor la atencion cuando lleves tu vehiculo al local.
            <% if (catalogoServicio != null) { %>
            Servicio seleccionado: <strong><%= catalogoServicio.getNombre() %></strong>.
            <% } %>
        </p>
    </section>

    <section class="form-card content-panel">
        <% if (error != null && !error.isBlank()) { %>
        <div class="app-alert alert alert-danger" role="alert"><%= error %></div>
        <% } %>

        <form action="citas" method="post">
            <input type="hidden" name="accion" value="detalle">
            <input type="hidden" name="servicio" value="<%= servicio %>">
            <input type="hidden" name="idCatalogoServicio" value="<%= citaDraft != null && citaDraft.getIdCatalogoServicio() != null ? citaDraft.getIdCatalogoServicio() : "" %>">

            <% if ("polarizado".equals(servicio)) { %>
            <div class="mb-4">
                <label class="form-label">Tipo de material</label>
                <div class="choice-help">El material define el rendimiento del polarizado. Si buscas menos calor, elige NanoCeramico; si buscas una opcion premium con mejor claridad, elige Crystalline.</div>
                <div class="choice-grid">
                    <div>
                        <input type="radio" class="btn-check" name="material" id="nanoCarbono" value="nanoCarbono"
                               <%= citaDraft != null && "nanoCarbono".equals(citaDraft.getMaterial()) ? "checked" : "" %> required>
                        <label class="choice-card" for="nanoCarbono">
                            <div class="choice-title">NanoCarbono</div>
                            <div class="choice-caption">Alta durabilidad y acabado oscuro.</div>
                        </label>
                    </div>
                    <div>
                        <input type="radio" class="btn-check" name="material" id="nanoCeramico" value="nanoCeramico"
                               <%= citaDraft != null && "nanoCeramico".equals(citaDraft.getMaterial()) ? "checked" : "" %>>
                        <label class="choice-card" for="nanoCeramico">
                            <div class="choice-title">NanoCeramico</div>
                            <div class="choice-caption">Mayor control de calor.</div>
                        </label>
                    </div>
                    <div>
                        <input type="radio" class="btn-check" name="material" id="crystalline" value="Crystalline"
                               <%= citaDraft != null && "Crystalline".equals(citaDraft.getMaterial()) ? "checked" : "" %>>
                        <label class="choice-card" for="crystalline">
                            <div class="choice-title">Crystalline</div>
                            <div class="choice-caption">Linea premium con mejor claridad.</div>
                        </label>
                    </div>
                </div>
            </div>

            <div class="mb-4">
                <label class="form-label">Porcentaje de luz visible</label>
                <div class="choice-help">Mientras menor sea el porcentaje, mas oscuro sera el acabado. Elige una opcion que combine privacidad y visibilidad para tu uso diario.</div>
                <div class="choice-grid">
                    <div>
                        <input type="radio" class="btn-check" name="luzVisible" id="luz5" value="5%"
                               <%= citaDraft != null && "5%".equals(citaDraft.getLuzVisible()) ? "checked" : "" %> required>
                        <label class="choice-card" for="luz5">
                            <div class="choice-title">5%</div>
                            <div class="choice-caption">Privacidad maxima.</div>
                        </label>
                    </div>
                    <div>
                        <input type="radio" class="btn-check" name="luzVisible" id="luz20" value="20%"
                               <%= citaDraft != null && "20%".equals(citaDraft.getLuzVisible()) ? "checked" : "" %>>
                        <label class="choice-card" for="luz20">
                            <div class="choice-title">20%</div>
                            <div class="choice-caption">Oscurecimiento alto.</div>
                        </label>
                    </div>
                    <div>
                        <input type="radio" class="btn-check" name="luzVisible" id="luz35" value="35%"
                               <%= citaDraft != null && "35%".equals(citaDraft.getLuzVisible()) ? "checked" : "" %>>
                        <label class="choice-card" for="luz35">
                            <div class="choice-title">35%</div>
                            <div class="choice-caption">Balance entre visibilidad y confort.</div>
                        </label>
                    </div>
                    <div>
                        <input type="radio" class="btn-check" name="luzVisible" id="luz50" value="50%"
                               <%= citaDraft != null && "50%".equals(citaDraft.getLuzVisible()) ? "checked" : "" %>>
                        <label class="choice-card" for="luz50">
                            <div class="choice-title">50%</div>
                            <div class="choice-caption">Acabado mas claro.</div>
                        </label>
                    </div>
                </div>
            </div>
            <% } else if ("logotipo".equals(servicio)) { %>
            <div class="mb-4">
                <label class="form-label">Tipo de trabajo</label>
                <div class="choice-help">Selecciona el trabajo grafico principal. El equipo confirmara medidas, acabado y ubicacion cuando revisen el vehiculo.</div>
                <div class="choice-grid">
                    <%
                        String[] opciones = {"Placa Provisional", "Tapasol", "Forrado de faros", "Forrado de techo", "Forrado de pisaderas", "Manijas"};
                        for (int i = 0; i < opciones.length; i++) {
                            String opcion = opciones[i];
                    %>
                    <div>
                        <input type="radio" class="btn-check" name="servicioSeleccionado" id="logo<%= i %>" value="<%= opcion %>"
                               <%= citaDraft != null && opcion.equals(citaDraft.getServicioSeleccionado()) ? "checked" : "" %> <%= i == 0 ? "required" : "" %>>
                        <label class="choice-card" for="logo<%= i %>">
                            <div class="choice-title"><%= opcion %></div>
                            <div class="choice-caption">Trabajo grafico e instalacion en taller.</div>
                        </label>
                    </div>
                    <% } %>
                </div>
            </div>
            <% } else { %>
            <div class="mb-4">
                <label class="form-label">Tipo de instalacion</label>
                <div class="choice-help">Elige la instalacion que necesitas. Si el alcance cambia al revisar el vehiculo, el taller podra ajustar el precio estimado.</div>
                <div class="choice-grid">
                    <%
                        String[] opciones = {"Tapizado de Techo", "Tapizado de Piso", "Confeccion de Fundas", "Instalacion de Radio", "Instalacion de GPS"};
                        for (int i = 0; i < opciones.length; i++) {
                            String opcion = opciones[i];
                    %>
                    <div>
                        <input type="radio" class="btn-check" name="servicioSeleccionado" id="inst<%= i %>" value="<%= opcion %>"
                               <%= citaDraft != null && opcion.equals(citaDraft.getServicioSeleccionado()) ? "checked" : "" %> <%= i == 0 ? "required" : "" %>>
                        <label class="choice-card" for="inst<%= i %>">
                            <div class="choice-title"><%= opcion %></div>
                            <div class="choice-caption">Atencion tecnica presencial para tu vehiculo.</div>
                        </label>
                    </div>
                    <% } %>
                </div>
            </div>
            <% } %>

            <div class="stack-actions">
                <button type="submit" class="app-button app-button-primary">Continuar al horario</button>
                <a href="citas" class="app-button app-button-secondary">Volver</a>
            </div>
        </form>
    </section>
</main>
</body>
</html>
