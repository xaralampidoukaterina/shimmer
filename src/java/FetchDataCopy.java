import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Properties;
 
 
public class FetchDataCopy {
 
    private static Connection connection = null;
    public static int i=0;
    public static String name;
    public static String x_axis;
    public static String y_axis;
    public static Connection getConnection() {
        if (connection != null)
            return connection;
        else {
            try {
                String USERNAME= "root";
                    String PASSWORD= "";
                    String CONN_STRING= "jdbc:mysql://localhost:3306/database";
                    Class.forName("com.mysql.jdbc.Driver");
                    connection = (Connection)DriverManager.getConnection(CONN_STRING,USERNAME,PASSWORD);
                    
               
            } catch (ClassNotFoundException e) {
                e.printStackTrace();
            } catch (SQLException e) {
                e.printStackTrace();
            } 
            return connection;
        }
 
    }
     
    public static ArrayList<PlotDataObj> getAllVariables_countries() {
     connection = FetchData.getConnection();
        ArrayList<PlotDataObj> List = new ArrayList<PlotDataObj>();
        try {
            boolean st = false;
            
            Statement statement = connection.createStatement();
            ResultSet result = statement.executeQuery("select * from plot");
            st = result.next();
            if (st != false) 
            {
                name = result.getString(2);
                x_axis = result.getString(3);
                y_axis = result.getString(4);
            }
            ResultSet rs = statement.executeQuery("select * from measurements  where mobile_device = '"+name+"' and channel_id = '"+y_axis+"' and id='"+i+"' limit 1");
            i++;
            while(rs.next()) { 
             PlotDataObj measure = new PlotDataObj();
             measure.setId(rs.getInt("id"));
             measure.setTimes(rs.getString("times"));
             measure.setMobile_device(rs.getString("mobile_device"));
             measure.setNode_id(rs.getInt("node_id"));
             measure.setChannel_id(rs.getString("channel_id"));
            
             List.add(measure);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
 
        return List;
    }
}