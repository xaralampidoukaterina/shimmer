/**
 *  Created By Katerina Charalampidou
 **/
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

public class FetchData 
{
    private static Connection connection = null;
    public static int i = 0;
    public static String name;
    public static String x_axis;
    public static String y_axis;
    public static boolean st = false;

    public static Connection getConnection() 
    {
        if (connection != null) 
        {
            return connection;
        } 
        else 
        {
            try 
            {   /** Get Connection **/
                String USERNAME = "root";
                String PASSWORD = "";
                String CONN_STRING = "jdbc:mysql://localhost:3306/database";
                Class.forName("com.mysql.jdbc.Driver");
                connection = (Connection) DriverManager.getConnection(CONN_STRING, USERNAME, PASSWORD);
            } 
            catch (ClassNotFoundException e) 
            {
                Logger.getLogger(FetchData.class.getName()).log(Level.SEVERE, null, e);
            } 
            catch (SQLException e) 
            {
                System.err.println(e);
            }
            return connection;
        }
    }

    public static ArrayList<PlotDataObj> getAllMeasurements(plotStartSelectionk selectionObj) 
    {
        connection = FetchData.getConnection();
        /** Create an array list of PlotDataObj **/
        ArrayList<PlotDataObj> List = new ArrayList<PlotDataObj>();
        try 
        {
            ArrayList<plotSelection> ploArrayList = selectionObj.getData();
            
            for (plotSelection plot : ploArrayList) 
            {
                String deviceName = plot.deviceName;
                for(ChannelObj channel:plot.channels)
                {
                    Statement statement = connection.createStatement();
                    //String query="select * from measurements  where mobile_device = '" + deviceName + "' and node_id='"+plot.nodeID+"' and channel_id = '" + channel.getChannel() +"'order by times desc limit 2 ";
                    String query="select * from measurements  where mobile_device = '" + deviceName + "' and node_id='"+plot.nodeID+"' and channel_id = '" + channel.getChannel() +"' and id>'"+String.valueOf(i) +"' limit 2 ";
                    i++;
                    ResultSet rs = statement.executeQuery(query);
                    while (rs.next()) 
                    {
                        i = rs.getInt("id");
                        /** measure is an array list **/
                        PlotDataObj measure = new PlotDataObj();
                        measure.setId(rs.getInt("id"));
                        measure.setTimes(rs.getString("times"));
                        measure.setMobile_device(rs.getString("mobile_device"));
                        measure.setNode_id(rs.getInt("node_id"));
                        measure.setChannel_id(rs.getString("channel_id"));
                        measure.setValue_row(rs.getFloat("value_row"));
                        measure.setValue_cal(rs.getFloat("value_cal"));
                        measure.setSelectionSeries(channel.getSelectionSeries());
                        if(rs.next())
                        {
                            measure.setValue_cal_old(rs.getFloat("value_cal"));
                        }
                        else
                        {
                          measure.setValue_cal_old(-1);  
                        }
                        List.add(measure);
                        break;
                    }
                }
            }
        } 
        catch (SQLException e) 
        {
            System.err.println(e);
        }
        return List;
    }

    public static ArrayList<Nodes> getAllNodes(String selection, ArrayList<String> deviceList) 
    {
        /** Get Connection **/
        connection = FetchData.getConnection();
        try 
        {
            int i = 0;
            ArrayList<String> mobile_devicesList = new ArrayList<String>();
            /** create a string **/
            String query = "(";
            for (String device : deviceList) 
            {   /** for every mobile device name added as a string **/
                query = query + "'" + device + "',";
            }
            query = query + ")";
            /** query is like (device,device,...,) **/
            /** and thats why we replace ',)' with ')' **/
            query = query.replace(",)", ")");
            /** finally query is like (device1,device2,...,device) **/
            /** accelometer / gyroscope / magnometer **/
            
            String filter = selection;
            String columns = "";
            /** get columns relative on users selection **/
            if (filter.equals("accelometer")) 
            {   
                columns = "mobile_device,channel_1,channel_2,channel_3,Position,address_id";
            } 
            else if (filter.equals("gyroscope")) 
            {
                columns = "mobile_device,channel_4,channel_5,channel_6,Position,address_id";
            } 
            else 
            {
                columns = "mobile_device,channel_7,channel_8,channel_9,Position,address_id";
            }
            /** do the query from nodes to get the channels **/
            String Query = "select " + columns + " from nodes where mobile_device in " + query;
            Class.forName("com.mysql.jdbc.Driver");
            connection = FetchData.getConnection();
            Statement statement = connection.createStatement();
            /** create an array list of nodes **/
            ArrayList<Nodes> nodeses = new ArrayList<Nodes>();
            ResultSet result = statement.executeQuery(Query);
            while (result.next()) 
            {   /** call setters and add into array list nodes mobile device name , channelx,channel,y,channelz and position **/
                Nodes nodes = new Nodes();
                nodes.setMobile_device(result.getString(1));
                nodes.setChannelX(result.getString(2));
                nodes.setChannelY(result.getString(3));
                nodes.setChannelZ(result.getString(4));
                nodes.setPosition(result.getString(5));
                 nodes.setNode_id(result.getString(6));
                nodeses.add(nodes);
            }
            return nodeses;
        } 
        catch (Exception e) 
        {
            e.printStackTrace();
        }
        return null;
    }
}
