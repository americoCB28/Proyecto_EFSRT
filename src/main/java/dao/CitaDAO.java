package dao;

import connection.ConexionDB;
import model.Cita;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class CitaDAO {

    public Cita buscarPorId(int idCita) {
        String sql = sqlBase() + " WHERE c.idCita = ?";
        try (
                Connection conn = ConexionDB.getConexion();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, idCita);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapearCita(rs);
                }
            }
        } catch (Exception e) {
            System.out.println("Error al buscar cita por id: " + e.getMessage());
        }
        return null;
    }

    public int crearCita(Cita cita) {
        String sql = """
                INSERT INTO citas (
                    idCatalogoServicio, idTecnicoAsignado, codigoVerificacion, tokenVerificacion, tipoServicio, detalleServicio, material, luzVisible,
                    servicioSeleccionado, fechaCita, franjaHoraria, nombreCliente, correoCliente,
                    telefonoCliente, precioEstimado, estadoCita, canalEntrega, observaciones
                ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """;
        try (
                Connection conn = ConexionDB.getConexion();
                PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)
        ) {
            if (cita.getIdCatalogoServicio() != null) {
                ps.setInt(1, cita.getIdCatalogoServicio());
            } else {
                ps.setNull(1, java.sql.Types.INTEGER);
            }
            if (cita.getIdTecnicoAsignado() != null) {
                ps.setInt(2, cita.getIdTecnicoAsignado());
            } else {
                ps.setNull(2, java.sql.Types.INTEGER);
            }
            ps.setString(3, cita.getCodigoVerificacion());
            ps.setString(4, cita.getTokenVerificacion());
            ps.setString(5, cita.getTipoServicio());
            ps.setString(6, cita.getDetalleServicio());
            ps.setString(7, cita.getMaterial());
            ps.setString(8, cita.getLuzVisible());
            ps.setString(9, cita.getServicioSeleccionado());
            ps.setString(10, cita.getFechaCita());
            ps.setString(11, cita.getFranjaHoraria());
            ps.setString(12, cita.getNombreCliente());
            ps.setString(13, cita.getCorreoCliente());
            ps.setString(14, cita.getTelefonoCliente());
            if (cita.getPrecioEstimado() != null) {
                ps.setDouble(15, cita.getPrecioEstimado());
            } else {
                ps.setNull(15, java.sql.Types.DECIMAL);
            }
            ps.setString(16, cita.getEstadoCita());
            ps.setString(17, cita.getCanalEntrega());
            ps.setString(18, cita.getObservaciones());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            System.out.println("Error al crear cita: " + e.getMessage());
        }
        return -1;
    }

    public Cita buscarPorToken(String tokenVerificacion) {
        String sql = sqlBase() + " WHERE c.tokenVerificacion = ?";
        try (
                Connection conn = ConexionDB.getConexion();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setString(1, tokenVerificacion);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapearCita(rs);
                }
            }
        } catch (Exception e) {
            System.out.println("Error al buscar cita por token: " + e.getMessage());
        }
        return null;
    }

    public Cita buscarPorCodigo(String codigoVerificacion) {
        String sql = sqlBase() + " WHERE c.codigoVerificacion = ?";
        try (
                Connection conn = ConexionDB.getConexion();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setString(1, codigoVerificacion);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapearCita(rs);
                }
            }
        } catch (Exception e) {
            System.out.println("Error al buscar cita por codigo: " + e.getMessage());
        }
        return null;
    }

    public List<Cita> listarUltimasCitas(int limite) {
        List<Cita> citas = new ArrayList<>();
        String sql = sqlBase() + " ORDER BY c.fechaRegistro DESC LIMIT ?";
        try (
                Connection conn = ConexionDB.getConexion();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, limite);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    citas.add(mapearCita(rs));
                }
            }
        } catch (Exception e) {
            System.out.println("Error al listar ultimas citas: " + e.getMessage());
        }
        return citas;
    }

    public List<Cita> listarCitasFiltradas(String fechaCita, String estadoCita, Integer idTecnicoAsignado, int limite) {
        List<Cita> citas = new ArrayList<>();
        StringBuilder sql = new StringBuilder(sqlBase()).append(" WHERE 1 = 1");
        List<Object> parametros = new ArrayList<>();

        if (fechaCita != null && !fechaCita.isBlank()) {
            sql.append(" AND c.fechaCita = ?");
            parametros.add(fechaCita);
        }

        if (estadoCita != null && !estadoCita.isBlank()) {
            sql.append(" AND c.estadoCita = ?");
            parametros.add(estadoCita);
        }

        if (idTecnicoAsignado != null && idTecnicoAsignado > 0) {
            sql.append(" AND c.idTecnicoAsignado = ?");
            parametros.add(idTecnicoAsignado);
        }

        sql.append(" ORDER BY c.fechaCita ASC, c.franjaHoraria ASC, c.fechaRegistro DESC");
        if (limite > 0) {
            sql.append(" LIMIT ?");
            parametros.add(limite);
        }

        try (
                Connection conn = ConexionDB.getConexion();
                PreparedStatement ps = conn.prepareStatement(sql.toString())
        ) {
            cargarParametros(ps, parametros);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    citas.add(mapearCita(rs));
                }
            }
        } catch (Exception e) {
            System.out.println("Error al listar citas filtradas: " + e.getMessage());
        }
        return citas;
    }

    public List<Cita> listarCitasFiltradas(String fechaCita, String estadoCita, int limite) {
        return listarCitasFiltradas(fechaCita, estadoCita, null, limite);
    }

    public int contarCitas() {
        return ejecutarConteo("SELECT COUNT(*) FROM citas");
    }

    public int contarCitasPorEstado(String estadoCita) {
        return ejecutarConteoConParametro("SELECT COUNT(*) FROM citas WHERE estadoCita = ?", estadoCita);
    }

    public int contarCitasPorFecha(String fechaCita) {
        return ejecutarConteoConParametro("SELECT COUNT(*) FROM citas WHERE fechaCita = ?", fechaCita);
    }

    public int contarCitasSinTecnico() {
        return ejecutarConteo("SELECT COUNT(*) FROM citas WHERE idTecnicoAsignado IS NULL");
    }

    public void actualizarCodigoVerificacion(int idCita, String codigoVerificacion) {
        String sql = "UPDATE citas SET codigoVerificacion = ? WHERE idCita = ?";
        try (
                Connection conn = ConexionDB.getConexion();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setString(1, codigoVerificacion);
            ps.setInt(2, idCita);
            ps.executeUpdate();
        } catch (Exception e) {
            System.out.println("Error al actualizar codigo de cita: " + e.getMessage());
        }
    }

    public void actualizarCanalEntrega(int idCita, String canalEntrega) {
        String sql = "UPDATE citas SET canalEntrega = ? WHERE idCita = ?";
        try (
                Connection conn = ConexionDB.getConexion();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setString(1, canalEntrega);
            ps.setInt(2, idCita);
            ps.executeUpdate();
        } catch (Exception e) {
            System.out.println("Error al actualizar canal de entrega de la cita: " + e.getMessage());
        }
    }

    public boolean actualizarEstadoCita(int idCita, String estadoCita) {
        String sql = "UPDATE citas SET estadoCita = ? WHERE idCita = ?";
        try (
                Connection conn = ConexionDB.getConexion();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setString(1, estadoCita);
            ps.setInt(2, idCita);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error al actualizar estado de la cita: " + e.getMessage());
        }
        return false;
    }

    public boolean actualizarTecnicoAsignado(int idCita, Integer idTecnicoAsignado) {
        String sql = "UPDATE citas SET idTecnicoAsignado = ? WHERE idCita = ?";
        try (
                Connection conn = ConexionDB.getConexion();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            if (idTecnicoAsignado != null && idTecnicoAsignado > 0) {
                ps.setInt(1, idTecnicoAsignado);
            } else {
                ps.setNull(1, java.sql.Types.INTEGER);
            }
            ps.setInt(2, idCita);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error al actualizar tecnico asignado: " + e.getMessage());
        }
        return false;
    }

    private String sqlBase() {
        return """
                SELECT c.*, cs.nombre AS nombreCatalogoServicio, u.username AS nombreTecnicoAsignado
                FROM citas c
                LEFT JOIN catalogoServicios cs ON c.idCatalogoServicio = cs.idCatalogoServicio
                LEFT JOIN usuarios u ON c.idTecnicoAsignado = u.idUsuario
                """;
    }

    private void cargarParametros(PreparedStatement ps, List<Object> parametros) throws Exception {
        for (int i = 0; i < parametros.size(); i++) {
            Object parametro = parametros.get(i);
            if (parametro instanceof Integer entero) {
                ps.setInt(i + 1, entero);
            } else {
                ps.setString(i + 1, parametro == null ? null : parametro.toString());
            }
        }
    }

    private int ejecutarConteo(String sql) {
        try (
                Connection conn = ConexionDB.getConexion();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()
        ) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("Error al ejecutar conteo de citas: " + e.getMessage());
        }
        return 0;
    }

    private int ejecutarConteoConParametro(String sql, String valor) {
        try (
                Connection conn = ConexionDB.getConexion();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setString(1, valor);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            System.out.println("Error al ejecutar conteo de citas con parametro: " + e.getMessage());
        }
        return 0;
    }

    private Cita mapearCita(ResultSet rs) throws Exception {
        Cita cita = new Cita();
        cita.setIdCita(rs.getInt("idCita"));
        int idCatalogoServicio = rs.getInt("idCatalogoServicio");
        cita.setIdCatalogoServicio(rs.wasNull() ? null : idCatalogoServicio);
        int idTecnicoAsignado = rs.getInt("idTecnicoAsignado");
        cita.setIdTecnicoAsignado(rs.wasNull() ? null : idTecnicoAsignado);
        cita.setCodigoVerificacion(rs.getString("codigoVerificacion"));
        cita.setTokenVerificacion(rs.getString("tokenVerificacion"));
        cita.setTipoServicio(rs.getString("tipoServicio"));
        cita.setNombreCatalogoServicio(rs.getString("nombreCatalogoServicio"));
        cita.setNombreTecnicoAsignado(rs.getString("nombreTecnicoAsignado"));
        cita.setDetalleServicio(rs.getString("detalleServicio"));
        cita.setMaterial(rs.getString("material"));
        cita.setLuzVisible(rs.getString("luzVisible"));
        cita.setServicioSeleccionado(rs.getString("servicioSeleccionado"));
        cita.setFechaCita(rs.getString("fechaCita"));
        cita.setFranjaHoraria(rs.getString("franjaHoraria"));
        cita.setNombreCliente(rs.getString("nombreCliente"));
        cita.setCorreoCliente(rs.getString("correoCliente"));
        cita.setTelefonoCliente(rs.getString("telefonoCliente"));
        cita.setPrecioEstimado(rs.getDouble("precioEstimado"));
        if (rs.wasNull()) {
            cita.setPrecioEstimado(null);
        }
        cita.setEstadoCita(rs.getString("estadoCita"));
        cita.setCanalEntrega(rs.getString("canalEntrega"));
        cita.setObservaciones(rs.getString("observaciones"));
        cita.setFechaRegistro(rs.getString("fechaRegistro"));
        return cita;
    }
}
