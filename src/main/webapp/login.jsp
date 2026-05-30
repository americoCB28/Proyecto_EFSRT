<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login Administrador</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/styles.css" rel="stylesheet">
</head>
<body class="app-body">
<%
    String error = (String) request.getAttribute("error");
    String success = (String) request.getAttribute("success");
    String username = (String) request.getAttribute("username");
    if (username == null) {
        username = "";
    }
%>

<nav class="app-topbar">
    <div class="app-topbar-inner">
        <div class="brand-stack">
            <span class="brand-title">Acceso Administrativo</span>
            <span class="brand-subtitle">Ingresa para revisar reportes y mantener pedidos</span>
        </div>
        <div class="topbar-actions">
            <a href="inicio" class="app-button app-button-outline">Volver al inicio</a>
        </div>
    </div>
</nav>

<main class="auth-shell">
    <section class="auth-card mt-4">
        <span class="eyebrow">Login seguro</span>
        <h1 class="form-title mt-3">Panel de administracion</h1>
        <p class="form-subtitle">Usa tus credenciales para acceder a la zona protegida. El flujo de autenticacion no cambia.</p>

        <% if (error != null && !error.isBlank()) { %>
        <div class="app-alert alert alert-danger" role="alert"><%= error %></div>
        <% } %>

        <% if (success != null && !success.isBlank()) { %>
        <div class="app-alert alert alert-success" role="alert"><%= success %></div>
        <% } %>

        <form action="login" method="post">
            <div class="mb-3">
                <label for="username" class="form-label">Usuario</label>
                <input type="text" id="username" name="username" class="form-control app-field"
                       value="<%= username %>" autocomplete="username" required>
            </div>

            <div class="mb-4">
                <label for="password" class="form-label">Contrasena</label>
                <input type="password" id="password" name="password" class="form-control app-field"
                       autocomplete="current-password" required>
            </div>

            <div class="stack-actions">
                <button type="submit" class="app-button app-button-primary">Ingresar</button>
                <a href="inicio" class="app-button app-button-secondary">Cancelar</a>
            </div>
        </form>
    </section>
</main>
</body>
</html>
