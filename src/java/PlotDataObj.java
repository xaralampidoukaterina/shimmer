/**
 *  Created By Katerina Charalampidou
 **/

public class PlotDataObj 
{
    public PlotDataObj(int Id,String Times, String Mobile_device,int Node_id, String Channel_id,float Value_row,float Value_cal)
    {      
      this.setId(Id);
      this.setTimes(Times);
      this.setMobile_device(Mobile_device);
      this.setNode_id(Node_id);
      this.setChannel_id(Channel_id);
      this.setValue_row(Value_row);
      this.setValue_cal(Value_cal);
    }
        
    public PlotDataObj() {}
    
    private int Id;
    private String Times;
    private String Mobile_device;
    private int Node_id;
    private String Channel_id;   
    private float Value_row;
    private float Value_cal;
    private int selectionSeries;
    private float Value_cal_old;

    public void setSelectionSeries(int selectionSeries) 
    {
        this.selectionSeries = selectionSeries;
    }
     
    public void setId(int Id) 
    {
        this.Id = Id;
    }
    public void setTimes(String Times)
    {
        this.Times= Times;
    }
    public void setMobile_device(String Mobile_device)
    {
        this.Mobile_device = Mobile_device;
    }
    public void setNode_id(int Node_id)
    {
        this.Node_id = Node_id;
    }
    public void setChannel_id(String Channel_id)
    {
        this.Channel_id = Channel_id;
    }
    public void setValue_row(float Value_row)
    {
        this.Value_row = Value_row;
    }
    public void setValue_cal(float Value_cal)
    {
        this.Value_cal = Value_cal;
    }

    public float getValue_cal_old() 
    {
        return Value_cal_old;
    }

    public void setValue_cal_old(float Value_cal_old) 
    {
        this.Value_cal_old = Value_cal_old;
    }
    
    public int getId(){return Id;}
    public String getTimes(){return Times;}
    public String getMobile_device(){return Mobile_device;}
    public int getNode_id(){return Node_id;}
    public String getChannel_id(){return Channel_id;}
    public float getValue_row(){return Value_row;}
    public float getValue_cal(){return Value_cal;}
    
}
