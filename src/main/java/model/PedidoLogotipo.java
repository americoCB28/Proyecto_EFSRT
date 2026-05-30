package model;

public class PedidoLogotipo {
    private int idPedidoLogotipo;
    private int idCliente;
    private String servicioSeleccionado;
    private String fechaPedido;
    private String nombreCliente;

    public int getIdPedidoLogotipo() { return idPedidoLogotipo; }
    public void setIdPedidoLogotipo(int idPedidoLogotipo) { this.idPedidoLogotipo = idPedidoLogotipo; }

    public int getIdCliente() { return idCliente; }
    public void setIdCliente(int idCliente) { this.idCliente = idCliente; }

    public String getServicioSeleccionado() { return servicioSeleccionado; }
    public void setServicioSeleccionado(String servicioSeleccionado) { this.servicioSeleccionado = servicioSeleccionado; }

    public String getFechaPedido() { return fechaPedido; }
    public void setFechaPedido(String fechaPedido) { this.fechaPedido = fechaPedido; }
    
   

    public String getNombreCliente() { return nombreCliente; }
    public void setNombreCliente(String nombreCliente) { this.nombreCliente = nombreCliente; }
}