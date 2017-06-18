<!DOCTYPE html>
<%-- Created By Katerina Charalampidou  --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<html>
    <head>
        <title>Select Mobile Devices</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
        <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
        <link rel="stylesheet" href="select_devices_css.css" type="text/css" />
        <style>
            div.container 
            {   /** Set Background color of div with class == "container" **/
                background-color: #FFFFFF;
            }
            .body
            {   /** Set Background image of body **/
                background-image : url('networknodes.jpg');
            }
        </style>
    </head>
    <body class="body">
        <header class ="mainheader">
            <center><div class="name"><h1>Shimmer Web Application</h1></div></center>
            <br>
            <%-- Create Navigation Bar  --%>
            <nav class="navbar navbar-inverse">
                <div class="container-fluid">
                    <div class="navbar-header">
                        <a class="navbar-brand" href="index.html">Shimmer Web App</a>
                    </div>
                    <div>
                        <ul class="nav navbar-nav">
                            <li><a href="index.html">Login Page</a></li>
                        </ul>
                        <ul class="nav navbar-nav navbar-right"><li><a href="index.html"><span class="glyphicon glyphicon-log-out"></span></a></li></ul>
                        <ul class="nav navbar-nav navbar-right">
                            <li><a href="create_account.jsp"><span class="glyphicon glyphicon-user"></span>Sign Up</a></li>
                        </ul>
                    </div>
                </div>
            </nav>
        </header>
        <%
            try {
                /**
                 * Get Connection and execute the following query *
                 */
                request.setCharacterEncoding("UTF-8");
                response.setContentType("text/html; charset=UTF-8");
                /**
                 * Join tables mobile_device and nodes Execute this query to get
                 * the online devices and the position of its device using the
                 * node_id column
                 */
                String Query = "select *,GROUP_CONCAT(nd.position SEPARATOR '/') from mobile_device md,nodes nd where md.mobile_device=nd.mobile_device and md.node_id=nd.address_id and md.status='ON' GROUP by md.mobile_device";
                Class.forName("com.mysql.jdbc.Driver");
                Connection conn = (Connection) DriverManager.getConnection("jdbc:mysql://localhost:3306/database", "root", "");
                Statement statement = conn.createStatement();
                ResultSet result = statement.executeQuery(Query);
        %>
        <div> 
            <div class="container">
                <div class="text-center">               
                    <div class="text-center"><h4>Select Android Devices For Live Streaming</h4></div>  
                    <div class="text-right">
                        <button class="btn btn-primary btn-rounded text-left" onclick="goBack()"><span class="glyphicon glyphicon-arrow-left" aria-hidden="true"></span> Go Back</button>
                        <%-- Call function selectDevices() to get the devices which are checked by the user --%>
                        <button class="btn btn-primary btn-rounded text-right" onclick="selectDevices()">Stream Now <span class="glyphicon glyphicon-arrow-right" aria-hidden="true"></span></button>
                    </div>
                </div>
                <%-- Create table with available devices --%>
                <div class="row">
                    <div class="col-md-12">
                        <div class="table-responsive">
                            <%-- Refresh Button --%>
                            <button onclick="myFunction()"><span class="glyphicon glyphicon-refresh"></span> Refresh</button>
                            <table id="mytable" class="table table-bordred table-striped">   
                                <thead>
                                <th><input type="checkbox" id="checkall" /></th>
                                <th>#</th>
                                <th>Mobile Device</th>
                                <th>Type</th>
                                <th class="glyphicon glyphicon-map-marker"><b>GPS</b></th>
                                <th>Wearable Position</th>
                                <th>Status</th>
                                </thead>
                                <%                                        
                                    int i = 0;
                                    while (result.next()) 
                                    {
                                %>
                                <tbody>
                                    <tr>
                                        <%-- For each device get the appropriate information --%>
                                        <td><input id="<%= result.getString(2)%>" type="checkbox" class="checkthis" /></td>
                                        <td><%= i = i + 1%></td>
                                        <td class="mobile_device"><%= result.getString(2)%></td>
                                        <td><%= result.getString(3)%></td>
                                        <td><%= result.getString(4)%></td>
                                        <td><%= result.getString(20)%></td>
                                        <td><%= result.getString(5)%></td>
                                    </tr>
                                    <% }%> 
                                </tbody>
                            </table>
                        </div>
                        <div class="clearfix"></div>
                    </div>
                </div>      
            </div>
        </div>
        <script>
            function myFunction() 
            {
                location.reload();
            }
        </script>
        <script>
            $(document).ready(function ()
            { /** this function check or un check every record **/
                $("#mytable #checkall").click(function ()
                {   
                    if ($("#mytable #checkall").is(':checked'))
                    {   /** If all devices are checked **/
                        $("#mytable input[type=checkbox]").each(function ()
                        {   /** Flag all devices as checked **/
                            $(this).prop("checked", true);
                        });
                    } 
                    else
                    {
                        $("#mytable input[type=checkbox]").each(function ()
                        {   /** flag all devices as unchecked **/
                            $(this).prop("checked", false);
                        });
                    }
                });
            });
        </script>       
        <% }catch (Exception ex) 
            {
                ex.printStackTrace();
            }
        %>
        <script>
            function goBack()
            {   /** Go to previous page **/
                window.history.back();
            }

            function selectDevices()
            {
                /** Get elements from the table **/
                var elements = document.getElementsByClassName("mobile_device");
                var selected = [];
                for (var i = 0; i < elements.length; i++) 
                {   /** while elements exists and are checked insert them into table "selected[]" **/
                    if (document.getElementById(elements[i].textContent).checked) 
                    {   /**textContent = visible text**/
                        selected[selected.length] = elements[i].textContent;
                    }
                }
                if (selected.length <= 0)
                {   /** If table selected[] is empty show the following message **/
                    window.alert("Please select a device !");
                } 
                else
                {   /** Call the function post() for parsing the variables **/
                    post("Plot_Axis", selected, "post");
                }
            }


            function post(path, params, method)
            {
                method = method || "POST";
                var form = document.createElement("form"); /** Create html form **/
                form.setAttribute("method", method);    /** method = 'post' **/
                form.setAttribute("action", path);      /** action = 'Plot_Axis.java' **/
                for (var i = 0; i < params.length; i++)
                {
                    /** for every selected device create a hidden field which includes the name of the selected device **/
                    var hiddenField = document.createElement("input");
                    hiddenField.setAttribute("type", "hidden");
                    hiddenField.setAttribute("name", i);
                    hiddenField.setAttribute("value", params[i]); /** name of the selected device **/
                    form.appendChild(hiddenField); /** append hidden field into form **/
                }
                document.body.appendChild(form);/** append into document **/
                form.submit(); /** submit the form **/
            }
        </script>
    </body>
</html>
