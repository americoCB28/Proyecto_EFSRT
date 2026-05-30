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
        String sql = "INSERT INTO pedidos (material, luzVisible, estado, idCliente) VALUES (?, ?, ?, ?)";
        try (
                Connection conn = ConexionDB.getConexion();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setString(1, pedido.getMaterial());
            ps.setString(2, pedido.getLuzVisible());
            ps.setString(3, pedido.getEstado());
            ps.setInt(4, pedido.getIdCliente());
            ps.executeUpdate();
        } catch (Exception e) {
            System.out.println("Error al crear pedido polarizado: " + e.getMessage());
        }
    }

    public void crearPedidoLogotipo(PedidoLogotipo pedido) {
        String sql = "INSERT INTO pedidosLogotipo (idCliente, servicioSeleccionado, estado) VALUES (?, ?, ?)";
        try (
                Connection conn = ConexionDB.getConexion();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, pedido.getIdCliente());
            ps.setString(2, pedido.getServicioSeleccionado());
            ps.setString(3, pedido.getEstado());
            ps.executeUpdate();
        } catch (Exception e) {
            System.out.println("Error al crear pedido logotipo: " + e.getMessage());
        }
    }

    public void crearPedidoInstalacion(PedidoInstalacion pedido) {
        String sql = "INSERT INTO pedidosInstalaciones (idCliente, servicioSeleccionado, estado) VALUES (?, ?, ?)";
        try (
                Connection conn = ConexionDB.getConexion();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, pedido.getIdCliente());
            ps.setString(2, pedido.getServicioSeleccionado());
            ps.setString(3, pedido.getEstado());
            ps.executeUpdate();
        } catch (Exception e) {
            System.out.println("Error al crear pedido instalacion: " + e.getMessage());
        }
    }

    public List<Pedido> listarPedidosPolarizado() {
        return listarPedidosPolarizadoPorCliente(null);
    }

    public List<Pedido> listarPedidosPolarizadoPorCliente(String filtroCliente) {
        List<Pedido> pedidos = new ArrayList<>();
        String sql = "SELECT p.idPedido, p.material, p.luzVisible, p.estado, p.fechaPedido, c.nombre " +
                "FROM pedidos p JOIN clientes c ON p.idCliente = c.idCliente" +
                (tieneFiltro(filtroCliente) ? " WHERE c.nombre LIKE ?" : "") +
                " ORDER BY p.fechaPedido DESC";
        try (
                Connection conn = ConexionDB.getConexion();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            if (tieneFiltro(filtroCliente)) {
                ps.setString(1, "%" + filtroCliente.trim() + "%");
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Pedido pedido = new Pedido();
                    pedido.setIdPedido(rs.getInt("idPedido"));
                    pedido.setMaterial(rs.getString("material"));
                    pedido.setLuzVisible(rs.getString("luzVisible"));
                    pedido.setEstado(rs.getString("estado"));
                    pedido.setFechaPedido(rs.getString("fechaPedido"));
                    pedido.setNombreCliente(rs.getString("nombre"));
                    pedidos.add(pedido);
                }
            }
        } catch (Exception e) {
            System.out.println("Error al listar pedidos polarizado: " + e.getMessage());
        }
        return pedidos;
    }

    public List<PedidoLogotipo> listarPedidosLogotipo() {
        return listarPedidosLogotipoPorCliente(null);
    }

    public List<PedidoLogotipo> listarPedidosLogotipoPorCliente(String filtroCliente) {
        List<PedidoLogotipo> pedidos = new ArrayList<>();
        String sql = "SELECT pl.idPedidoLogotipo, pl.servicioSeleccionado, pl.estado, pl.fechaPedido, c.nombre " +
                "FROM pedidosLogotipo pl JOIN clientes c ON pl.idCliente = c.idCliente" +
                (tieneFiltro(filtroCliente) ? " WHERE c.nombre LIKE ?" : "") +
                " ORDER BY pl.fechaPedido DESC";
        try (
                Connection conn = ConexionDB.getConexion();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            if (tieneFiltro(filtroCliente)) {
                ps.setString(1, "%" + filtroCliente.trim() + "%");
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    PedidoLogotipo pedido = new PedidoLogotipo();
                    pedido.setIdPedidoLogotipo(rs.getInt("idPedidoLogotipo"));
                    pedido.setServicioSeleccionado(rs.getString("servicioSeleccionado"));
                    pedido.setEstado(rs.getString("estado"));
                    pedido.setFechaPedido(rs.getString("fechaPedido"));
                    pedido.setNombreCliente(rs.getString("nombre"));
                    pedidos.add(pedido);
                }
            }
        } catch (Exception e) {
            System.out.println("Error al listar pedidos logotipo: " + e.getMessage());
        }
        return pedidos;
    }

    public List<PedidoInstalacion> listarPedidosInstalacion() {
        return listarPedidosInstalacionPorCliente(null);
    }

    public List<PedidoInstalacion> listarPedidosInstalacionPorCliente(String filtroCliente) {
        List<PedidoInstalacion> pedidos = new ArrayList<>();
        String sql = "SELECT pi.idPedidoInstalacion, pi.servicioSeleccionado, pi.estado, pi.fechaPedido, c.nombre " +
                "FROM pedidosInstalaciones pi JOIN clientes c ON pi.idCliente = c.idCliente" +
                (tieneFiltro(filtroCliente) ? " WHERE c.nombre LIKE ?" : "") +
                " ORDER BY pi.fechaPedido DESC";
        try (
                Connection conn = ConexionDB.getConexion();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            if (tieneFiltro(filtroCliente)) {
                ps.setString(1, "%" + filtroCliente.trim() + "%");
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    PedidoInstalacion pedido = new PedidoInstalacion();
                    pedido.setIdPedidoInstalacion(rs.getInt("idPedidoInstalacion"));
                    pedido.setServicioSeleccionado(rs.getString("servicioSeleccionado"));
                    pedido.setEstado(rs.getString("estado"));
                    pedido.setFechaPedido(rs.getString("fechaPedido"));
                    pedido.setNombreCliente(rs.getString("nombre"));
                    pedidos.add(pedido);
                }
            }
        } catch (Exception e) {
            System.out.println("Error al listar pedidos instalacion: " + e.getMessage());
        }
        return pedidos;
    }

    public void actualizarPedidoPolarizado(int idPedido, String material, String luzVisible, String estado) {
        String sql = "UPDATE pedidos SET material = ?, luzVisible = ?, estado = ? WHERE idPedido = ?";
        try (
                Connection conn = ConexionDB.getConexion();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setString(1, material);
            ps.setString(2, luzVisible);
            ps.setString(3, estado);
            ps.setInt(4, idPedido);
            ps.executeUpdate();
        } catch (Exception e) {
            System.out.println("Error al actualizar pedido polarizado: " + e.getMessage());
        }
    }

    public void actualizarPedidoLogotipo(int idPedidoLogotipo, String servicioSeleccionado, String estado) {
        String sql = "UPDATE pedidosLogotipo SET servicioSeleccionado = ?, estado = ? WHERE idPedidoLogotipo = ?";
        try (
                Connection conn = ConexionDB.getConexion();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setString(1, servicioSeleccionado);
            ps.setString(2, estado);
            ps.setInt(3, idPedidoLogotipo);
            ps.executeUpdate();
        } catch (Exception e) {
            System.out.println("Error al actualizar pedido logotipo: " + e.getMessage());
        }
    }

    public void actualizarPedidoInstalacion(int idPedidoInstalacion, String servicioSeleccionado, String estado) {
        String sql = "UPDATE pedidosInstalaciones SET servicioSeleccionado = ?, estado = ? WHERE idPedidoInstalacion = ?";
        try (
                Connection conn = ConexionDB.getConexion();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setString(1, servicioSeleccionado);
            ps.setString(2, estado);
            ps.setInt(3, idPedidoInstalacion);
            ps.executeUpdate();
        } catch (Exception e) {
            System.out.println("Error al actualizar pedido instalacion: " + e.getMessage());
        }
    }

    private boolean tieneFiltro(String filtroCliente) {
        return filtroCliente != null && !filtroCliente.isBlank();
    }
}
