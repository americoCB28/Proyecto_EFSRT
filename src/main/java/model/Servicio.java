package model;

public class Servicio {
    
    private int idServicio;
    private String logotipos;
    private String polarizado;
    private String instalaciones;

    public int getIdServicio() { return idServicio; }
    public void setIdServicio(int idServicio) { this.idServicio = idServicio; }

    public String getLogotipos() { return logotipos; }
    public void setLogotipos(String logotipos) { this.logotipos = logotipos; }

    public String getPolarizado() { return polarizado; }
    public void setPolarizado(String polarizado) { this.polarizado = polarizado; }

    public String getInstalaciones() { return instalaciones; }
    public void setInstalaciones(String instalaciones) { this.instalaciones = instalaciones; }
}