package dao;

import connection.ConexionDB;
import model.Usuario;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class UsuarioDAO {

    public Usuario buscarUsuarioActivoPorUsername(String username) {
        String sql = "SELECT idUsuario, username, passwordHash, rol, activo " +
                "FROM usuarios WHERE username = ? AND activo = 1";
        try (
                Connection conn = ConexionDB.getConexion();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Usuario usuario = new Usuario();
                    usuario.setIdUsuario(rs.getInt("idUsuario"));
                    usuario.setUsername(rs.getString("username"));
                    usuario.setPasswordHash(rs.getString("passwordHash"));
                    usuario.setRol(rs.getString("rol"));
                    usuario.setActivo(rs.getBoolean("activo"));
                    return usuario;
                }
            }
        } catch (Exception e) {
            System.out.println("Error al buscar usuario: " + e.getMessage());
        }
        return null;
    }

    public List<Usuario> listarAdministradores() {
        List<Usuario> usuarios = new ArrayList<>();
        String sql = "SELECT idUsuario, username, passwordHash, rol, activo FROM usuarios WHERE rol = 'ADMIN' ORDER BY username";
        try (
                Connection conn = ConexionDB.getConexion();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()
        ) {
            while (rs.next()) {
                usuarios.add(mapearUsuario(rs));
            }
        } catch (Exception e) {
            System.out.println("Error al listar administradores: " + e.getMessage());
        }
        return usuarios;
    }

    public boolean existeUsername(String username) {
        String sql = "SELECT 1 FROM usuarios WHERE username = ?";
        try (
                Connection conn = ConexionDB.getConexion();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            System.out.println("Error al validar username: " + e.getMessage());
        }
        return false;
    }

    public boolean crearAdministrador(String username, String passwordHash) {
        String sql = "INSERT INTO usuarios (username, passwordHash, rol, activo) VALUES (?, ?, 'ADMIN', 1)";
        try (
                Connection conn = ConexionDB.getConexion();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setString(1, username);
            ps.setString(2, passwordHash);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error al crear administrador: " + e.getMessage());
        }
        return false;
    }

    public Usuario buscarUsuarioPorId(int idUsuario) {
        String sql = "SELECT idUsuario, username, passwordHash, rol, activo FROM usuarios WHERE idUsuario = ?";
        try (
                Connection conn = ConexionDB.getConexion();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, idUsuario);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapearUsuario(rs);
                }
            }
        } catch (Exception e) {
            System.out.println("Error al buscar usuario por id: " + e.getMessage());
        }
        return null;
    }

    public boolean actualizarEstadoUsuario(int idUsuario, boolean activo) {
        String sql = "UPDATE usuarios SET activo = ? WHERE idUsuario = ?";
        try (
                Connection conn = ConexionDB.getConexion();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setBoolean(1, activo);
            ps.setInt(2, idUsuario);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error al actualizar estado del usuario: " + e.getMessage());
        }
        return false;
    }

    private Usuario mapearUsuario(ResultSet rs) throws Exception {
        Usuario usuario = new Usuario();
        usuario.setIdUsuario(rs.getInt("idUsuario"));
        usuario.setUsername(rs.getString("username"));
        usuario.setPasswordHash(rs.getString("passwordHash"));
        usuario.setRol(rs.getString("rol"));
        usuario.setActivo(rs.getBoolean("activo"));
        return usuario;
    }
}
