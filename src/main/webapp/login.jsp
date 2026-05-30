<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login Administrador</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            min-height: 100vh;
            background: linear-gradient(135deg, #111827, #1f2937);
            font-family: 'Segoe UI', sans-serif;
        }

        .login-card {
            max-width: 420px;
            background: rgba(17, 24, 39, 0.95);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 18px;
        }

        .brand-title {
            color: #f9fafb;
            font-weight: 800;
            letter-spacing: 0.04em;
        }
    </style>
</head>
<body class="d-flex align-items-center justify-content-center p-4">
<div class="login-card shadow-lg p-4 p-md-5 w-100">
    <div class="text-center mb-4">
        <h1 class="brand-title h3 mb-2">Panel Administrativo</h1>
        <p class="text-light-emphasis mb-0">Inicia sesión para acceder a reportes y actualizaciones.</p>
    </div>

    <%
        String error = (String) request.getAttribute("error");
        String success = (String) request.getAttribute("success");
        String username = (String) request.getAttribute("username");
        if (username == null) {
            username = "";
        }
    %>

    <% if (error != null && !error.isBlank()) { %>
    <div class="alert alert-danger" role="alert"><%= error %></div>
    <% } %>

    <% if (success != null && !success.isBlank()) { %>
    <div class="alert alert-success" role="alert"><%= success %></div>
    <% } %>

    <form action="login" method="post">
        <div class="mb-3">
            <label for="username" class="form-label text-white">Usuario</label>
            <input type="text" id="username" name="username" class="form-control form-control-lg"
                   value="<%= username %>" autocomplete="username" required>
        </div>

        <div class="mb-4">
            <label for="password" class="form-label text-white">Contraseña</label>
            <input type="password" id="password" name="password" class="form-control form-control-lg"
                   autocomplete="current-password" required>
        </div>

        <div class="d-grid gap-2">
            <button type="submit" class="btn btn-primary btn-lg">Ingresar</button>
            <a href="inicio" class="btn btn-outline-light">Volver al inicio</a>
        </div>
    </form>
</div>
</body>
</html>
