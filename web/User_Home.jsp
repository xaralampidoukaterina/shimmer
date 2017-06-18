

<%@page import="java.awt.Component"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%-- 
    Document   : User_Home
    Created on : Dec 4, 2015, 6:09:58 PM
    Author     : Katerina
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="index_css.css" type="text/css" /> 
        <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
        <link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css">
       <%--graphs  --%>
    <script src="http://www.amcharts.com/lib/amcharts.js" type="text/javascript"></script>

     
	<script type="text/javascript" src="canvasjs.min.js"></script>
        <title>Home Page</title>
    </head>
    <body class="body">

	<header class ="mainheader">
            <br>
		<center><div class="name"><h1>Shimmer Web Application</h1>
		</div></center>
            <br>
            <nav class="navbar navbar-inverse">
              <div class="container-fluid">
                <div class="navbar-header">
                  <a class="navbar-brand" href="#">Shimmer Web App</a>
                </div>
                <div>
                  <ul class="nav navbar-nav navbar-right">
                    <li class="active" ><a href="index.html"> <span class="glyphicon glyphicon-log-out"></span></a></li>
                  </ul>
                </div>
              </div>
            </nav>
            
	
	</header>
  
      <script>
               <%
                    String USERNAME= "root";
                    String PASSWORD= "";
                    String CONN_STRING= "jdbc:mysql://localhost:3306/database";
                    request.setCharacterEncoding("UTF-8");
                    Connection conn =null;
                    Class.forName("com.mysql.jdbc.Driver");
                    conn = (Connection)DriverManager.getConnection(CONN_STRING,USERNAME,PASSWORD);
                    Statement statement = conn.createStatement();
                    String getIdQuery = "SELECT * FROM measurements ";
                    ResultSet result = statement.executeQuery(getIdQuery);  
                    result.next();
            %>
	window.onload = function () {
     
                  
                    
		var dps = []; // dataPoints

		var chart = new CanvasJS.Chart("chartContainer",{
			title :{
				text: "Live Random Data"
			},			
			data: [{
				type: "line",
				dataPoints: dps 
			}]
		});
                    
           
                    
		var xVal = 0;
		var yVal = 100;	
		var updateInterval = 100;
		var dataLength = 500; // number of dataPoints visible at any point

		var updateChart = function (count) {
                        
                        
			count = count || 1;
			// count is number of times loop runs to generate random dataPoints.
                        <%-- while (result.next()){ --%>
                        for (var j = 0; j < count; j++) {	

                                     yVal = yVal +  Math.round(5 + Math.random() *(-5-5));
                                     dps.push({
                                           
                                             x: xVal,
                                             y: yVal
                                     });
                                      <%-- result.next(); --%>
                                      xVal++;
                         };      
                        
			if(dps.length > dataLength)
			{
				dps.shift();				
			}
			
			chart.render();		
                         

		};

		// generates first set of dataPoints
		updateChart(dataLength); 

		// update chart after specified time. 
		setInterval(function(){updateChart();}, updateInterval); 
                 <%
                    statement.close();
                    conn.close();
                %>

	};
	</script>  
        
     
        <script>
          <%--
              String USERNAME= "root";
                    String PASSWORD= "root";
                    String CONN_STRING= "jdbc:mysql://localhost:3306/DataBase";
                    request.setCharacterEncoding("UTF-8");
                    Connection conn =null;
                    Class.forName("com.mysql.jdbc.Driver");
                    conn = (Connection)DriverManager.getConnection(CONN_STRING,USERNAME,PASSWORD);
                    Statement statement = conn.createStatement();
                    String getIdQuery = "SELECT * FROM measurements ";
                    ResultSet result = statement.executeQuery(getIdQuery);  
                    result.next();
             --    %>  
       
    var chart;
var chartData = [];
var chartCursor;
var day = 0;
var firstDate = new Date();
firstDate.setDate(firstDate.getDate() - 500);

// generate some random data, quite different range
function generateChartData() {
    for (day = 0; day < 50; day++) {
        var newDate = new Date(firstDate);
        newDate.setDate(newDate.getDate() + day);

        var visits = Math.round(Math.random() * 40) - 20;
        
        chartData.push({
            date: <%--= result.getString(2) %>,
            visits: <%--= result.getString(1)%>
        });
         <%--
             result.next();
       --  %>
    }
}

// create chart
AmCharts.ready(function() {
    // generate some data first
    generateChartData();

    // SERIAL CHART    
    chart = new AmCharts.AmSerialChart();
    chart.pathToImages = "http://www.amcharts.com/lib/images/";
    chart.marginTop = 0;
    chart.marginRight = 10;
    chart.autoMarginOffset = 5;
    chart.zoomOutButton = {
        backgroundColor: '#000000',
        backgroundAlpha: 0.15
    };
    chart.dataProvider = chartData;
    chart.categoryField = "date";

    // AXES
    // category
    var categoryAxis = chart.categoryAxis;
    categoryAxis.parseDates = true; // as our data is date-based, we set parseDates to true
    categoryAxis.minPeriod = "DD"; // our data is daily, so we set minPeriod to DD
    categoryAxis.dashLength = 1;
    categoryAxis.gridAlpha = 0.15;
    categoryAxis.axisColor = "#DADADA";

    // value                
    var valueAxis = new AmCharts.ValueAxis();
    valueAxis.axisAlpha = 0.2;
    valueAxis.dashLength = 1;
    chart.addValueAxis(valueAxis);

    // GRAPH
    var graph = new AmCharts.AmGraph();
    graph.title = "red line";
    graph.valueField = "visits";
    graph.bullet = "round";
    graph.bulletBorderColor = "#FFFFFF";
    graph.bulletBorderThickness = 2;
    graph.lineThickness = 2;
    graph.lineColor = "#b5030d";
    graph.negativeLineColor = "#0352b5";
    graph.hideBulletsCount = 50; // this makes the chart to hide bullets when there are more than 50 series in selection
    chart.addGraph(graph);

    // CURSOR
    chartCursor = new AmCharts.ChartCursor();
    chartCursor.cursorPosition = "mouse";
    chart.addChartCursor(chartCursor);

    // SCROLLBAR
    var chartScrollbar = new AmCharts.ChartScrollbar();
    chartScrollbar.graph = graph;
    chartScrollbar.scrollbarHeight = 40;
    chartScrollbar.color = "#FFFFFF";
    chartScrollbar.autoGridCount = true;
    chart.addChartScrollbar(chartScrollbar);

    // WRITE
    chart.write("chartdiv");
    
    // set up the chart to update every second
    setInterval(function () {
        // normally you would load new datapoints here,
        // but we will just generate some random values
        // and remove the value from the beginning so that
        // we get nice sliding graph feeling
        
        // remove datapoint from the beginning
        chart.dataProvider.shift();
        
        // add new one at the end
        day++;
        var newDate = new Date(firstDate);
        newDate.setDate(newDate.getDate() + day);
        var visits = Math.round(Math.random() * 40) - 20;
        chart.dataProvider.push({
            date:<%= result.getString(2) %>,
            visits:<%= result.getString(1) %>
        });
        <%result.next();%>
        chart.validateData();
    }, 1000);
});

   <%--
                    statement.close();
                    conn.close();
               --%>

        </script>
        
        
      <div id="chartContainer" style="height: 300px; width:100%;"></div>
    <%--  <div id="chartdiv" style="width: 100%; height: 340px;"></div>
      --%>
    <%--
                    String USERNAME= "root";
                    String PASSWORD= "root";
                    String CONN_STRING= "jdbc:mysql://localhost:3306/DataBase";
                    request.setCharacterEncoding("UTF-8");
                    Connection conn =null;
                    Class.forName("com.mysql.jdbc.Driver");
                    conn = (Connection)DriverManager.getConnection(CONN_STRING,USERNAME,PASSWORD);
                    Statement statement = conn.createStatement();
                    String getIdQuery = "SELECT * FROM measurements ";
                    ResultSet result = statement.executeQuery(getIdQuery);  
                    result.next();
            --%>
    
    
    
    </body>
</html>
