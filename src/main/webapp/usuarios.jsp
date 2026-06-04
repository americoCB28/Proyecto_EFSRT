<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Usuario" %>
<%@ page import="util.CsrfUtil" %>
<!DOCTYPE html>
<html>
<head>
    <title>Usuarios Internos</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/styles.css" rel="stylesheet">
</head>
<body class="app-body">
<%
    String flashSuccess = (String) request.getAttribute("flashSuccess");
    String flashWarning = (String) request.getAttribute("flashWarning");
    String flashError = (String) request.getAttribute("flashError");
    String nuevoUsername = (String) request.getAttribute("nuevoUsername");
    if (nuevoUsername == null) {
        nuevoUsername = "";
    }
    String nuevoRol = (String) request.getAttribute("nuevoRol");
    if (nuevoRol == null) {
        nuevoRol = "ADMIN";
    }
    String csrfToken = CsrfUtil.obtenerToken(request);
    List<Usuario> usuarios = (List<Usuario>) request.getAttribute("usuarios");
    Usuario usuarioActual = (Usuario) request.getAttribute("usuarioActual");
%>

<nav class="app-topbar">
    <div class="app-topbar-inner">
        <div class="brand-stack">
            <span class="brand-title">Administradores</span>
            <span class="brand-subtitle">Gestiona accesos administrativos sin alterar el login actual</span>
        </div>
        <div class="topbar-actions">
            <a href="inicio" class="app-button app-button-secondary">Inicio</a>
            <a href="servicio?tipo=dashboard" class="app-button app-button-info">Dashboard</a>
            <a href="admin-citas" class="app-button app-button-info">Validar citas</a>
            <a href="servicios-admin" class="app-button app-button-info">Servicios</a>
            <a href="servicio?tipo=reportes" class="app-button app-button-info">Reportes</a>
            <a href="logout" class="app-button app-button-outline">Cerrar sesion</a>
        </div>
    </div>
</nav>

<main class="app-shell page-section">
    <section class="section-hero">
        <span class="eyebrow">Zona protegida</span>
        <h1 class="form-title mt-3">Gestion de usuarios internos</h1>
        <p class="form-subtitle">Crea administradores y tecnicos, y controla si pueden iniciar sesion desde una pantalla unica.</p>
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
            <h3>Crear nuevo usuario interno</h3>
        </div>
        <form action="usuarios" method="post" class="user-form-grid-wide">
            <input type="hidden" name="accion" value="crear">
            <input type="hidden" name="<%= CsrfUtil.CSRF_REQUEST_PARAM %>" value="<%= csrfToken %>">
            <div>
                <label for="username" class="form-label">Username</label>
                <input type="text" id="username" name="username" value="<%= nuevoUsername %>"
                       class="form-control app-field" placeholder="Ejemplo: admin.sur" required>
            </div>
            <div>
                <label for="password" class="form-label">Contrasena</label>
                <input type="password" id="password" name="password" class="form-control app-field"
                       placeholder="Minimo 8 caracteres" required>
            </div>
            <div>
                <label for="rol" class="form-label">Rol</label>
                <select id="rol" name="rol" class="form-select app-field">
                    <option value="ADMIN" <%= "ADMIN".equals(nuevoRol) ? "selected" : "" %>>Administrador</option>
                    <option value="TECNICO" <%= "TECNICO".equals(nuevoRol) ? "selected" : "" %>>Tecnico</option>
                </select>
            </div>
            <div class="filter-actions">
                <button type="submit" class="app-button app-button-primary">Crear usuario</button>
            </div>
        </form>
    </section>

    <section class="table-card">
        <div class="table-title">
            <h3>Usuarios internos registrados</h3>
        </div>
        <div class="table-responsive-shell">
            <table class="admin-table">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Username</th>
                    <th>Rol</th>
                    <th>Estado</th>
                    <th>Accion</th>
                </tr>
                </thead>
                <tbody>
                <% if (usuarios != null) {
                    for (Usuario usuario : usuarios) {
                        boolean esActual = usuarioActual != null && usuarioActual.getIdUsuario() == usuario.getIdUsuario();
                %>
                <tr>
                    <td><%= usuario.getIdUsuario() %></td>
                    <td>
                        <%= usuario.getUsername() %>
                        <% if (esActual) { %>
                        <span class="table-note">(tu sesion)</span>
                        <% } %>
                    </td>
                    <td><%= usuario.getRol() %></td>
                    <td>
                        <span class="status-pill <%= usuario.isActivo() ? "status-terminado" : "status-cancelado" %>">
                            <%= usuario.isActivo() ? "activo" : "inactivo" %>
                        </span>
                    </td>
                    <td>
                        <% if (esActual && usuario.isActivo()) { %>
                        <span class="muted-text">No puedes desactivarte</span>
                        <% } else { %>
                        <form action="usuarios" method="post">
                            <input type="hidden" name="accion" value="toggle">
                            <input type="hidden" name="idUsuario" value="<%= usuario.getIdUsuario() %>">
                            <input type="hidden" name="activo" value="<%= usuario.isActivo() ? "0" : "1" %>">
                            <input type="hidden" name="<%= CsrfUtil.CSRF_REQUEST_PARAM %>" value="<%= csrfToken %>">
                            <button type="submit"
                                    class="app-button <%= usuario.isActivo() ? "app-button-danger-outline" : "app-button-success" %> app-button-sm">
                                <%= usuario.isActivo() ? "Desactivar" : "Activar" %>
                            </button>
                        </form>
                        <% } %>
                    </td>
                </tr>
                <% }
                } %>
                </tbody>
            </table>
        </div>
    </section>
</main>
</body>
</html>
