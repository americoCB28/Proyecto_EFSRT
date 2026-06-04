package dao;

import connection.ConexionDB;
import model.CatalogoServicio;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class CatalogoServicioDAO {

    public CatalogoServicio buscarPorId(int idCatalogoServicio) {
        String sql = "SELECT * FROM catalogoServicios WHERE idCatalogoServicio = ?";
        try (
                Connection conn = ConexionDB.getConexion();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, idCatalogoServicio);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapear(rs);
                }
            }
        } catch (Exception e) {
            System.out.println("Error al buscar servicio del catalogo por id: " + e.getMessage());
        }
        return null;
    }

    public List<CatalogoServicio> listarServicios(boolean incluirInactivos) {
        List<CatalogoServicio> servicios = new ArrayList<>();
        String sql = incluirInactivos
                ? "SELECT * FROM catalogoServicios ORDER BY ordenVisual ASC, nombre ASC"
                : "SELECT * FROM catalogoServicios WHERE activo = 1 ORDER BY ordenVisual ASC, nombre ASC";
        try (
                Connection conn = ConexionDB.getConexion();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()
        ) {
            while (rs.next()) {
                servicios.add(mapear(rs));
            }
        } catch (Exception e) {
            System.out.println("Error al listar catalogo de servicios: " + e.getMessage());
        }
        return servicios;
    }

    public boolean existeSlug(String slug) {
        String sql = "SELECT 1 FROM catalogoServicios WHERE slug = ?";
        try (
                Connection conn = ConexionDB.getConexion();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setString(1, slug);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            System.out.println("Error al validar slug de servicio: " + e.getMessage());
        }
        return false;
    }

    public boolean existeSlugEnOtroRegistro(int idCatalogoServicio, String slug) {
        String sql = "SELECT 1 FROM catalogoServicios WHERE slug = ? AND idCatalogoServicio <> ?";
        try (
                Connection conn = ConexionDB.getConexion();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setString(1, slug);
            ps.setInt(2, idCatalogoServicio);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            System.out.println("Error al validar slug en otro servicio: " + e.getMessage());
        }
        return false;
    }

    public boolean crearServicio(CatalogoServicio servicio) {
        String sql = """
                INSERT INTO catalogoServicios
                (nombre, slug, tipoBase, descripcionCorta, precioBase, duracionMinutos, activo, requiereCita, ordenVisual)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
                """;
        try (
                Connection conn = ConexionDB.getConexion();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            cargarParametrosComunes(ps, servicio);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error al crear servicio del catalogo: " + e.getMessage());
        }
        return false;
    }

    public boolean actualizarServicio(CatalogoServicio servicio) {
        String sql = """
                UPDATE catalogoServicios
                SET nombre = ?, slug = ?, tipoBase = ?, descripcionCorta = ?, precioBase = ?, duracionMinutos = ?,
                    activo = ?, requiereCita = ?, ordenVisual = ?
                WHERE idCatalogoServicio = ?
                """;
        try (
                Connection conn = ConexionDB.getConexion();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            cargarParametrosComunes(ps, servicio);
            ps.setInt(10, servicio.getIdCatalogoServicio());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error al actualizar servicio del catalogo: " + e.getMessage());
        }
        return false;
    }

    public boolean actualizarEstadoServicio(int idCatalogoServicio, boolean activo) {
        String sql = "UPDATE catalogoServicios SET activo = ? WHERE idCatalogoServicio = ?";
        try (
                Connection conn = ConexionDB.getConexion();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setBoolean(1, activo);
            ps.setInt(2, idCatalogoServicio);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error al actualizar estado del servicio: " + e.getMessage());
        }
        return false;
    }

    private void cargarParametrosComunes(PreparedStatement ps, CatalogoServicio servicio) throws Exception {
        ps.setString(1, servicio.getNombre());
        ps.setString(2, servicio.getSlug());
        ps.setString(3, servicio.getTipoBase());
        ps.setString(4, servicio.getDescripcionCorta());
        ps.setDouble(5, servicio.getPrecioBase());
        ps.setInt(6, servicio.getDuracionMinutos());
        ps.setBoolean(7, servicio.isActivo());
        ps.setBoolean(8, servicio.isRequiereCita());
        ps.setInt(9, servicio.getOrdenVisual());
    }

    private CatalogoServicio mapear(ResultSet rs) throws Exception {
        CatalogoServicio servicio = new CatalogoServicio();
        servicio.setIdCatalogoServicio(rs.getInt("idCatalogoServicio"));
        servicio.setNombre(rs.getString("nombre"));
        servicio.setSlug(rs.getString("slug"));
        servicio.setTipoBase(rs.getString("tipoBase"));
        servicio.setDescripcionCorta(rs.getString("descripcionCorta"));
        servicio.setPrecioBase(rs.getDouble("precioBase"));
        servicio.setDuracionMinutos(rs.getInt("duracionMinutos"));
        servicio.setActivo(rs.getBoolean("activo"));
        servicio.setRequiereCita(rs.getBoolean("requiereCita"));
        servicio.setOrdenVisual(rs.getInt("ordenVisual"));
        servicio.setFechaCreacion(rs.getString("fechaCreacion"));
        return servicio;
    }
}
