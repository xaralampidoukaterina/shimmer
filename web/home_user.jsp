<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<!DOCTYPE HTML>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
        <title>Highcharts Example</title>
        <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js"></script>
        <script src="https://code.highcharts.com/highcharts.js"></script>
        <script src="https://code.highcharts.com/modules/exporting.js"></script>
        <link rel="stylesheet" href="index_css.css" type="text/css">
        <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
       
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
        <style type="text/css">
            ${demo.css}
        </style>
 <script type="text/javascript">
                  
               
$(function () {
    $(document).ready(function () {
        Highcharts.setOptions({
            global: {
                useUTC: false
            }
        });
        $('#container').highcharts({
            chart: {
                type: 'spline',
                animation: Highcharts.svg, // don't animate in old IE
                marginRight: 10,
                zoomType: 'x',
                panning: true,
                panKey: 'shift',
                plotBackgroundImage:'https://www.highcharts.com/samples/graphics/skies.jpg',
                events: {
                    load: function () {

                        // set up the updating of the chart each second
                        var series = this.series[0];
                        
                       
                        setInterval(function (table1) {
                            $.get('Table',function(responseJson) {
                                if(responseJson!==null){     
                                    var table1 ;
                                    $.each(responseJson, function(key,value) { 
                                        
                                        var rowNew = $("<tr><td></td><td></td><td></td><td></td><td></td><td></td></tr>");
                                        rowNew.children().eq(0).text(value['Id']); 
                                        rowNew.children().eq(1).text(value['Times']); 
                                        rowNew.children().eq(2).text(value['Mobile_device']); 
                                        rowNew.children().eq(3).text(value['Node_id']); 
                                        rowNew.children().eq(4).text(value['Channel_id']); 
                                        rowNew.appendTo(table1);
                                        var x = (new Date()).getTime();
                                        var y = value['Node_id'] ;
                                        series.addPoint([x, y], true, true);
                                        
                                    });
                                }
                               
                        });
                                    
 
                        }, 1000);
                    }
                }
            },
            title: {
                text: 'Live random data'
            },
            xAxis: {
                type: 'datetime',
                tickPixelInterval: 150
            },
            yAxis: {
                type: 'logarithmic',
                title: {
                    text: 'Value'
                },
                plotLines: [{
                    value: 0,
                    width: 1,
                    color: '#808080'
                }]
            },
            tooltip: {
                formatter: function () {
                    return '<b>' + this.series.name + '</b><br/>' +
                        Highcharts.dateFormat('%Y-%m-%d %H:%M:%S', this.x) + '<br/>' +
                        Highcharts.numberFormat(this.y, 2);
                }
            },
            legend: {
                enabled: false
            },
            exporting: {
                enabled: false
            },
            
            series: [{
                name: 'Random data',
                color: '#303030',
                data: (function () {
                    // generate an array of random data
                    var data = [],
                        time = (new Date()).getTime(),
                        i;

                    for (i = -19; i <= 0; i += 1) {
                        data.push({
                            x: time + i * 1000,
                            y: Math.random()
                        });
                    }
                    return data;
                }())
            }]
        });
    });
});
		</script>
    </head>
        <body class="body">
            <header class ="mainheader">
                <br>
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
        <div id="container" style="min-width: 310px; height: 400px; margin: 0 auto"></div>

    </body>
</html>