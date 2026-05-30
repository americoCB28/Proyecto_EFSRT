package controller;

import dao.ServicioDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Servicio;

import java.io.IOException;
import java.util.List;

@WebServlet("/inicio")
public class ServicioController extends HttpServlet {

    private final ServicioDAO servicioDAO = new ServicioDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Servicio> servicios = servicioDAO.listarServicios();
        request.setAttribute("servicios", servicios);
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}
