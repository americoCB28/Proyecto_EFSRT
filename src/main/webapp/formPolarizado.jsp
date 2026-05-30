<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Tapasol / Polarizado</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body style="background-color: #0d1b2a;">

<!-- Navbar estilo 3M -->
<nav class="navbar navbar-dark">
    <div class="container">
        <span class="navbar-brand fw-bold fs-4 letter-spacing">
            <span style="color: #cc0000;" class="fw-bold">3M</span>
            <span class="text-white ms-2 fs-6 fw-normal">Tapasol / Polarizado Vehicular</span>
        </span>
        <a href="inicio" class="btn btn-outline-light btn-sm">← Volver</a>
    </div>
</nav>

<!-- Hero banner -->
<div class="py-4" style="background: linear-gradient(135deg, #cc0000, #001f5b);">
    <div class="container text-center text-white">
        <h2 class="fw-bold fs-1">Polarizado Profesional</h2>
        <p class="mb-0 fs-5 opacity-75">Tecnología de láminas de alta calidad para tu vehículo</p>
    </div>
</div>

<!-- Contenido principal -->
<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-7">

            <!-- Card principal -->
            <div class="card border-0 shadow-lg" style="background-color: #1a2a3a;">
                
                <!-- Header card -->
                <div class="card-header border-0 py-3" style="background-color: #cc0000;">
                    <div class="d-flex align-items-center gap-2">
                        <span class="fs-4">🚗</span>
                        <span class="text-white fw-bold fs-5">Formulario de Servicio</span>
                    </div>
                </div>

                <div class="card-body p-4">
                    <form action="servicio" method="post">
                        <input type="hidden" name="tipo" value="polarizado">

                        <!-- Nombre cliente -->
                        <div class="mb-4">
                            <label class="form-label text-white fw-semibold">
                                👤 Nombre del Cliente
                            </label>
                            <input type="text" name="nombre" class="form-control form-control-lg bg-dark text-white border-secondary" 
                                   placeholder="Ingresa tu nombre completo" required>
                        </div>

                        <!-- Separador -->
                        <hr class="border-secondary mb-4">

                        <!-- Material -->
                        <div class="mb-4">
                            <label class="form-label text-white fw-semibold">
                                🏷️ Tipo de Material
                            </label>
                            <div class="row g-3">
                                <div class="col-md-4">
                                    <input type="radio" class="btn-check" name="material" id="nanoCarbono" value="nanoCarbono" required>
                                    <label class="btn btn-outline-danger w-100 py-3" for="nanoCarbono">
                                        <div class="fw-bold">NanoCarbono</div>
                                        <small class="opacity-75">Alta durabilidad</small>
                                    </label>
                                </div>
                                <div class="col-md-4">
                                    <input type="radio" class="btn-check" name="material" id="nanoCeramico" value="nanoCeramico">
                                    <label class="btn btn-outline-danger w-100 py-3" for="nanoCeramico">
                                        <div class="fw-bold">NanoCerámico</div>
                                        <small class="opacity-75">Máximo calor</small>
                                    </label>
                                </div>
                                <div class="col-md-4">
                                    <input type="radio" class="btn-check" name="material" id="crystalline" value="Crystalline">
                                    <label class="btn btn-outline-danger w-100 py-3" for="crystalline">
                                        <div class="fw-bold">Crystalline</div>
                                        <small class="opacity-75">Premium 3M</small>
                                    </label>
                                </div>
                            </div>
                        </div>

                        <!-- Luz Visible -->
                        <div class="mb-4">
                            <label class="form-label text-white fw-semibold">
                                🌑 Porcentaje de Luz Visible
                            </label>
                            <div class="row g-3">
                                <div class="col-6 col-md-3">
                                    <input type="radio" class="btn-check" name="luzVisible" id="luz5" value="5%" required>
                                    <label class="btn btn-outline-primary w-100 py-3" for="luz5">
                                        <div class="fw-bold fs-5">5%</div>
                                        <small class="opacity-75">Muy oscuro</small>
                                    </label>
                                </div>
                                <div class="col-6 col-md-3">
                                    <input type="radio" class="btn-check" name="luzVisible" id="luz20" value="20%">
                                    <label class="btn btn-outline-primary w-100 py-3" for="luz20">
                                        <div class="fw-bold fs-5">20%</div>
                                        <small class="opacity-75">Oscuro</small>
                                    </label>
                                </div>
                                <div class="col-6 col-md-3">
                                    <input type="radio" class="btn-check" name="luzVisible" id="luz35" value="35%">
                                    <label class="btn btn-outline-primary w-100 py-3" for="luz35">
                                        <div class="fw-bold fs-5">35%</div>
                                        <small class="opacity-75">Medio</small>
                                    </label>
                                </div>
                                <div class="col-6 col-md-3">
                                    <input type="radio" class="btn-check" name="luzVisible" id="luz50" value="50%">
                                    <label class="btn btn-outline-primary w-100 py-3" for="luz50">
                                        <div class="fw-bold fs-5">50%</div>
                                        <small class="opacity-75">Claro</small>
                                    </label>
                                </div>
                            </div>
                        </div>

                        <!-- Boton submit -->
                        <div class="d-grid mt-4">
                            <button type="submit" class="btn btn-danger btn-lg fw-bold py-3">
                                ✅ Confirmar Pedido
                            </button>
                        </div>

                    </form>
                </div>

                <!-- Footer card -->
                <div class="card-footer border-0 text-center py-3" style="background-color: #001f5b;">
                    <small class="text-white opacity-75">🛡️ Garantía 3M — Calidad Certificada</small>
                </div>

            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>