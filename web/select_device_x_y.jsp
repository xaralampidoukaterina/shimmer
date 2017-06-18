<%-- 
    Document   : select_device_x_y
    Created on : Mar 4, 2017, 7:51:18 PM
    Author     : itsmuser
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Select Android</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="index_css.css" type="text/css"> 
        <link rel="stylesheet" href="select_x_y_css.css" type="text/css" />
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    </head>
    <body class="body">
        <header class ="mainheader">
            
           
            <center><div class="name"><h1>Shimmer Web Application</h1></div></center>
            <br>
            <nav class="navbar navbar-inverse">
              <div class="container-fluid">
                <div class="navbar-header"> 
                  <a class="navbar-brand" href="index.html">Shimmer Web App</a>
                </div>
                <div>
                  <ul class="nav navbar-nav">
                    <li class="active"><a href="index.html">Login Page</a></li>
                  </ul>
                  <ul class="nav navbar-nav navbar-right"><li><a href="index.html"><span class="glyphicon glyphicon-log-out"></span></a></li></ul>
                  <ul class="nav navbar-nav navbar-right">
                    <li><a href="create_account.jsp"><span class="glyphicon glyphicon-user"></span> Sign Up</a></li>
                  </ul>
                </div>
              </div>
            </nav>
        </header>
        <script>
    $(document).ready(function(){
        $("#hide").click(function(){
            $("button").hide();
            $("#select").fadeIn("slow");
            $("#device").fadeIn("slow");
            $("#x_axis").fadeIn("slow");
            $("#y_axis").fadeIn("slow");
            $("#start").fadeIn("slow");
        });
    });
    </script>
    <center><button class="button" id="hide">Start Streaming!</button></center>
    <form role="form" action="Plot_Axis" name="Plot_Axis" onsubmit="return validateForm()" method="POST" accept-charset="UTF-8">
        <div class="block" id="device" style="display:none;">
            <div class="name" style="margin-top: -10%;"><center><h3>Select the following and press Start !</h3></center></div>
                <div id="select" class="row" style="display:none;">
                    <div class="col-xs-3" style="margin-left: 38%;margin-top: 2%;">
                      <div class="form-group">
                            <label style ="text-align:center;" id ="online_device" for="online_device" class="form-control"><b>Online Device </b> </label>
                            <select name="online_device" id ="online_device" class="selectpicker form-control" onchange="">
                                <option value="0">Select Device</option>
                                <%
                                    try
                                    {
                                        request.setCharacterEncoding("UTF-8");
                                        response.setContentType("text/html; charset=UTF-8");
                                        String Query = "SELECT * FROM mobile_device WHERE status = 'ON' ";
                                        Class.forName("com.mysql.jdbc.Driver");
                                        Connection conn = (Connection)DriverManager.getConnection("jdbc:mysql://localhost:3306/database","root","");
                                        Statement statement = conn.createStatement();
                                        ResultSet result = statement.executeQuery(Query);
                                        while (result.next()) 
                                        {
                                            %>
                                            <option value="<%=result.getString(2)%>"><%=result.getString(2)%></option>
                                            <%
                                        }
                                    }
                                    catch(Exception ex)
                                    {
                                        ex.printStackTrace();
                                    }
                                %>
                            </select>
                      </div>
                    </div>
                </div>
                <div id="x_axis" class="row" style="display:none;">
                    <div class="col-xs-3" style="margin-left: 38%;">
                      <div class="form-group">
                            <label style ="text-align:center;" for="x_axis" id ="x_axis" class="form-control"><b>Select X Axis</b></label>
                            <select name="x_axis" id ="x_axis" class="selectpicker form-control">
                                <option value="0">Select Device</option>
                                <option value="Timestamp">Timestamp</option>
                            </select>
                      </div>
                    </div>
                </div>
                <div id="y_axis" class="row" style="display:none;">
                    <div class="col-xs-3" style="margin-left: 38%;">
                      <div class="form-group">
                            <label style ="text-align:center;" for="y_axis" id="y_axis" class="form-control"><b>Select Y Axis</b></label>
                            <select name="y_axis" id ="y_axis" class="selectpicker form-control">
                                <option value="0">Select Device</option>
                                <option value="acc_x">Acc_X</option>
                                <option value="acc_y">Acc_Y</option>
                                <option value="acc_z">Acc_Z</option>
                                <option value="gyro_x">Gyro_X</option>
                                <option value="gyro_y">Gyro_Y</option>
                                <option value="gyro_z">Gyro_Z</option>
                                <option value="mag_x">Mag_X</option>
                                <option value="mag_y">Mag_Y</option>
                                <option value="mag_z">Mag_Z</option>
                            </select>
                      </div>
                    </div>
                </div>

            <center><input class="button" value="Start Streaming!" id="start" type="submit" style="display:none; margin-top:5%; "></center>
        </div>
    </form>
    <script>
        function goBack() 
        {
            window.history.back();
        }
    </script>
    <script>
        function validateForm() 
        {

            if ((document.forms["Plot_Axis"]["online_device"].value === "0")) 
            {
                alert("Please select an android device");
                return false;
            }
            else if ((document.forms["Plot_Axis"]["x_axis"].value === "0"))
            {
                alert("Please select a value for x axis");
                return false;
            }
            else if ((document.forms["Plot_Axis"]["y_axis"].value === "0"))
            {
                alert("Please select a value for y axis");
                return false;
            }
        }
    </script>
    </body>
</html>
