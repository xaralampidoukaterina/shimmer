/**
*   Created By Katerina Charalampidou
**/
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.reflect.TypeToken;

@WebServlet("/Table")
public class Table extends HttpServlet 
{
    private static final long serialVersionUID = 1L;
    public Table() {}

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
    {}

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
    {
        Gson gson = new Gson();
        /** mirror technic = assign to objects from Json  **/
        /** request example : Name: {"data":[{"channels":[{"channel":"acc_y","selectionSeries":0},{"channel":"acc_z","selectionSeries":1}],"deviceName":"android_6","nodeID":"3"},{"channels":[{"channel":"acc_z","selectionSeries":2}],"deviceName":"android_6","nodeID":"4"},{"channels":[{"channel":"acc_z","selectionSeries":3}],"deviceName":"android_6","nodeID":"6"}]}**/
        plotStartSelectionk selection = gson.fromJson(request.getParameterMap().entrySet().iterator().next().getKey(), plotStartSelectionk.class);

        ArrayList<PlotDataObj> measure = new ArrayList<PlotDataObj>();
        measure = FetchData.getAllMeasurements(selection);

        JsonElement element = gson.toJsonTree(measure, new TypeToken<List<PlotDataObj>>(){}.getType());
        JsonArray jsonArray = element.getAsJsonArray();
        response.setContentType("application/json");
        response.getWriter().print(jsonArray);
    }
}
