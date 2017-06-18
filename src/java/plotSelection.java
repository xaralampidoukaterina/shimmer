/*
* Created By Katerina Charalampidou
**/
import java.util.ArrayList;

public class plotSelection 
{
    public String deviceName;
    public String nodeID;
    /** Create Array List of channels **/
    public ArrayList<ChannelObj> channels; 
            
    public String getDeviceName() 
    {
        return deviceName;
    }

    public String getNode_id() {
        return nodeID;
    }

    public void setNode_id(String node_id) {
        this.nodeID = node_id;
    }

    
    
    public void setDeviceName(String deviceName) 
    {
        this.deviceName = deviceName;
    }

    public ArrayList<ChannelObj> getChannels() 
    {
        return channels;
    }

    public void setChannels(ArrayList<ChannelObj> channels) 
    {
        this.channels = channels;
    }
}
