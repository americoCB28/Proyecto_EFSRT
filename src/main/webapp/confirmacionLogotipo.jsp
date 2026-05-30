<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Confirmacion Logotipo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<%
    String tituloConfirmacion = (String) request.getAttribute("tituloConfirmacion");
    String mensajeConfirmacion = (String) request.getAttribute("mensajeConfirmacion");
    String areaConfirmacion = (String) request.getAttribute("areaConfirmacion");
    String rutaNuevoPedido = (String) request.getAttribute("rutaNuevoPedido");
%>

<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-6 text-center">
            <div class="card shadow-sm">
                <div class="card-header bg-success text-white fw-bold fs-5">
                    Logotipo Vehicular
                </div>
                <div class="card-body py-5">
                    <div class="alert alert-success" role="alert">
                        <strong><%= tituloConfirmacion %></strong><br>
                        <span><%= mensajeConfirmacion %></span>
                    </div>
                    <h1 class="fw-bold text-success"><%= areaConfirmacion %></h1>
                    <div class="d-flex justify-content-center gap-3 flex-wrap mt-4">
                        <a href="inicio" class="btn btn-success px-4">Volver al inicio</a>
                        <a href="<%= rutaNuevoPedido %>" class="btn btn-outline-success px-4">Registrar otro pedido</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
