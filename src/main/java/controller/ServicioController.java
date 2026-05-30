package controller;

import dao.GestionDAO;
import model.Servicio;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/inicio")
public class ServicioController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        GestionDAO dao = new GestionDAO();
        List<Servicio> servicios = dao.obtenerServicios();
        request.setAttribute("servicios", servicios);
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}