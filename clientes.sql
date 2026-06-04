CREATE DATABASE IF NOT EXISTS db_gestion_servicios
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE db_gestion_servicios;

CREATE TABLE IF NOT EXISTS clientes (
  idCliente INT NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(100) NOT NULL,
  PRIMARY KEY (idCliente)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS servicios (
  idServicio INT NOT NULL AUTO_INCREMENT,
  logotipos VARCHAR(100) NOT NULL,
  polarizado VARCHAR(100) NOT NULL,
  instalaciones VARCHAR(100) NOT NULL,
  PRIMARY KEY (idServicio)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS pedidos (
  idPedido INT NOT NULL AUTO_INCREMENT,
  material VARCHAR(50) NOT NULL,
  luzVisible VARCHAR(10) NOT NULL,
  estado VARCHAR(20) NOT NULL DEFAULT 'pendiente',
  idCliente INT NOT NULL,
  fechaPedido TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (idPedido),
  KEY idx_pedidos_idCliente (idCliente),
  CONSTRAINT fk_pedidos_clientes
    FOREIGN KEY (idCliente) REFERENCES clientes (idCliente)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS pedidosLogotipo (
  idPedidoLogotipo INT NOT NULL AUTO_INCREMENT,
  idCliente INT NOT NULL,
  servicioSeleccionado VARCHAR(100) NOT NULL,
  estado VARCHAR(20) NOT NULL DEFAULT 'pendiente',
  fechaPedido TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (idPedidoLogotipo),
  KEY idx_pedidosLogotipo_idCliente (idCliente),
  CONSTRAINT fk_pedidosLogotipo_clientes
    FOREIGN KEY (idCliente) REFERENCES clientes (idCliente)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS pedidosInstalaciones (
  idPedidoInstalacion INT NOT NULL AUTO_INCREMENT,
  idCliente INT NOT NULL,
  servicioSeleccionado VARCHAR(100) NOT NULL,
  estado VARCHAR(20) NOT NULL DEFAULT 'pendiente',
  fechaPedido TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (idPedidoInstalacion),
  KEY idx_pedidosInstalaciones_idCliente (idCliente),
  CONSTRAINT fk_pedidosInstalaciones_clientes
    FOREIGN KEY (idCliente) REFERENCES clientes (idCliente)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET @pedidos_estado_exists = (
  SELECT COUNT(*)
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = 'db_gestion_servicios'
    AND TABLE_NAME = 'pedidos'
    AND COLUMN_NAME = 'estado'
);
SET @pedidos_estado_sql = IF(
  @pedidos_estado_exists = 0,
  'ALTER TABLE pedidos ADD COLUMN estado VARCHAR(20) NOT NULL DEFAULT ''pendiente''',
  'SELECT 1'
);
PREPARE stmt_pedidos_estado FROM @pedidos_estado_sql;
EXECUTE stmt_pedidos_estado;
DEALLOCATE PREPARE stmt_pedidos_estado;

SET @pedidos_logotipo_estado_exists = (
  SELECT COUNT(*)
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = 'db_gestion_servicios'
    AND TABLE_NAME = 'pedidosLogotipo'
    AND COLUMN_NAME = 'estado'
);
SET @pedidos_logotipo_estado_sql = IF(
  @pedidos_logotipo_estado_exists = 0,
  'ALTER TABLE pedidosLogotipo ADD COLUMN estado VARCHAR(20) NOT NULL DEFAULT ''pendiente''',
  'SELECT 1'
);
PREPARE stmt_pedidos_logotipo_estado FROM @pedidos_logotipo_estado_sql;
EXECUTE stmt_pedidos_logotipo_estado;
DEALLOCATE PREPARE stmt_pedidos_logotipo_estado;

SET @pedidos_instalaciones_estado_exists = (
  SELECT COUNT(*)
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = 'db_gestion_servicios'
    AND TABLE_NAME = 'pedidosInstalaciones'
    AND COLUMN_NAME = 'estado'
);
SET @pedidos_instalaciones_estado_sql = IF(
  @pedidos_instalaciones_estado_exists = 0,
  'ALTER TABLE pedidosInstalaciones ADD COLUMN estado VARCHAR(20) NOT NULL DEFAULT ''pendiente''',
  'SELECT 1'
);
PREPARE stmt_pedidos_instalaciones_estado FROM @pedidos_instalaciones_estado_sql;
EXECUTE stmt_pedidos_instalaciones_estado;
DEALLOCATE PREPARE stmt_pedidos_instalaciones_estado;

CREATE TABLE IF NOT EXISTS usuarios (
  idUsuario INT NOT NULL AUTO_INCREMENT,
  username VARCHAR(50) NOT NULL,
  passwordHash VARCHAR(255) NOT NULL,
  rol VARCHAR(20) NOT NULL,
  activo TINYINT(1) NOT NULL DEFAULT 1,
  fechaCreacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (idUsuario),
  UNIQUE KEY uk_usuarios_username (username)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS catalogoServicios (
  idCatalogoServicio INT NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(100) NOT NULL,
  slug VARCHAR(50) NOT NULL,
  tipoBase VARCHAR(30) NOT NULL,
  descripcionCorta VARCHAR(180) NOT NULL,
  precioBase DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  duracionMinutos INT NOT NULL DEFAULT 60,
  activo TINYINT(1) NOT NULL DEFAULT 1,
  requiereCita TINYINT(1) NOT NULL DEFAULT 1,
  ordenVisual INT NOT NULL DEFAULT 1,
  fechaCreacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (idCatalogoServicio),
  UNIQUE KEY uk_catalogoServicios_slug (slug)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS citas (
  idCita INT NOT NULL AUTO_INCREMENT,
  idCatalogoServicio INT DEFAULT NULL,
  idTecnicoAsignado INT DEFAULT NULL,
  codigoVerificacion VARCHAR(50) DEFAULT NULL,
  tokenVerificacion VARCHAR(120) DEFAULT NULL,
  tipoServicio VARCHAR(30) NOT NULL,
  detalleServicio VARCHAR(255) NOT NULL,
  material VARCHAR(50) DEFAULT NULL,
  luzVisible VARCHAR(10) DEFAULT NULL,
  servicioSeleccionado VARCHAR(100) DEFAULT NULL,
  fechaCita DATE DEFAULT NULL,
  franjaHoraria VARCHAR(30) DEFAULT NULL,
  nombreCliente VARCHAR(100) DEFAULT NULL,
  correoCliente VARCHAR(120) DEFAULT NULL,
  telefonoCliente VARCHAR(30) DEFAULT NULL,
  precioEstimado DECIMAL(10,2) DEFAULT NULL,
  estadoCita VARCHAR(20) NOT NULL DEFAULT 'pendiente',
  canalEntrega VARCHAR(20) DEFAULT NULL,
  observaciones VARCHAR(255) DEFAULT NULL,
  fechaRegistro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (idCita),
  KEY idx_citas_idCatalogoServicio (idCatalogoServicio),
  KEY idx_citas_idTecnicoAsignado (idTecnicoAsignado),
  KEY idx_citas_tipoServicio (tipoServicio),
  KEY idx_citas_fechaCita (fechaCita),
  KEY idx_citas_estadoCita (estadoCita),
  CONSTRAINT fk_citas_catalogoServicios
    FOREIGN KEY (idCatalogoServicio) REFERENCES catalogoServicios (idCatalogoServicio)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT fk_citas_usuarios_tecnico
    FOREIGN KEY (idTecnicoAsignado) REFERENCES usuarios (idUsuario)
    ON DELETE SET NULL
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO servicios (idServicio, logotipos, polarizado, instalaciones)
SELECT 1, 'Solicitar', 'Solicitar', 'Solicitar'
WHERE NOT EXISTS (
  SELECT 1 FROM servicios WHERE idServicio = 1
);

INSERT INTO clientes (idCliente, nombre)
SELECT 1, 'Cliente Demo Polarizado'
WHERE NOT EXISTS (
  SELECT 1 FROM clientes WHERE idCliente = 1
);

INSERT INTO clientes (idCliente, nombre)
SELECT 2, 'Cliente Demo Logotipo'
WHERE NOT EXISTS (
  SELECT 1 FROM clientes WHERE idCliente = 2
);

INSERT INTO clientes (idCliente, nombre)
SELECT 3, 'Cliente Demo Instalacion'
WHERE NOT EXISTS (
  SELECT 1 FROM clientes WHERE idCliente = 3
);

INSERT INTO pedidos (idPedido, material, luzVisible, estado, idCliente, fechaPedido)
SELECT 1, 'nanoCarbono', '35%', 'pendiente', 1, CURRENT_TIMESTAMP
WHERE NOT EXISTS (
  SELECT 1 FROM pedidos WHERE idPedido = 1
);

INSERT INTO pedidosLogotipo (idPedidoLogotipo, idCliente, servicioSeleccionado, estado, fechaPedido)
SELECT 1, 2, 'Placa Provisional', 'pendiente', CURRENT_TIMESTAMP
WHERE NOT EXISTS (
  SELECT 1 FROM pedidosLogotipo WHERE idPedidoLogotipo = 1
);

INSERT INTO pedidosInstalaciones (idPedidoInstalacion, idCliente, servicioSeleccionado, estado, fechaPedido)
SELECT 1, 3, 'Tapizado de Techo', 'pendiente', CURRENT_TIMESTAMP
WHERE NOT EXISTS (
  SELECT 1 FROM pedidosInstalaciones WHERE idPedidoInstalacion = 1
);

INSERT INTO usuarios (idUsuario, username, passwordHash, rol, activo)
SELECT 1, 'admin', '65536:R933u4hPpg+opiuCr70eug==:yklbRsi08MvwypzCmYc3rqDrfy4xK/ZPGIl5w16UgTI=', 'ADMIN', 1
WHERE NOT EXISTS (
  SELECT 1 FROM usuarios WHERE idUsuario = 1
);

INSERT INTO usuarios (idUsuario, username, passwordHash, rol, activo)
SELECT 2, 'tecnico', '65536:AItkZZnS5SbZBiduNMk4Sg==:OFhIYwvpNUrLLU+v9JHfUr5yxghd5n7LYl5tQAL7vbE=', 'TECNICO', 1
WHERE NOT EXISTS (
  SELECT 1 FROM usuarios WHERE idUsuario = 2
);

INSERT INTO catalogoServicios (idCatalogoServicio, nombre, slug, tipoBase, descripcionCorta, precioBase, duracionMinutos, activo, requiereCita, ordenVisual)
SELECT 1, 'Polarizado vehicular', 'polarizado-vehicular', 'polarizado', 'Servicio profesional de polarizado con control de calor y luz visible.', 350.00, 120, 1, 1, 1
WHERE NOT EXISTS (
  SELECT 1 FROM catalogoServicios WHERE idCatalogoServicio = 1
);

INSERT INTO catalogoServicios (idCatalogoServicio, nombre, slug, tipoBase, descripcionCorta, precioBase, duracionMinutos, activo, requiereCita, ordenVisual)
SELECT 2, 'Logotipo vehicular', 'logotipo-vehicular', 'logotipo', 'Aplicacion de piezas graficas, placas temporales y acabados visuales.', 180.00, 90, 1, 1, 2
WHERE NOT EXISTS (
  SELECT 1 FROM catalogoServicios WHERE idCatalogoServicio = 2
);

INSERT INTO catalogoServicios (idCatalogoServicio, nombre, slug, tipoBase, descripcionCorta, precioBase, duracionMinutos, activo, requiereCita, ordenVisual)
SELECT 3, 'Instalaciones automotrices', 'instalaciones-automotrices', 'instalacion', 'Instalacion de accesorios y mejoras interiores para el vehiculo.', 220.00, 120, 1, 1, 3
WHERE NOT EXISTS (
  SELECT 1 FROM catalogoServicios WHERE idCatalogoServicio = 3
);
