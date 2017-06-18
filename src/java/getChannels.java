/**
 *  Created By Katerina Charalampidou
 **/
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.reflect.TypeToken;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class getChannels extends HttpServlet  
{ 
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
    {}
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
    {
        
        /** create an array of nodes  **/
        ArrayList<Nodes> measure ;
        /** Create an array list with all devices **/
        ArrayList<String> deviceList = new ArrayList<String>();
        String filter = "";
        for(int i=0; i<request.getParameterMap().size(); i++)
        {
            if(i == request.getParameterMap().size()-1)
            {   /** if it is the last one save at variable filter the selection of the user acc/gyro/mag **/
                filter = request.getParameterMap().get(String.valueOf(i))[0];
            }
            else
            {   /** Add mobile device name into list of devices **/
                deviceList.add(request.getParameterMap().get(String.valueOf(i))[0]);
            }
        }
        /** call getAllNodes **/
        measure = FetchData.getAllNodes(filter, deviceList);
        Gson gson = new Gson();
        JsonElement element = gson.toJsonTree(measure, new TypeToken<List<Nodes>>() {}.getType());
        JsonArray jsonArray = element.getAsJsonArray();
        response.setContentType("application/json");
        response.getWriter().print(jsonArray);
    }
}
