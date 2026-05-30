<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Servicio" %>
<!DOCTYPE html>
<html>
<head>
    <title>Gestion Servicios</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            min-height: 100vh;
            background-color: #0a0a0a;
            font-family: 'Segoe UI', sans-serif;
        }

        /* Hero con imagen de fondo */
        .hero {
            width: 100%;
            min-height: 100vh;
            background-image: url('img/FONDO_LOGOTIPOS.png');
            background-size: cover;
            background-position: center;
            position: relative;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 40px 20px;
        }

        /* Overlay oscuro sobre la imagen */
        .hero::before {
               content: '';
			   position: absolute;
    		   inset: 0;
    		   background: linear-gradient(to bottom, rgba(0,0,0,0.45) 0%, rgba(0,0,0,0.55) 100%);
    		   z-index: 0;
        }

        .hero-content {
            position: relative;
            z-index: 1;
            width: 100%;
            max-width: 900px;
        }

        /* Titulo */
        .titulo {
            text-align: center;
            margin-bottom: 10px;
        }

        .titulo h1 {
            font-size: 3rem;
            font-weight: 900;
            color: #ffffff;
            text-shadow: 0 0 20px rgba(255,200,0,0.6), 0 0 40px rgba(255,200,0,0.3);
            letter-spacing: 2px;
        }

        .titulo p {
            color: #cccccc;
            font-size: 1.1rem;
            margin-top: 8px;
            letter-spacing: 1px;
        }

        .divider {
            width: 80px;
            height: 3px;
            background: linear-gradient(to right, #f0a500, #ffdd57);
            margin: 15px auto 40px auto;
            border-radius: 2px;
            box-shadow: 0 0 10px rgba(240,165,0,0.7);
        }


        .service-card {
    background: linear-gradient(145deg, rgba(255,255,255,0.05), rgba(255,255,255,0.02));
    border: 1px solid rgba(255,255,255,0.1);
    border-radius: 16px;
    padding: 70px 40px;
    text-align: center;
    transition: transform 0.3s ease, box-shadow 0.3s ease;
    backdrop-filter: blur(10px);
}

        .service-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 0 30px rgba(255,200,0,0.2);
        }

        .service-card .icon {
    font-size: 4rem;
    margin-bottom: 18px;
}

        .service-card h5 {
    color: #ffffff;
    font-weight: 700;
    font-size: 1.5rem;
    margin-bottom: 12px;
    letter-spacing: 0.5px;
}

       .service-card p {
    color: #aaaaaa;
    font-size: 1rem;
    margin-bottom: 28px;
}

        .btn-glow-green {
            background: linear-gradient(135deg, #1db954, #17a045);
            border: none;
            color: white;
            font-weight: 700;
            padding: 14px 40px;
            border-radius: 50px;
            box-shadow: 0 0 15px rgba(29,185,84,0.5);
            transition: box-shadow 0.3s;
            text-decoration: none;
            font-size: 1rem;
        }
        .btn-glow-green:hover {
            box-shadow: 0 0 25px rgba(29,185,84,0.9);
            color: white;
        }

        .btn-glow-blue {
            background: linear-gradient(135deg, #1a73e8, #0d5fc4);
            border: none;
            color: white;
            font-weight: 700;
            padding: 14px 25px;
            border-radius: 50px;
            box-shadow: 0 0 15px rgba(26,115,232,0.5);
            transition: box-shadow 0.3s;
            text-decoration: none;
            font-size: 1rem;
        }
        .btn-glow-blue:hover {
            box-shadow: 0 0 25px rgba(26,115,232,0.9);
            color: white;
        }

        .btn-glow-yellow {
            background: linear-gradient(135deg, #f0a500, #ffdd57);
            border: none;
            color: #111;
            font-weight: 700;
            padding: 14px 40px;
            border-radius: 50px;
            box-shadow: 0 0 15px rgba(240,165,0,0.5);
            transition: box-shadow 0.3s;
            text-decoration: none;
            font-size: 1rem;
        }
        .btn-glow-yellow:hover {
            box-shadow: 0 0 25px rgba(240,165,0,0.9);
            color: #111;
        }

        .btn-reportes {
            background: transparent;
            border: 1px solid rgba(255,255,255,0.3);
            color: #cccccc;
            font-weight: 600;
            padding: 10px 36px;
            border-radius: 50px;
            transition: all 0.3s;
            text-decoration: none;
        }
        .btn-reportes:hover {
            background: rgba(255,255,255,0.1);
            color: white;
            border-color: white;
        }
    </style>
</head>
<body>

<div class="hero">
    <div class="hero-content">

        <!-- Titulo -->
        <div class="titulo">
            <h1>Gráfica Vehicular</h1>
            <p>Selecciona un servicio para continuar</p>
            <div class="divider"></div>
        </div>

        <!-- Cards -->
        <div class="row g-4 justify-content-center">
            <%
                List<Servicio> servicios = (List<Servicio>) request.getAttribute("servicios");
                if (servicios != null && !servicios.isEmpty()) {
                    Servicio s = servicios.get(0);
            %>

            <!-- Logotipos -->
            <div class="col-md-4">
                <div class="service-card">
                    <div class="icon"></div>
                    <h5>Logotipos</h5>
                    <p>Diseño y aplicación de logotipos vehiculares.</p>
                    <a href="servicio?tipo=logotipos" class="btn-glow-green"><%= s.getLogotipos() %></a>
                </div>
            </div>

            <!-- Polarizado -->
            <div class="col-md-4">
                <div class="service-card">
                    <div class="icon"></div>
                    <h5>Polarizados</h5>
                    <p>Aplicación de láminas y polarizado vehicular.</p>
                    <a href="servicio?tipo=polarizado" class="btn-glow-blue"><%= s.getPolarizado() %></a>
                </div>
            </div>

            <!-- Instalaciones -->
            <div class="col-md-4">
                <div class="service-card">
                    <div class="icon"></div>
                    <h5>Instalaciones</h5>
                    <p>Instalación de accesorios y equipos vehiculares.</p>
                    <a href="servicio?tipo=instalaciones" class="btn-glow-yellow"><%= s.getInstalaciones() %></a>
                </div>
            </div>

            <% } %>
        </div>

        <!-- Boton Reportes -->
        <div class="text-center mt-5">
            <a href="servicio?tipo=reportes" class="btn-reportes">📊 Reportes</a>
        </div>

    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>