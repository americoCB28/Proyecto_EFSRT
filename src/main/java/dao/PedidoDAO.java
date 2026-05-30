package dao;

import connection.ConexionDB;
import model.Pedido;
import model.PedidoInstalacion;
import model.PedidoLogotipo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class PedidoDAO {

    public void crearPedidoPolarizado(Pedido pedido) {
        String sql = "INSERT INTO pedidos (material, luzVisible, idCliente) VALUES (?, ?, ?)";
        try (
                Connection conn = ConexionDB.getConexion();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setString(1, pedido.getMaterial());
            ps.setString(2, pedido.getLuzVisible());
            ps.setInt(3, pedido.getIdCliente());
            ps.executeUpdate();
        } catch (Exception e) {
            System.out.println("Error al crear pedido polarizado: " + e.getMessage());
        }
    }

    public void crearPedidoLogotipo(PedidoLogotipo pedido) {
        String sql = "INSERT INTO pedidosLogotipo (idCliente, servicioSeleccionado) VALUES (?, ?)";
        try (
                Connection conn = ConexionDB.getConexion();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, pedido.getIdCliente());
            ps.setString(2, pedido.getServicioSeleccionado());
            ps.executeUpdate();
        } catch (Exception e) {
            System.out.println("Error al crear pedido logotipo: " + e.getMessage());
        }
    }

    public void crearPedidoInstalacion(PedidoInstalacion pedido) {
        String sql = "INSERT INTO pedidosInstalaciones (idCliente, servicioSeleccionado) VALUES (?, ?)";
        try (
                Connection conn = ConexionDB.getConexion();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, pedido.getIdCliente());
            ps.setString(2, pedido.getServicioSeleccionado());
            ps.executeUpdate();
        } catch (Exception e) {
            System.out.println("Error al crear pedido instalacion: " + e.getMessage());
        }
    }

    public List<Pedido> listarPedidosPolarizado() {
        List<Pedido> pedidos = new ArrayList<>();
        String sql = "SELECT p.idPedido, p.material, p.luzVisible, p.fechaPedido, c.nombre " +
                "FROM pedidos p JOIN clientes c ON p.idCliente = c.idCliente";
        try (
                Connection conn = ConexionDB.getConexion();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()
        ) {
            while (rs.next()) {
                Pedido pedido = new Pedido();
                pedido.setIdPedido(rs.getInt("idPedido"));
                pedido.setMaterial(rs.getString("material"));
                pedido.setLuzVisible(rs.getString("luzVisible"));
                pedido.setFechaPedido(rs.getString("fechaPedido"));
                pedido.setNombreCliente(rs.getString("nombre"));
                pedidos.add(pedido);
            }
        } catch (Exception e) {
            System.out.println("Error al listar pedidos polarizado: " + e.getMessage());
        }
        return pedidos;
    }

    public List<PedidoLogotipo> listarPedidosLogotipo() {
        List<PedidoLogotipo> pedidos = new ArrayList<>();
        String sql = "SELECT pl.idPedidoLogotipo, pl.servicioSeleccionado, pl.fechaPedido, c.nombre " +
                "FROM pedidosLogotipo pl JOIN clientes c ON pl.idCliente = c.idCliente";
        try (
                Connection conn = ConexionDB.getConexion();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()
        ) {
            while (rs.next()) {
                PedidoLogotipo pedido = new PedidoLogotipo();
                pedido.setIdPedidoLogotipo(rs.getInt("idPedidoLogotipo"));
                pedido.setServicioSeleccionado(rs.getString("servicioSeleccionado"));
                pedido.setFechaPedido(rs.getString("fechaPedido"));
                pedido.setNombreCliente(rs.getString("nombre"));
                pedidos.add(pedido);
            }
        } catch (Exception e) {
            System.out.println("Error al listar pedidos logotipo: " + e.getMessage());
        }
        return pedidos;
    }

    public List<PedidoInstalacion> listarPedidosInstalacion() {
        List<PedidoInstalacion> pedidos = new ArrayList<>();
        String sql = "SELECT pi.idPedidoInstalacion, pi.servicioSeleccionado, pi.fechaPedido, c.nombre " +
                "FROM pedidosInstalaciones pi JOIN clientes c ON pi.idCliente = c.idCliente";
        try (
                Connection conn = ConexionDB.getConexion();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()
        ) {
            while (rs.next()) {
                PedidoInstalacion pedido = new PedidoInstalacion();
                pedido.setIdPedidoInstalacion(rs.getInt("idPedidoInstalacion"));
                pedido.setServicioSeleccionado(rs.getString("servicioSeleccionado"));
                pedido.setFechaPedido(rs.getString("fechaPedido"));
                pedido.setNombreCliente(rs.getString("nombre"));
                pedidos.add(pedido);
            }
        } catch (Exception e) {
            System.out.println("Error al listar pedidos instalacion: " + e.getMessage());
        }
        return pedidos;
    }

    public void actualizarPedidoPolarizado(int idPedido, String material, String luzVisible) {
        String sql = "UPDATE pedidos SET material = ?, luzVisible = ? WHERE idPedido = ?";
        try (
                Connection conn = ConexionDB.getConexion();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setString(1, material);
            ps.setString(2, luzVisible);
            ps.setInt(3, idPedido);
            ps.executeUpdate();
        } catch (Exception e) {
            System.out.println("Error al actualizar pedido polarizado: " + e.getMessage());
        }
    }

    public void actualizarPedidoLogotipo(int idPedidoLogotipo, String servicioSeleccionado) {
        String sql = "UPDATE pedidosLogotipo SET servicioSeleccionado = ? WHERE idPedidoLogotipo = ?";
        try (
                Connection conn = ConexionDB.getConexion();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setString(1, servicioSeleccionado);
            ps.setInt(2, idPedidoLogotipo);
            ps.executeUpdate();
        } catch (Exception e) {
            System.out.println("Error al actualizar pedido logotipo: " + e.getMessage());
        }
    }

    public void actualizarPedidoInstalacion(int idPedidoInstalacion, String servicioSeleccionado) {
        String sql = "UPDATE pedidosInstalaciones SET servicioSeleccionado = ? WHERE idPedidoInstalacion = ?";
        try (
                Connection conn = ConexionDB.getConexion();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setString(1, servicioSeleccionado);
            ps.setInt(2, idPedidoInstalacion);
            ps.executeUpdate();
        } catch (Exception e) {
            System.out.println("Error al actualizar pedido instalacion: " + e.getMessage());
        }
    }
}
