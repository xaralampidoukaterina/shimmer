/**
 * Created By Katerina Charalampidou
 **/
public class Nodes 
{
    /** Declare variables **/
    public String mobile_device;
    public String node_id;
    public String channelX;
    public String channelY;
    public String channelZ;
    public String position;

    public Nodes(String mobile_device, String channelX, String channelY, String channelZ, String position) 
    {
        this.mobile_device = mobile_device;
        this.channelX = channelX;
        this.channelY = channelY;
        this.channelZ = channelZ;
        this.position = position;
    }
            
    public Nodes() {}

    public String getMobile_device() 
    {
        return mobile_device;
    }

    public String getNode_id() {
        return node_id;
    }

    public void setNode_id(String node_id) {
        this.node_id = node_id;
    }

    public void setMobile_device(String mobile_device) 
    {
        this.mobile_device = mobile_device;
    }

    public String getChannelX() 
    {
        return channelX;
    }

    public void setChannelX(String channelX) 
    {
        this.channelX = channelX;
    }

    public String getChannelY() 
    {
        return channelY;
    }

    public void setChannelY(String channelY) 
    {
        this.channelY = channelY;
    }

    public String getChannelZ() 
    {
        return channelZ;
    }

    public void setChannelZ(String channelZ) 
    {
        this.channelZ = channelZ;
    }

    public String getPosition() 
    {
        return position;
    }

    public void setPosition(String position) 
    {
        this.position = position;
    }
    
    
    
    
}
