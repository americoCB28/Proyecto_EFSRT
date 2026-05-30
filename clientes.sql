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
  fechaPedido TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (idPedidoInstalacion),
  KEY idx_pedidosInstalaciones_idCliente (idCliente),
  CONSTRAINT fk_pedidosInstalaciones_clientes
    FOREIGN KEY (idCliente) REFERENCES clientes (idCliente)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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

INSERT INTO pedidos (idPedido, material, luzVisible, idCliente, fechaPedido)
SELECT 1, 'nanoCarbono', '35%', 1, CURRENT_TIMESTAMP
WHERE NOT EXISTS (
  SELECT 1 FROM pedidos WHERE idPedido = 1
);

INSERT INTO pedidosLogotipo (idPedidoLogotipo, idCliente, servicioSeleccionado, fechaPedido)
SELECT 1, 2, 'Placa Provisional', CURRENT_TIMESTAMP
WHERE NOT EXISTS (
  SELECT 1 FROM pedidosLogotipo WHERE idPedidoLogotipo = 1
);

INSERT INTO pedidosInstalaciones (idPedidoInstalacion, idCliente, servicioSeleccionado, fechaPedido)
SELECT 1, 3, 'Tapizado de Techo', CURRENT_TIMESTAMP
WHERE NOT EXISTS (
  SELECT 1 FROM pedidosInstalaciones WHERE idPedidoInstalacion = 1
);

INSERT INTO usuarios (idUsuario, username, passwordHash, rol, activo)
SELECT 1, 'admin', '65536:R933u4hPpg+opiuCr70eug==:yklbRsi08MvwypzCmYc3rqDrfy4xK/ZPGIl5w16UgTI=', 'ADMIN', 1
WHERE NOT EXISTS (
  SELECT 1 FROM usuarios WHERE idUsuario = 1
);
