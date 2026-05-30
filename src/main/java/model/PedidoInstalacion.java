package model;

public class PedidoInstalacion {
    private int idPedidoInstalacion;
    private int idCliente;
    private String servicioSeleccionado;
    private String fechaPedido;
    private String nombreCliente;	

    public int getIdPedidoInstalacion() { return idPedidoInstalacion; }
    public void setIdPedidoInstalacion(int idPedidoInstalacion) { this.idPedidoInstalacion = idPedidoInstalacion; }

    public int getIdCliente() { return idCliente; }
    public void setIdCliente(int idCliente) { this.idCliente = idCliente; }

    public String getServicioSeleccionado() { return servicioSeleccionado; }
    public void setServicioSeleccionado(String servicioSeleccionado) { this.servicioSeleccionado = servicioSeleccionado; }

    public String getFechaPedido() { return fechaPedido; }
    public void setFechaPedido(String fechaPedido) { this.fechaPedido = fechaPedido; }
    
    public String getNombreCliente() { return nombreCliente; }
    public void setNombreCliente(String nombreCliente) { this.nombreCliente = nombreCliente; }
}