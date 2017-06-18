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
        <script src="https://code.highcharts.com/stock/highstock.js"></script>
        <script src="https://code.highcharts.com/highcharts.js"></script>
        <script src="https://code.highcharts.com/modules/exporting.js"></script>
        <link rel="stylesheet" href="index_css.css" type="text/css"> 
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
        <link rel="stylesheet" href ="https://cdn.datatables.net/1.10.15/css/jquery.dataTables.min.css">
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
        <script src ="https://cdn.datatables.net/1.10.15/js/jquery.dataTables.min.js"></script>
       
        <style type="text/css">
            ${demo.css}
        </style>
        <script type="text/javascript">             
            $(function () 
            {
                $(document).ready(function () 
                {
                    Highcharts.setOptions({
                        global: {
                            useUTC: false
                        }
                    });
                    //$('#container').highcharts(
                    //{
                    Highcharts.stockChart('container', 
                    {
                        chart: 
                        {
                            type: 'spline',
                            animation: Highcharts.svg, // don't animate in old IE
                            marginRight: 10,
                            zoomType: 'x',
                            panning: true,
                            panKey: 'shift',
                            //plotBackgroundImage:'https://www.highcharts.com/samples/graphics/skies.jpg',
                            borderColor: '#000000',
                            borderRadius: 20,
                            borderWidth: 2,
                            plotShadow: true,
                            backgroundColor: {
                                linearGradient: [0, 0, 500, 500],
                                stops: [
                                    [0, 'rgb(255, 255, 255)'],
                                    [1, 'rgb(200, 200, 255)']
                                ]
                            },
                            events: 
                            {
                                load: function () 
                                {
                                    // set up the updating of the chart each second
                                    var series = this.series[0];
                                    setInterval(function (table1) 
                                    {
                                        $.get('Table',function(responseJson) {
                                            if(responseJson!==null)
                                            {     
                                                var table1 ;
                                                $.each(responseJson, function(key,value) 
                                                { 
                                                    var rowNew = $("<tr><td></td><td></td><td></td><td></td><td></td><td></td></tr>");
                                                    rowNew.children().eq(0).text(value['Id']); 
                                                    rowNew.children().eq(1).text(value['Times']); 
                                                    rowNew.children().eq(2).text(value['Mobile_device']); 
                                                    rowNew.children().eq(3).text(value['Node_id']); 
                                                    rowNew.children().eq(4).text(value['Channel_id']); 
                                                    rowNew.children().eq(4).text(value['Value_row']);
                                                    rowNew.children().eq(4).text(value['Value_cal']);
                                                    rowNew.appendTo(table1);
                                                    //$('#example').append(table1);
                                                    var x = (new Date()).getTime();
                                                    var y = value['Value_cal'] ;
                                                    series.addPoint([x, y], true, true);
                                                });
                                            }
                                        });
                                    }, 1000);
                                }
                            }
                        },
                        rangeSelector: {
                            allButtonsEnabled: true,
                            buttonTheme: { // styles for the buttons
                                fill: 'none',
                                stroke: 'none',
                                'stroke-width': 0,
                                r: 8,
                                style: {
                                    color: '#039',
                                    fontWeight: 'bold'
                                },
                                states: {
                                    hover: {
                                    },
                                    select: {
                                        fill: '#039',
                                        style: {
                                            color: 'white'
                                        }
                                    }
                                }
                            },
                            buttons: [{
                                type: 'millisecond',
                                count: 10,
                                text: '10ms'
                            }, {
                                type: 'all',
                                text: 'All'
                            }],
                            inputDateFormat: '%H:%M:%S.%L',
                            inputEditDateFormat: '%H:%M:%S.%L',
                            // Custom parser to parse the %H:%M:%S.%L format
                            inputDateParser: function (value) {
                                value = value.split(/[:\.]/);
                                return Date.UTC(
                                    1970,
                                    0,
                                    1,
                                    parseInt(value[0], 10),
                                    parseInt(value[1], 10),
                                    parseInt(value[2], 10),
                                    parseInt(value[3], 10)
                                );
                            }

                        },
                        title: 
                        {
                            text: 'Shimmer Live Data'
                        },
                        subtitle: {
                            text: 'Click and drag to zoom in. Hold down shift key to pan.'
                        },
                        xAxis: 
                        {
                            type: 'datetime',
                            tickPixelInterval: 120
                        },
                        yAxis: 
                        {
                            //type: 'logarithmic',
                            opposite:false,
                            title: 
                            {
                                text: 'Value Cal'
                            },
                            plotLines: [
                            {
                                value: -4,
                                width: 1,
                                color: '#808080'
                            }],
                            minorGridLineColor: '#F0F0F0',
                            minorTickInterval: 'auto'
                        },
                        //tooltip: 
                        //{   
                         //   formatter: function () 
                         //   {
                          //      return '<b>' + this.series.name + '</b><br/><b>Timestamp :</b> <br/>' +
                          //      Highstock.dateFormat('%Y-%m-%d %H:%M:%S', this.x) + '<br/><b>Axis Y :</b><br/>' +
                          //      Highstock.numberFormat(this.y, 2);
                         //   }
                     //   },
                        legend: 
                        {
                            enabled: true,
                            shadow: true,
                            itemHiddenStyle: {
                                color: 'green'
                            },
                            itemHoverStyle: {
                                color: '#FF0000'
                            }
                        },
                        exporting: 
                        {
                            enabled: false
                        },
                        series: 
                        [{
                            name: 'Live data',
                            color: '#303030',
                            cursor: 'pointer',
                            shadow: true,
                            marker: {
                                enabled: true,
                                radius: 3
                            },
                            data: (function () 
                            {
                                // generate an array of random data
                                var data = [],
                                    time = (new Date()).getTime(),
                                    i,
                                    zero =0;
                                for (i = -19; i <= 0; i += 1) 
                                {
                                    data.push({
                                        x: time + i * 1000,
                                        y: zero//Math.random()
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
      
        <!div id="example" style="min-width: 310px; height: 400px; margin: 0 auto"><!div>
    </body>
</html>