/*
 * Created By Katerina Charalampidou
 */
/*
 * Import required java libraries *
 */
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.RequestDispatcher;
/**
 * Extend HttpServlet class *
 */
public class Plot_Axis extends HttpServlet 
{
    boolean st = false;
    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
    {
        /** set as default filter accelerometer **/
        request.setAttribute("filter", "accelometer");
        RequestDispatcher rd = request.getRequestDispatcher("Plot.jsp");
        /** request includes the form and the filter **/
        rd.include(request, response);
    }
    /* Method to handle POST method request */
    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
    {
        /** Call doGet() function, request is the form from the selected_device.jsp **/
        doGet(request, response);
    }
}
