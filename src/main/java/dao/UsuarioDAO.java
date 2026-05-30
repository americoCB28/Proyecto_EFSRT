package dao;

import connection.ConexionDB;
import model.Usuario;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

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
}
