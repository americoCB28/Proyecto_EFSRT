package model;

public class Pedido {
    private int idPedido;
    private String material;
    private String luzVisible;
    private int idCliente;
    private String fechaPedido;
    private String nombreCliente;

    public int getIdPedido() { return idPedido; }
    public void setIdPedido(int idPedido) { this.idPedido = idPedido; }

    public String getMaterial() { return material; }
    public void setMaterial(String material) { this.material = material; }

    public String getLuzVisible() { return luzVisible; }
    public void setLuzVisible(String luzVisible) { this.luzVisible = luzVisible; }

    public int getIdCliente() { return idCliente; }
    public void setIdCliente(int idCliente) { this.idCliente = idCliente; }
    
    public String getFechaPedido() { return fechaPedido; }
    public void setFechaPedido(String fechaPedido) { this.fechaPedido = fechaPedido; }
    
    public String getNombreCliente() { return nombreCliente; }
    public void setNombreCliente(String nombreCliente) { this.nombreCliente = nombreCliente; }
}