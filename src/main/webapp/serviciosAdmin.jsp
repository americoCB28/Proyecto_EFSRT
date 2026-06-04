<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.CatalogoServicio" %>
<%@ page import="util.CsrfUtil" %>
<!DOCTYPE html>
<html>
<head>
    <title>Catalogo de Servicios</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/styles.css" rel="stylesheet">
</head>
<body class="app-body">
<%
    String flashSuccess = (String) request.getAttribute("flashSuccess");
    String flashWarning = (String) request.getAttribute("flashWarning");
    String flashError = (String) request.getAttribute("flashError");
    CatalogoServicio draftServicio = (CatalogoServicio) request.getAttribute("draftServicio");
    String csrfToken = CsrfUtil.obtenerToken(request);
    List<CatalogoServicio> catalogoServicios = (List<CatalogoServicio>) request.getAttribute("catalogoServicios");
%>
<nav class="app-topbar">
    <div class="app-topbar-inner">
        <div class="brand-stack">
            <span class="brand-title">Catalogo de Servicios</span>
            <span class="brand-subtitle">Crea y administra nuevos servicios sin tocar el codigo del flujo principal</span>
        </div>
        <div class="topbar-actions">
            <a href="inicio" class="app-button app-button-secondary">Inicio</a>
            <a href="servicio?tipo=dashboard" class="app-button app-button-info">Dashboard</a>
            <a href="servicio?tipo=reportes" class="app-button app-button-info">Atenciones</a>
            <a href="usuarios" class="app-button app-button-info">Usuarios</a>
            <a href="logout" class="app-button app-button-outline">Cerrar sesion</a>
        </div>
    </div>
</nav>

