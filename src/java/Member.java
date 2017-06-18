/**
 *  Created By Katerina Charalampidou
 */
/**
 * Import required java libraries *
 */
import java.awt.Component;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.JOptionPane;
import javax.servlet.RequestDispatcher;
/**
 * Extend HttpServlet class *
 */
public class Member extends HttpServlet 
{
    /**
     * Initialize variables 
     */
    private String password;
    private String username;
    boolean st = false;
    private int id;
    /*private static final String USERNAME = "root";
    private static final String PASSWORD = "";
    private static final String CONN_STRING = "jdbc:mysql://localhost:3306/database";*/
    
    String USERNAME = Statics.USERNAME;
    String PASSWORD = Statics.PASSWORD;
    String CONN_STRING = Statics.CONN_STRING;

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
    {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        PrintWriter out = response.getWriter();
        /** Get Parameters from the Login Form  **/
        password = request.getParameter("lg_password");
        username = request.getParameter("lg_username");
        Connection conn = null;
        try 
        {   
            /** Get Connection and Execute the following query  **/
            Class.forName("com.mysql.jdbc.Driver");
            conn = (Connection) DriverManager.getConnection(CONN_STRING, USERNAME, PASSWORD);
            Statement statement = conn.createStatement();
            String getIdQuery = "SELECT id FROM users WHERE username = '" + username + "' AND password = '" + password + "' ";
            
            ResultSet result = statement.executeQuery(getIdQuery);
            st = result.next();
            if (st == false) 
            {   /** If the user does not exist in the database , Refresh the Login page and re-try**/
                Component frame = null;
                JOptionPane.showMessageDialog(frame, "Please try a different username");
                RequestDispatcher rd = request.getRequestDispatcher("index.html");
                rd.include(request, response);
            } else 
            {   /** If the user exists, go to select devices page **/
                this.id = result.getInt("id");
                response.sendRedirect("select_devices.jsp?id=" + this.id);
            }
            /** Close the connection **/
            statement.close();
            conn.close();
        } catch (SQLException e) 
        {
            System.err.println(e);
        } catch (ClassNotFoundException ex) 
        {
            Logger.getLogger(Member.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    /* Method to handle POST method request */

    @Override
    public void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException 
    {
        doGet(request, response);
    }
}
