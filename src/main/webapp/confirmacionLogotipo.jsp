<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="util.SessionUtil" %>
<!DOCTYPE html>
<html>
<head>
    <title>Confirmacion Logotipo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/styles.css" rel="stylesheet">
</head>
<body class="app-body theme-logotipo">
<%
    boolean admin = SessionUtil.esAdministrador(request);
    String tituloConfirmacion = (String) request.getAttribute("tituloConfirmacion");
    String mensajeConfirmacion = (String) request.getAttribute("mensajeConfirmacion");
    String areaConfirmacion = (String) request.getAttribute("areaConfirmacion");
    String rutaNuevoPedido = (String) request.getAttribute("rutaNuevoPedido");
%>

<nav class="app-topbar">
    <div class="app-topbar-inner">
        <div class="brand-stack">
            <span class="brand-title">Pedido confirmado</span>
            <span class="brand-subtitle">La solicitud de logotipo ya fue registrada</span>
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

<main class="confirm-shell">
    <section class="confirm-card">
        <div class="confirm-icon">L</div>
        <div class="confirm-badge">Registro completado</div>
        <h1 class="confirm-title"><%= tituloConfirmacion %></h1>
        <p class="confirm-text"><%= mensajeConfirmacion %></p>
        <p class="section-text mb-4"><strong><%= areaConfirmacion %></strong></p>
        <div class="stack-actions justify-content-center">
            <a href="inicio" class="app-button app-button-success">Volver al inicio</a>
            <a href="<%= rutaNuevoPedido %>" class="app-button app-button-outline">Registrar otro pedido</a>
        </div>
    </section>
</main>
</body>
</html>