<main class="app-shell page-section">
    <section class="section-hero">
        <span class="eyebrow">Gestion comercial</span>
        <h1 class="form-title mt-3">Servicios administrables</h1>
        <p class="form-subtitle">Define nuevos servicios, activa o pausa su visibilidad operativa y deja listo el catalogo para integrarlo al flujo de citas.</p>
    </section>

    <div class="flash-wrap">
        <% if (flashSuccess != null && !flashSuccess.isBlank()) { %>
        <div class="app-alert alert alert-success" role="alert"><%= flashSuccess %></div>
        <% } %>
        <% if (flashWarning != null && !flashWarning.isBlank()) { %>
        <div class="app-alert alert alert-warning" role="alert"><%= flashWarning %></div>
        <% } %>
        <% if (flashError != null && !flashError.isBlank()) { %>
        <div class="app-alert alert alert-danger" role="alert"><%= flashError %></div>
        <% } %>
    </div>

    <section class="table-card">
        <div class="table-title">
            <h3>Crear nuevo servicio</h3>
        </div>
        <form action="servicios-admin" method="post" class="catalog-form-grid">
            <input type="hidden" name="accion" value="crear">
            <input type="hidden" name="<%= CsrfUtil.CSRF_REQUEST_PARAM %>" value="<%= csrfToken %>">
            <div>
                <label class="form-label" for="nombre">Nombre</label>
                <input type="text" id="nombre" name="nombre" class="form-control app-field" required
                       value="<%= draftServicio == null || draftServicio.getNombre() == null ? "" : draftServicio.getNombre() %>">
            </div>
            <div>
                <label class="form-label" for="slug">Slug</label>
                <input type="text" id="slug" name="slug" class="form-control app-field" required
                       placeholder="ejemplo: tapizado-premium"
                       value="<%= draftServicio == null || draftServicio.getSlug() == null ? "" : draftServicio.getSlug() %>">
            </div>
            <div>
                <label class="form-label" for="tipoBase">Tipo base</label>
                <select id="tipoBase" name="tipoBase" class="form-select app-field">
                    <option value="polarizado" <%= draftServicio != null && "polarizado".equals(draftServicio.getTipoBase()) ? "selected" : "" %>>Polarizado</option>
                    <option value="logotipo" <%= draftServicio != null && "logotipo".equals(draftServicio.getTipoBase()) ? "selected" : "" %>>Logotipo</option>
                    <option value="instalacion" <%= draftServicio == null || "instalacion".equals(draftServicio.getTipoBase()) ? "selected" : "" %>>Instalacion</option>
                </select>
            </div>
            <div>
                <label class="form-label" for="descripcionCorta">Descripcion corta</label>
                <input type="text" id="descripcionCorta" name="descripcionCorta" class="form-control app-field" required
                       value="<%= draftServicio == null || draftServicio.getDescripcionCorta() == null ? "" : draftServicio.getDescripcionCorta() %>">
            </div>
            <div>
                <label class="form-label" for="precioBase">Precio base</label>
                <input type="number" id="precioBase" name="precioBase" class="form-control app-field" min="0" step="0.01" required
                       value="<%= draftServicio == null || draftServicio.getPrecioBase() <= 0 ? "" : draftServicio.getPrecioBase() %>">
            </div>
            <div>
                <label class="form-label" for="duracionMinutos">Duracion (minutos)</label>
                <input type="number" id="duracionMinutos" name="duracionMinutos" class="form-control app-field" min="15" max="480" required
                       value="<%= draftServicio == null || draftServicio.getDuracionMinutos() <= 0 ? "" : draftServicio.getDuracionMinutos() %>">
            </div>
            <div>
                <label class="form-label" for="ordenVisual">Orden visual</label>
                <input type="number" id="ordenVisual" name="ordenVisual" class="form-control app-field" min="1" max="999" required
                       value="<%= draftServicio == null || draftServicio.getOrdenVisual() <= 0 ? "" : draftServicio.getOrdenVisual() %>">
            </div>
            <div class="catalog-checks">
                <label class="form-check-label"><input type="checkbox" class="form-check-input" name="activo" value="1" <%= draftServicio == null || draftServicio.isActivo() ? "checked" : "" %>> Activo</label>
                <label class="form-check-label"><input type="checkbox" class="form-check-input" name="requiereCita" value="1" <%= draftServicio == null || draftServicio.isRequiereCita() ? "checked" : "" %>> Requiere cita</label>
            </div>
            <div class="filter-actions">
                <button type="submit" class="app-button app-button-primary">Crear servicio</button>
            </div>
        </form>
    </section>

    <section class="table-card">
        <div class="table-title">
            <h3>Catalogo actual</h3>
        </div>
        <div class="table-responsive-shell">
            <table class="admin-table">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Nombre</th>
                    <th>Slug</th>
                    <th>Tipo base</th>
                    <th>Descripcion</th>
                    <th>Precio</th>
                    <th>Duracion</th>
                    <th>Estado</th>
                    <th>Accion</th>
                </tr>
                </thead>
                <tbody>
                <% if (catalogoServicios != null && !catalogoServicios.isEmpty()) {
                    for (CatalogoServicio servicio : catalogoServicios) { %>
                <tr>
                    <form action="servicios-admin" method="post">
                        <input type="hidden" name="accion" value="actualizar">
                        <input type="hidden" name="idCatalogoServicio" value="<%= servicio.getIdCatalogoServicio() %>">
                        <input type="hidden" name="<%= CsrfUtil.CSRF_REQUEST_PARAM %>" value="<%= csrfToken %>">
                        <td><%= servicio.getIdCatalogoServicio() %></td>
                        <td><input type="text" name="nombre" class="form-control app-field" value="<%= servicio.getNombre() %>"></td>
                        <td><input type="text" name="slug" class="form-control app-field" value="<%= servicio.getSlug() %>"></td>
                        <td>
                            <select name="tipoBase" class="form-select app-field">
                                <option value="polarizado" <%= "polarizado".equals(servicio.getTipoBase()) ? "selected" : "" %>>Polarizado</option>
                                <option value="logotipo" <%= "logotipo".equals(servicio.getTipoBase()) ? "selected" : "" %>>Logotipo</option>
                                <option value="instalacion" <%= "instalacion".equals(servicio.getTipoBase()) ? "selected" : "" %>>Instalacion</option>
                            </select>
                        </td>
                        <td><input type="text" name="descripcionCorta" class="form-control app-field" value="<%= servicio.getDescripcionCorta() %>"></td>
                        <td><input type="number" name="precioBase" class="form-control app-field" min="0" step="0.01" value="<%= servicio.getPrecioBase() %>"></td>
                        <td><input type="number" name="duracionMinutos" class="form-control app-field" min="15" max="480" value="<%= servicio.getDuracionMinutos() %>"></td>
                        <td>
                            <div class="catalog-state-stack">
                                <span class="status-pill <%= servicio.isActivo() ? "status-terminado" : "status-cancelado" %>"><%= servicio.isActivo() ? "activo" : "inactivo" %></span>
                                <label class="form-check-label"><input type="checkbox" class="form-check-input" name="activo" value="1" <%= servicio.isActivo() ? "checked" : "" %>> visible</label>
                                <label class="form-check-label"><input type="checkbox" class="form-check-input" name="requiereCita" value="1" <%= servicio.isRequiereCita() ? "checked" : "" %>> cita</label>
                                <input type="number" name="ordenVisual" class="form-control app-field app-field-sm" min="1" max="999" value="<%= servicio.getOrdenVisual() %>">
                            </div>
                        </td>
                        <td class="table-action-stack">
                            <button type="submit" class="app-button app-button-secondary app-button-sm">Guardar</button>
                    </form>
                            <form action="servicios-admin" method="post">
                                <input type="hidden" name="accion" value="toggle">
                                <input type="hidden" name="idCatalogoServicio" value="<%= servicio.getIdCatalogoServicio() %>">
                                <input type="hidden" name="activo" value="<%= servicio.isActivo() ? "0" : "1" %>">
                                <input type="hidden" name="<%= CsrfUtil.CSRF_REQUEST_PARAM %>" value="<%= csrfToken %>">
                                <button type="submit" class="app-button <%= servicio.isActivo() ? "app-button-danger-outline" : "app-button-success" %> app-button-sm">
                                    <%= servicio.isActivo() ? "Desactivar" : "Activar" %>
                                </button>
                            </form>
                        </td>
                </tr>
                <% }
                } else { %>
                <tr>
                    <td colspan="9">Todavia no hay servicios en el catalogo.</td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </section>
</main>
</body>
</html>
