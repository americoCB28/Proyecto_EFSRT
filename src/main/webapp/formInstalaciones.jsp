<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Instalaciones Vehicular</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body style="background-color: #0d0d1a;">

<!-- Navbar -->
<nav class="navbar navbar-dark" style="background-color: #2c2c3e;">
    <div class="container">
        <span class="navbar-brand fw-bold fs-4">
            <span class="text-white">⚡ Instalaciones Automotrices</span>
        </span>
        <a href="inicio" class="btn btn-outline-light btn-sm">← Volver</a>
    </div>
</nav>

<!-- Hero banner -->
<div class="py-4" style="background: linear-gradient(135deg, #2c2c3e, #0047ab);">
    <div class="container text-center text-white">
        <h2 class="fw-bold fs-1">Instalaciones Vehiculares</h2>
        <p class="mb-0 fs-5 opacity-75">Equipos y accesorios instalados por técnicos certificados</p>
    </div>
</div>

<!-- Contenido -->
<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-7">

            <div class="card border-0 shadow-lg" style="background-color: #1a1a2e;">

                <!-- Header -->
                <div class="card-header border-0 py-3" style="background-color: #2c2c3e;">
                    <div class="d-flex align-items-center gap-2">
                        <span class="fs-4">🔧</span>
                        <span class="text-white fw-bold fs-5">Formulario de Servicio</span>
                    </div>
                </div>

                <div class="card-body p-4">
                    <form action="servicio" method="post">
                        <input type="hidden" name="tipo" value="instalaciones">

                        <!-- Nombre cliente -->
                        <div class="mb-4">
                            <label class="form-label text-white fw-semibold">👤 Nombre del Cliente</label>
                            <input type="text" name="nombre" class="form-control form-control-lg bg-dark text-white border-secondary"
                                   placeholder="Ingresa tu nombre completo" required>
                        </div>

                        <hr class="border-secondary mb-4">

                        <!-- Opciones -->
                        <div class="mb-4">
                            <label class="form-label text-white fw-semibold">⚙️ Selecciona una instalación</label>
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <input type="radio" class="btn-check" name="opcionInstalacion" id="tapizadoTecho" value="Tapizado de Techo" required>
                                    <label class="btn btn-outline-primary w-100 py-3" for="tapizadoTecho">
                                        <div class="fw-bold">🪟 Tapizado de Techo</div>
                                    </label>
                                </div>
                                <div class="col-md-6">
                                    <input type="radio" class="btn-check" name="opcionInstalacion" id="tapizadoPiso" value="Tapizado de Piso">
                                    <label class="btn btn-outline-primary w-100 py-3" for="tapizadoPiso">
                                        <div class="fw-bold">🏁 Tapizado de Piso</div>
                                    </label>
                                </div>
                                <div class="col-md-6">
                                    <input type="radio" class="btn-check" name="opcionInstalacion" id="fundas" value="Confeccion de Fundas">
                                    <label class="btn btn-outline-primary w-100 py-3" for="fundas">
                                        <div class="fw-bold">🪑 Confección de Fundas</div>
                                    </label>
                                </div>
                                <div class="col-md-6">
                                    <input type="radio" class="btn-check" name="opcionInstalacion" id="radio" value="Instalacion de Radio">
                                    <label class="btn btn-outline-primary w-100 py-3" for="radio">
                                        <div class="fw-bold">📻 Instalación de Radio</div>
                                    </label>
                                </div>
                                <div class="col-md-12">
                                    <input type="radio" class="btn-check" name="opcionInstalacion" id="gps" value="Instalacion de GPS">
                                    <label class="btn btn-outline-primary w-100 py-3" for="gps">
                                        <div class="fw-bold">📡 Instalación de GPS</div>
                                    </label>
                                </div>
                            </div>
                        </div>

                        <div class="d-grid mt-4">
                            <button type="submit" class="btn btn-primary btn-lg fw-bold py-3" style="background-color: #0047ab; border: none;">
                                ✅ Confirmar Pedido
                            </button>
                        </div>

                    </form>
                </div>

                <div class="card-footer border-0 text-center py-3" style="background-color: #0047ab;">
                    <small class="text-white opacity-75">⚡ Instalaciones certificadas por técnicos automotrices</small>
                </div>

            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>