/**
 * Created By Katerina Charalampidou
 */

/** Import required java libraries **/
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

/** Extend HttpServlet class **/
public class create_account extends HttpServlet 
{
    /** Initialize variables **/
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
        /** Get Parameters from create account form **/
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        PrintWriter out = response.getWriter();
        password = request.getParameter("reg_password");
        username = request.getParameter("reg_username");
        Connection conn = null;
        try 
        {   /** Get Connection with database **/
            Class.forName("com.mysql.jdbc.Driver");
            conn = (Connection) DriverManager.getConnection(CONN_STRING, USERNAME, PASSWORD);
            Statement statement = conn.createStatement();
            /** Search if the user already exists **/
            String getIdQuery = "SELECT id FROM users WHERE username = '" + username + "' ";
            ResultSet result = statement.executeQuery(getIdQuery);
            st = result.next();
            if (st == true) 
            {   /** If the user already exists,refresh page and re-try **/
                Component frame = null;
                JOptionPane.showMessageDialog(frame, "Please try to log in with different username");
                RequestDispatcher rd = request.getRequestDispatcher("create_account.jsp");
                rd.forward(request, response);
                /** Close the connection **/
                conn.close();
            } 
            else 
            {   /** If the user does not exists , create a new user into database **/
                String insertQuery = "INSERT INTO "
                        + " users (username,password)"
                        + " VALUES ("
                        + "'" + username + "',"
                        + "'" + password + "' "
                        + ")";
                statement.executeUpdate(insertQuery);
                statement.close();
                Component frame = null;
                /** Go to Login Page to enter with the new user **/
                JOptionPane.showMessageDialog(frame, "Please go to Login Page");
                RequestDispatcher rd = request.getRequestDispatcher("index.html");
                rd.forward(request, response);
                conn.close();
            }
        } catch (SQLException e) 
        {
            System.err.println(e);
        } catch (ClassNotFoundException ex) 
        {
            Logger.getLogger(Member.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    /* Method to handle POST method request. */
    @Override
    public void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException 
    {
        doGet(request, response);
    }
}
