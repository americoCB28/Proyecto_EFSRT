package dao;

import connection.ConexionDB;
import model.Servicio;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ServicioDAO {

    public List<Servicio> listarServicios() {
        List<Servicio> servicios = new ArrayList<>();
        String sql = "SELECT * FROM servicios";
        try (
                Connection conn = ConexionDB.getConexion();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()
        ) {
            while (rs.next()) {
                Servicio servicio = new Servicio();
                servicio.setIdServicio(rs.getInt("idServicio"));
                servicio.setLogotipos(rs.getString("logotipos"));
                servicio.setPolarizado(rs.getString("polarizado"));
                servicio.setInstalaciones(rs.getString("instalaciones"));
                servicios.add(servicio);
            }
        } catch (Exception e) {
            System.out.println("Error al listar servicios: " + e.getMessage());
        }
        return servicios;
    }
}
