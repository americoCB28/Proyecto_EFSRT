<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Logotipo Vehicular</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body style="background-color: #0d1a0d;">

<!-- Navbar -->
<nav class="navbar navbar-dark" style="background-color: #e65c00;">
    <div class="container">
        <span class="navbar-brand fw-bold fs-4">
            <span class="text-white">🎨 Logotipo Vehicular</span>
        </span>
        <a href="inicio" class="btn btn-outline-light btn-sm">← Volver</a>
    </div>
</nav>

<!-- Hero banner -->
<div class="py-4" style="background: linear-gradient(135deg, #e65c00, #1a5c1a);">
    <div class="container text-center text-white">
        <h2 class="fw-bold fs-1">Diseño de Logotipos</h2>
        <p class="mb-0 fs-5 opacity-75">Personaliza tu vehículo con diseños únicos y profesionales</p>
    </div>
</div>

<!-- Contenido -->
<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-7">

            <div class="card border-0 shadow-lg" style="background-color: #1a2e1a;">

                <!-- Header -->
                <div class="card-header border-0 py-3" style="background-color: #e65c00;">
                    <div class="d-flex align-items-center gap-2">
                        <span class="fs-4">🖌️</span>
                        <span class="text-white fw-bold fs-5">Formulario de Servicio</span>
                    </div>
                </div>

                <div class="card-body p-4">
                    <form action="servicio" method="post">
                        <input type="hidden" name="tipo" value="logotipos">

                        <!-- Nombre cliente -->
                        <div class="mb-4">
                            <label class="form-label text-white fw-semibold">👤 Nombre del Cliente</label>
                            <input type="text" name="nombre" class="form-control form-control-lg bg-dark text-white border-secondary"
                                   placeholder="Ingresa tu nombre completo" required>
                        </div>

                        <hr class="border-secondary mb-4">

                        <!-- Opciones -->
                        <div class="mb-4">
                            <label class="form-label text-white fw-semibold">🏷️ Selecciona una opción</label>
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <input type="radio" class="btn-check" name="opcionLogotipo" id="placa" value="Placa Provisional" required>
                                    <label class="btn btn-outline-warning w-100 py-3" for="placa">
                                        <div class="fw-bold">Placa Provisional</div>
                                    </label>
                                </div>
                                <div class="col-md-6">
                                    <input type="radio" class="btn-check" name="opcionLogotipo" id="tapasol" value="Tapasol">
                                    <label class="btn btn-outline-warning w-100 py-3" for="tapasol">
                                        <div class="fw-bold">Tapasol</div>
                                    </label>
                                </div>
                                <div class="col-md-6">
                                    <input type="radio" class="btn-check" name="opcionLogotipo" id="faros" value="Forrado de faros">
                                    <label class="btn btn-outline-warning w-100 py-3" for="faros">
                                        <div class="fw-bold">Forrado de faros</div>
                                    </label>
                                </div>
                                <div class="col-md-6">
                                    <input type="radio" class="btn-check" name="opcionLogotipo" id="techo" value="Forrado de techo">
                                    <label class="btn btn-outline-warning w-100 py-3" for="techo">
                                        <div class="fw-bold">Forrado de techo</div>
                                    </label>
                                </div>
                                <div class="col-md-6">
                                    <input type="radio" class="btn-check" name="opcionLogotipo" id="pisaderas" value="Forrado de pisaderas">
                                    <label class="btn btn-outline-warning w-100 py-3" for="pisaderas">
                                        <div class="fw-bold">Forrado de pisaderas</div>
                                    </label>
                                </div>
                                <div class="col-md-6">
                                    <input type="radio" class="btn-check" name="opcionLogotipo" id="manijas" value="Manijas">
                                    <label class="btn btn-outline-warning w-100 py-3" for="manijas">
                                        <div class="fw-bold">Manijas</div>
                                    </label>
                                </div>
                            </div>
                        </div>

                        <div class="d-grid mt-4">
                            <button type="submit" class="btn btn-lg fw-bold py-3" style="background-color: #e65c00; color: white;">
                                ✅ Confirmar Pedido
                            </button>
                        </div>

                    </form>
                </div>

                <div class="card-footer border-0 text-center py-3" style="background-color: #1a5c1a;">
                    <small class="text-white opacity-75">🎨 Diseños personalizados para tu vehículo</small>
                </div>

            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>