package dao;

import connection.ConexionDB;
import model.ResumenPedidoReciente;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class DashboardDAO {

    public int contarClientes() {
        return ejecutarConteo("SELECT COUNT(*) FROM clientes");
    }

    public int contarPedidosPolarizado() {
        return ejecutarConteo("SELECT COUNT(*) FROM pedidos");
    }

    public int contarPedidosLogotipo() {
        return ejecutarConteo("SELECT COUNT(*) FROM pedidosLogotipo");
    }

    public int contarPedidosInstalacion() {
        return ejecutarConteo("SELECT COUNT(*) FROM pedidosInstalaciones");
    }

    public List<ResumenPedidoReciente> listarUltimosPedidos(int limite) {
        List<ResumenPedidoReciente> pedidos = new ArrayList<>();
        String sql = """
                SELECT *
                FROM (
                    SELECT 'Polarizado' AS tipoServicio, p.idPedido AS idReferencia,
                           c.nombre AS nombreCliente,
                           CONCAT(p.material, ' / ', p.luzVisible) AS detalle,
                           p.fechaPedido AS fechaPedido
                    FROM pedidos p
                    JOIN clientes c ON p.idCliente = c.idCliente
                    UNION ALL
                    SELECT 'Logotipo' AS tipoServicio, pl.idPedidoLogotipo AS idReferencia,
                           c.nombre AS nombreCliente,
                           pl.servicioSeleccionado AS detalle,
                           pl.fechaPedido AS fechaPedido
                    FROM pedidosLogotipo pl
                    JOIN clientes c ON pl.idCliente = c.idCliente
                    UNION ALL
                    SELECT 'Instalacion' AS tipoServicio, pi.idPedidoInstalacion AS idReferencia,
                           c.nombre AS nombreCliente,
                           pi.servicioSeleccionado AS detalle,
                           pi.fechaPedido AS fechaPedido
                    FROM pedidosInstalaciones pi
                    JOIN clientes c ON pi.idCliente = c.idCliente
                ) resumen
                ORDER BY fechaPedido DESC
                LIMIT ?
                """;
        try (
                Connection conn = ConexionDB.getConexion();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, limite);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ResumenPedidoReciente pedido = new ResumenPedidoReciente();
                    pedido.setTipoServicio(rs.getString("tipoServicio"));
                    pedido.setIdReferencia(rs.getInt("idReferencia"));
                    pedido.setNombreCliente(rs.getString("nombreCliente"));
                    pedido.setDetalle(rs.getString("detalle"));
                    pedido.setFechaPedido(rs.getString("fechaPedido"));
                    pedidos.add(pedido);
                }
            }
        } catch (Exception e) {
            System.out.println("Error al listar ultimos pedidos: " + e.getMessage());
        }
        return pedidos;
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
            System.out.println("Error al ejecutar conteo: " + e.getMessage());
        }
        return 0;
    }
}
