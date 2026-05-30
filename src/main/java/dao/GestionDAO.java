package dao;

import connection.ConexionDB;
import model.Cliente;
import model.Pedido;
import model.Servicio;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.PedidoLogotipo;
import model.PedidoInstalacion;

public class GestionDAO {

    // Obtener todos los servicios
    public List<Servicio> obtenerServicios() {
        List<Servicio> lista = new ArrayList<>();
        try {
            Connection conn = ConexionDB.getConexion();
            String sql = "SELECT * FROM servicios";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Servicio s = new Servicio();
                s.setIdServicio(rs.getInt("idServicio"));
                s.setLogotipos(rs.getString("logotipos"));
                s.setPolarizado(rs.getString("polarizado"));
                s.setInstalaciones(rs.getString("instalaciones"));
                lista.add(s);
            }
        } catch (Exception e) {
            System.out.println("Error al obtener servicios: " + e.getMessage());
        }
        return lista;
    }

    // Guardar cliente y retornar su ID generado
    public int guardarCliente(Cliente cliente) {
        int idGenerado = -1;
        try {
            Connection conn = ConexionDB.getConexion();
            String sql = "INSERT INTO clientes (nombre) VALUES (?)";
            PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            ps.setString(1, cliente.getNombre());
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                idGenerado = rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("Error al guardar cliente: " + e.getMessage());
        }
        return idGenerado;
    }

    // Guardar pedido
    public void guardarPedido(Pedido pedido) {
        try {
            Connection conn = ConexionDB.getConexion();
            String sql = "INSERT INTO pedidos (material, luzVisible, idCliente) VALUES (?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, pedido.getMaterial());
            ps.setString(2, pedido.getLuzVisible());
            ps.setInt(3, pedido.getIdCliente());
            ps.executeUpdate();
        } catch (Exception e) {
            System.out.println("Error al guardar pedido: " + e.getMessage());
        }
    }
    
    public void guardarPedidoLogotipo(PedidoLogotipo pedido) {
        try {
            Connection conn = ConexionDB.getConexion();
            String sql = "INSERT INTO pedidosLogotipo (idCliente, servicioSeleccionado) VALUES (?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, pedido.getIdCliente());
            ps.setString(2, pedido.getServicioSeleccionado());
            ps.executeUpdate();
        } catch (Exception e) {
            System.out.println("Error al guardar pedido logotipo: " + e.getMessage());
        }
    }

    public void guardarPedidoInstalacion(PedidoInstalacion pedido) {
        try {
            Connection conn = ConexionDB.getConexion();
            String sql = "INSERT INTO pedidosInstalaciones (idCliente, servicioSeleccionado) VALUES (?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, pedido.getIdCliente());
            ps.setString(2, pedido.getServicioSeleccionado());
            ps.executeUpdate();
        } catch (Exception e) {
            System.out.println("Error al guardar pedido instalacion: " + e.getMessage());
        }
    }
    
    
    public List<Cliente> obtenerClientes() {
        List<Cliente> lista = new ArrayList<>();
        try {
            Connection conn = ConexionDB.getConexion();
            String sql = "SELECT * FROM clientes";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Cliente c = new Cliente();
                c.setIdCliente(rs.getInt("idCliente"));
                c.setNombre(rs.getString("nombre"));
                lista.add(c);
            }
        } catch (Exception e) {
            System.out.println("Error al obtener clientes: " + e.getMessage());
        }
        return lista;
    }

    public List<Pedido> obtenerPedidos() {
        List<Pedido> lista = new ArrayList<>();
        try {
            Connection conn = ConexionDB.getConexion();
            String sql = "SELECT p.idPedido, p.material, p.luzVisible, p.fechaPedido, c.nombre " +
                         "FROM pedidos p JOIN clientes c ON p.idCliente = c.idCliente";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Pedido p = new Pedido();
                p.setIdPedido(rs.getInt("idPedido"));
                p.setMaterial(rs.getString("material"));
                p.setLuzVisible(rs.getString("luzVisible"));
                p.setFechaPedido(rs.getString("fechaPedido"));
                p.setNombreCliente(rs.getString("nombre"));
                lista.add(p);
            }
        } catch (Exception e) {
            System.out.println("Error al obtener pedidos: " + e.getMessage());
        }
        return lista;
    }
    
    public List<PedidoLogotipo> obtenerPedidosLogotipo() {
        List<PedidoLogotipo> lista = new ArrayList<>();
        try {
            Connection conn = ConexionDB.getConexion();
            String sql = "SELECT pl.idPedidoLogotipo, pl.servicioSeleccionado, pl.fechaPedido, c.nombre " +
                         "FROM pedidosLogotipo pl JOIN clientes c ON pl.idCliente = c.idCliente";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                PedidoLogotipo p = new PedidoLogotipo();
                p.setIdPedidoLogotipo(rs.getInt("idPedidoLogotipo"));
                p.setServicioSeleccionado(rs.getString("servicioSeleccionado"));
                p.setFechaPedido(rs.getString("fechaPedido"));
                p.setNombreCliente(rs.getString("nombre"));
                lista.add(p);
            }
        } catch (Exception e) {
            System.out.println("Error al obtener pedidos logotipo: " + e.getMessage());
        }
        return lista;
    }

    public List<PedidoInstalacion> obtenerPedidosInstalacion() {
        List<PedidoInstalacion> lista = new ArrayList<>();
        try {
            Connection conn = ConexionDB.getConexion();
            String sql = "SELECT pi.idPedidoInstalacion, pi.servicioSeleccionado, pi.fechaPedido, c.nombre " +
                         "FROM pedidosInstalaciones pi JOIN clientes c ON pi.idCliente = c.idCliente";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                PedidoInstalacion p = new PedidoInstalacion();
                p.setIdPedidoInstalacion(rs.getInt("idPedidoInstalacion"));
                p.setServicioSeleccionado(rs.getString("servicioSeleccionado"));
                p.setFechaPedido(rs.getString("fechaPedido"));
                p.setNombreCliente(rs.getString("nombre"));
                lista.add(p);
            }
        } catch (Exception e) {
            System.out.println("Error al obtener pedidos instalacion: " + e.getMessage());
        }
        return lista;
    }
    
    
    public void actualizarCliente(int idCliente, String nombre) {
        try {
            Connection conn = ConexionDB.getConexion();
            String sql = "UPDATE clientes SET nombre = ? WHERE idCliente = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, nombre);
            ps.setInt(2, idCliente);
            ps.executeUpdate();
        } catch (Exception e) {
            System.out.println("Error al actualizar cliente: " + e.getMessage());
        }
    }

    public void actualizarPedidoPolarizado(int idPedido, String material, String luzVisible) {
        try {
            Connection conn = ConexionDB.getConexion();
            String sql = "UPDATE pedidos SET material = ?, luzVisible = ? WHERE idPedido = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, material);
            ps.setString(2, luzVisible);
            ps.setInt(3, idPedido);
            ps.executeUpdate();
        } catch (Exception e) {
            System.out.println("Error al actualizar pedido polarizado: " + e.getMessage());
        }
    }

    public void actualizarPedidoLogotipo(int idPedidoLogotipo, String servicioSeleccionado) {
        try {
            Connection conn = ConexionDB.getConexion();
            String sql = "UPDATE pedidosLogotipo SET servicioSeleccionado = ? WHERE idPedidoLogotipo = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, servicioSeleccionado);
            ps.setInt(2, idPedidoLogotipo);
            ps.executeUpdate();
        } catch (Exception e) {
            System.out.println("Error al actualizar pedido logotipo: " + e.getMessage());
        }
    }

    public void actualizarPedidoInstalacion(int idPedidoInstalacion, String servicioSeleccionado) {
        try {
            Connection conn = ConexionDB.getConexion();
            String sql = "UPDATE pedidosInstalaciones SET servicioSeleccionado = ? WHERE idPedidoInstalacion = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, servicioSeleccionado);
            ps.setInt(2, idPedidoInstalacion);
            ps.executeUpdate();
        } catch (Exception e) {
            System.out.println("Error al actualizar pedido instalacion: " + e.getMessage());
        }
    }
    
    public void eliminarCliente(int idCliente) {
        try {
            Connection conn = ConexionDB.getConexion();
            String sql = "DELETE FROM clientes WHERE idCliente = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, idCliente);
            ps.executeUpdate();
        } catch (Exception e) {
            System.out.println("Error al eliminar cliente: " + e.getMessage());
        }
    }
    
}