<%-- Created By Katerina Charalampidou --%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<!DOCTYPE HTML>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
        <title>Stream</title>
        <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js"></script>
        <script src="https://code.highcharts.com/stock/highstock.js"></script>
        <script src="https://code.highcharts.com/highcharts.js"></script>
        <script src="https://code.highcharts.com/modules/exporting.js"></script>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
        <link rel="stylesheet" href ="https://cdn.datatables.net/1.10.15/css/jquery.dataTables.min.css">
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
        <script src ="https://cdn.datatables.net/1.10.15/js/jquery.dataTables.min.js"></script>
        <style type="text/css">
            ${demo.css}
            div.containerTable 
            {   /** Set the background color of div with class ="containerTable" **/
                background-color: #FFFFFF;
            }
            .body
            {   /** Set the body image **/
                background-image : url('networknodes.jpg');
            }
        </style>
        <script type="text/javascript">
            var refreshIntervalId;
            /** Create Function getRandomColor to get different color for each line while streaming **/
            function getRandomColor() 
            {
                var letters = '0123456789ABCDEF';
                var color = '#';
                for (var i = 0; i < 6; i++) 
                {
                    color += letters[Math.floor(Math.random() * 16)];
                }
                return color;
            }

            function startPlotting(selected, count)
            {
                var count = 0;
                var seriesList = []; /** declare a series list **/
                for (i = 0; i < selected.data.length; i++)
                {
                    if (selected.data[i].channels.length > 0)
                    {   /** for each channel create a plot line **/
                        for (j = 0; j < selected.data[i].channels.length; j++)
                        {
                            var series1 =
                            {/** For each line set the following **/
                                name: selected.data[i].deviceName + " " + selected.data[i].channels[j].channel,
                                color: getRandomColor(),
                                cursor: 'pointer',
                                shadow: true,
                                marker:
                                {
                                    enabled: true,
                                    radius: 3
                                },
                                data: (function ()
                                {
                                    /** generate an array of random data , initialize datagram **/
                                    var data = [],
                                            time = (new Date()).getTime(),
                                            i,
                                            zero = 0;
                                    for (i = -19; i <= 0; i += 1)
                                    {
                                        data.push({
                                            x: time + i * 1000,
                                            y: zero//Math.random()
                                        });
                                    }
                                    return data;
                                }())
                            };
                            /** Set selectionSerries as count **/
                            selected.data[i].channels[j].selectionSeries = count;
                            /** Set serries into an array list **/
                            seriesList[count] = series1;
                            count++;
                        }
                    }
                }

                var selectionObj = new Object();
                var i = 0;
                for (i = 0; i < selected.length; i++)
                {   /** create a list for json **/
                    selectionObj[i] = selected[i];
                }

                Highcharts.setOptions
                ({/** Sets the options globally for all charts created after this has been called **/
                    global:
                            {/** using UTC is that the time displays equally regardless of the user agent's time zone settings **/
                                useUTC: false
                            }
                });

                Highcharts.stockChart('container',
                {
                    chart:
                    {
                        type: 'spline', /** chart type **/
                        animation: Highcharts.svg, /** don't animate in old IE **/
                        marginRight: 10,
                        zoomType: 'x', /** The zoomType option is set to "x" **/
                        panning: true,
                        panKey: 'shift',
                        borderColor: '#000000',
                        borderRadius: 20,
                        borderWidth: 2,
                        plotShadow: true,
                        backgroundColor: 
                        {
                            linearGradient: [0, 0, 500, 500],
                            stops: 
                            [
                                [0, 'rgb(255, 255, 255)'],
                                [1, 'rgb(200, 200, 255)']
                            ]
                        },
                        events:
                        {
                            load: function ()
                            { /** set up the updating of the chart each second **/
                                var obj = this;
                                refreshIntervalId = setInterval(function (table1)
                                {
                                    $.post('Table', JSON.stringify(selected), function (responseJson) 
                                    {
                                        $("#cal_table  tbody").empty();
                                        if (responseJson !== null)
                                        {
                                            var table1;
                                            $('#cal_table_body').empty();
                                            $.each(responseJson, function (key, value)
                                            {
                                                var rowNew = $("<tr  id='" + value['mobile_device'] + "+" + value['Channel_id'] + "'><td></td><td></td><td ></td><td></td><td ></td><td></td><td></td><td></td></tr>");
                                                rowNew.children().eq(0).text(value['Id']);
                                                rowNew.children().eq(1).text(value['Times']);
                                                rowNew.children().eq(2).text(value['Mobile_device']);
                                                rowNew.children().eq(3).text(value['Node_id']);
                                                rowNew.children().eq(4).text(value['Channel_id']);
                                                rowNew.children().eq(5).text(value['Value_row']);
                                                rowNew.children().eq(6).text(value['Value_cal_old']);
                                                rowNew.children().eq(7).text(value['Value_cal']);
                                                rowNew.appendTo(table1);
                                                var x = (new Date()).getTime();
                                                var y = value['Value_cal'];
                                                $('#cal_table_body').append(rowNew);
                                                obj.series[value['selectionSeries']].addPoint([x, y], true, true);
                                            });
                                        }
                                    });
                                }, 1000);
                            }
                        }
                    },
                    rangeSelector: /** The range selector is a tool for selecting ranges to display within the chart **/
                    {
                        allButtonsEnabled: true,
                        buttonTheme: 
                        {   /** styles for the buttons **/
                            fill: 'none',
                            stroke: 'none',
                            'stroke-width': 0,
                            r: 8,
                            style: 
                            {
                                color: '#039',
                                fontWeight: 'bold'
                            },
                            states: 
                            {
                                hover: {},
                                select: 
                                {
                                    fill: '#039',
                                    style: 
                                    {
                                        color: 'white'
                                    }
                                }
                            }
                        },
                        buttons: 
                        [
                            {
                                type: 'millisecond',
                                count: 10,
                                text: '10ms'
                            }, 
                            {
                                    type: 'all',
                                    text: 'All'
                            }
                        ],
                        inputDateFormat: '%H:%M:%S.%L',
                        inputEditDateFormat: '%H:%M:%S.%L',
                        /* Custom parser to parse the %H:%M:%S.%L format */
                        inputDateParser: function (value) 
                        {
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
                    subtitle: 
                    {
                        text: 'Click and drag to zoom in. Hold down shift key to pan.'
                    },
                    xAxis:
                    {
                        type: 'datetime',
                        tickPixelInterval: 120
                    },
                    yAxis:
                    {
                        opposite: false,
                        title:
                        {
                            text: 'Value Cal'
                        },
                        plotLines: 
                        [   /** An array of lines stretching across the plot area, marking a specific value on one of the axes **/
                            {
                                value: -4,
                                width: 1,
                                color: '#808080'
                            }
                        ],
                        minorGridLineColor: '#F0F0F0',
                        minorTickInterval: 'auto'
                    },
                    legend:
                    {   /** The legend is a box containing a symbol and name for each series item or point item in the chart **/
                        enabled: true,
                        shadow: true,
                        itemHiddenStyle: 
                        {
                            color: 'green'
                        },
                        itemHoverStyle: 
                        {
                            color: '#FF0000'
                        }
                    },
                    exporting:
                    {   /** Experimental setting to allow HTML inside the chart (added through the useHTML options), directly in the exported image **/
                        enabled: false
                    },
                    series:
                            seriesList
                });
            }

            function submitMetricsForm(selection)
            {   /** Selection is accelerometer or magnometer or gyroscope **/
                if (selection === "accelometer") 
                {   /** if the user selected "acc   elometer" then do the other tabs deactive **/
                    document.getElementById("accelometerTab").setAttribute("class", "active");
                    document.getElementById("gyroscopeTab").setAttribute("class", "deactive");
                    document.getElementById("magnoscopeTab").setAttribute("class", "deactive");
                } else if (selection === "gyroscope") 
                {   /** if the user selected "gyroscope" then do the other tabs deactive **/
                    document.getElementById("gyroscopeTab").setAttribute("class", "active");
                    document.getElementById("accelometerTab").setAttribute("class", "deactive");
                    document.getElementById("magnoscopeTab").setAttribute("class", "deactive");
                } else 
                {   /** if the user selected "magnometer" then do the other tabs deactive **/
                    document.getElementById("magnoscopeTab").setAttribute("class", "active");
                    document.getElementById("gyroscopeTab").setAttribute("class", "deactive");
                    document.getElementById("accelometerTab").setAttribute("class", "deactive");
                }
                /** get mobile device names into an array **/
                var elements = document.getElementsByClassName("deviceName");
                var selected = new Object();
                var i = 0;
                for (i = 0; i < elements.length; i++) 
                {   /** insert every mobile device name into array of objects "selected[]" **/
                    selected[i] = elements[i].value;
                }
                /** add as final entry of the table with the mobile devices names the selection of the user acc/gyro/mag **/
                selected[i] = selection;
                /* call post method */
                $.post("getChannels",selected,
                    function (response) 
                    {
                        if (response !== null)
                        {   /** while response is not null **/
                            $("#mytable  tbody").empty();
                            var table1;
                            $.each(response, function (key, value)
                            {   /** for each record create a new row **/
                                var rowNew = $("<tr class='rowsDevice' id='" + value['mobile_device']+"/" +value['node_id']+ "' ><td></td><td></td><td></td><td></td><td></td></tr>");
                                rowNew.children().eq(0).text(value['mobile_device']);

                                if ((typeof (value['channelX']) === "undefined")) 
                                {   /** make it disable **/
                                    rowNew.children().eq(1).html("<input id='" + value['channelX'] + "' name='" + value['mobile_device'] + "'  type='checkbox' class='checkthis' disabled/>");
                                } 
                                else 
                                {   /** available to check channel x **/
                                    rowNew.children().eq(1).html("<input id='" + value['channelX'] + "' name='" + value['mobile_device'] + "' type='checkbox' class='checkthis' />");
                                }

                                if ((typeof (value['channelY']) === "undefined")) 
                                {   /** make it disable **/
                                    rowNew.children().eq(2).html("<input id='" + value['channelY'] + "' name='" + value['mobile_device'] + "' type='checkbox' class='checkthis' disabled/>");
                                } 
                                else 
                                {    /** available to check channel y **/
                                    rowNew.children().eq(2).html("<input id='" + value['channelY'] + "' name='" + value['mobile_device'] + "' type='checkbox' class='checkthis' />");
                                }


                                if ((typeof (value['channelZ']) === "undefined")) 
                                {   /** make it disable **/
                                    rowNew.children().eq(3).html("<input id='" + value['channelZ'] + "' name='" + value['mobile_device'] + "' type='checkbox' class='checkthis' disabled/>");
                                }
                                else 
                                {    /** available to check channel z **/
                                    rowNew.children().eq(3).html("<input id='" + value['channelZ'] + "' name='" + value['mobile_device'] + "' type='checkbox' class='checkthis' />");
                                }
                                rowNew.children().eq(4).text(value['position']);
                                $('#tableBody').append(rowNew);
                            });
                        }
                    });
            }
            /** initializing datagram **/
            $(function ()
            {
                $(document).ready(function ()
                {
                    submitMetricsForm("accelometer");
                    Highcharts.setOptions
                    ({
                        global: 
                        {
                            useUTC: false
                        }
                    });
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
                            borderColor: '#000000',
                            borderRadius: 20,
                            borderWidth: 2,
                            plotShadow: true,
                            backgroundColor: 
                            {
                                linearGradient: [0, 0, 500, 500],
                                stops: 
                                [
                                    [0, 'rgb(255, 255, 255)'],
                                    [1, 'rgb(200, 200, 255)']
                                ]
                            },
                            events:
                            {
                                load: function (){}
                            }
                        },
                        rangeSelector: 
                        {
                            allButtonsEnabled: true,
                            buttonTheme: 
                            {   /** styles for the buttons **/
                                fill: 'none',
                                stroke: 'none',
                                'stroke-width': 0,
                                r: 8,
                                style: 
                                {
                                    color: '#039',
                                    fontWeight: 'bold'
                                },
                                states: 
                                {
                                    hover: {},
                                    select: 
                                    {
                                        fill: '#039',
                                        style: 
                                        {
                                            color: 'white'
                                        }
                                    }
                                }
                            },
                            buttons: 
                            [
                                {
                                    type: 'millisecond',
                                    count: 10,
                                    text: '10ms'
                                }, 
                                {
                                   type: 'all',
                                   text: 'All'
                                }
                            ],
                            inputDateFormat: '%H:%M:%S.%L',
                            inputEditDateFormat: '%H:%M:%S.%L',
                            inputDateParser: function (value) 
                            {
                                value = value.split(/[:\.]/);
                                return Date.UTC
                                (
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
                        subtitle: 
                        {
                            text: 'Click and drag to zoom in. Hold down shift key to pan.'
                        },
                        xAxis:
                        {
                            type: 'datetime',
                            tickPixelInterval: 120
                        },
                        yAxis:
                        {
                            opposite: false,
                            title:
                            {
                                text: 'Value Cal'
                            },
                            plotLines: 
                            [
                                {
                                    value: -4,
                                    width: 1,
                                    color: '#808080'
                                }
                            ],
                            minorGridLineColor: '#F0F0F0',
                            minorTickInterval: 'auto'
                        },
                        legend:
                        {
                            enabled: true,
                            shadow: true,
                            itemHiddenStyle: 
                            {
                                color: 'green'
                            },
                            itemHoverStyle: 
                            {
                                color: '#FF0000'
                            }
                        },
                        exporting:
                        {
                            enabled: false
                        },
                        series: []
                    });
                    clearInterval(refreshIntervalId);
                });
            });
        </script>
    </head>
    <body class="body">
        <header class ="mainheader">
            <br>
            <center><div class="name"><h1>Shimmer Web Application</h1></div></center>
            <br>
            <%-- Create Navigation Bar --%>
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
        <%-- Create Channel table --%>
        <div class="row">
            <div class ="col-lg-3" id="containerTable"  style="min-width: 310px; height: 400px; margin: 0 auto">
                <aside class="well">
                    <div class ="row">
                        <div class ="col-lg-12">
                            <div class="form-group">
                                <a class="text-left" href="javascript:{}" onclick="myFunction()"><span class="glyphicon glyphicon-refresh"></span></a>
                                <center><label class="text-center" for ="env-modality">Shimmer Channel</label></center>
                                <div class="tabbable">
                                    <ul class="nav nav-tabs nav-justified">
                                        <%-- on click submit metrics form --%>
                                        <li class="active" id="accelometerTab" ><a href="javascript:{}" onclick="submitMetricsForm('accelometer');" ><h6>Acc/meter</h6></a></li>
                                        <li  id="gyroscopeTab" ><a href="javascript:{}" onclick="submitMetricsForm('gyroscope');" ><h6>Gyroscope</h6></a></li>
                                        <li  id="magnoscopeTab" ><a href="javascript:{}" onclick="submitMetricsForm('magnoscope');" ><h6>Magnometer</h6></a></li>
                                    </ul>
                                </div>
                                <input type="hidden" id="selection" name="selection"/>
                                <div class="table-responsive"> 
                                    <%
                                        int i = 0;
                                        /** Create an array List of the devices **/
                                        ArrayList<String> mobile_devicesList = new ArrayList<String>();
                                        /** request = form from the previous page **/
                                        while (request.getParameter(String.valueOf(i)) != null) 
                                        {   /** while device name exists added at the mobile device list and then display the device name **/
                                            mobile_devicesList.add(request.getParameter(String.valueOf(i)));
                                    %>
                                    <input type="hidden" class="deviceName" value="<%= request.getParameter(String.valueOf(i))%>"/>
                                    <%
                                            i++;
                                        }
                                    %>
                                    <table id="mytable" class="table table-bordred table-striped" >   
                                        <thead>
                                            <th>Mobile Device</td>
                                            <th>X</td>
                                            <th>Y</td>
                                            <th>Z</td>
                                            <th>Position</td>
                                        </thead>
                                        <tbody id="tableBody"></tbody> 
                                    </table>
                                    <div class="text-center">
                                    <%-- Call function goBack() , going to previous page --%>
                                    <button class="btn btn-default btn-primary" onclick="goBack()"><span class="glyphicon glyphicon-arrow-left" aria-hidden="true"></span> Go Back</button>
                                        <%-- Call function stop(), stops streaming --%>
                                    <button class="btn btn-default btn-danger" onclick="stop()"><span class="glyphicon glyphicon-stop" aria-hidden="true"></span></button>
                                        <%-- Start Streaming --%>
                                    <button class="btn btn-default btn-success" onclick="start()"><span class="glyphicon glyphicon-play" aria-hidden="true"></span></button>
                                    </div>
                                </div>
                            </div>
                        </div>       
                    </div>
                </aside>
            </div> 
            <div id="container" class="col-lg-9" style="min-width: 310px; height: 400px; margin: 0 auto"></div>
            <div class ="col-lg-3" id="containerTable"  style="min-width: 310px; height: 400px; margin: 0 auto"></div>
            <div class ="col-lg-9" id="containerTable"  style="min-width: 310px; height: 400px; padding-top: 10px;">
                <aside class="well">
                    <div class ="row">
                        <div class ="col-lg-12">
                            <div class="form-group">
                                <label for ="env-modality">Shimmer Plot Values</label> 
                                <div class="table-responsive"> 
                                    <input type="hidden" class="deviceName" value="<%= request.getParameter(String.valueOf(i))%>"/>
                                    <table id="cal_table" class="table table-bordred table-striped" >   
                                        <thead>
                                            <th>id</th>
                                            <th>TimeStamp</th>
                                            <th>mobile device</th>
                                            <th>Node ID</th>
                                            <th>Channel ID</th>
                                            <th>Value Row</th>
                                            <th>Old Value Cal</th>
                                            <th>Value Cal</th>
                                        </thead>
                                        <tbody id="cal_table_body"></tbody> 
                                    </table>
                                </div>
                            </div>
                        </div>       
                    </div>
                </aside>
            </div> 
        </div>
        <script>
            function myFunction() 
            {
                location.reload();
            }
            function stop()
            {   /** Stop streaming **/
                clearInterval(refreshIntervalId);
            }
            function goBack()
            {   /** Go to previous page **/
                window.history.back();
            }
            function start()
            {   /** Start Streaming **/
                var data = {};
                var TotalList = [];
                var count = 0;
                /** Get all devices rows **/
                var rowElements = document.getElementsByClassName("rowsDevice");
                for (var i = 0; i < rowElements.length; i++)
                {   /** create table devices[] **/
                    var devices = {channels: []};
                    /** get all mobile devices **/
                    var elements = rowElements[i].getElementsByClassName("checkthis");
                    /** get mobile device name **/
                    devices.deviceName = rowElements[i].id.split("/")[0];
                    devices.nodeID = rowElements[i].id.split("/")[1];
                    for (var j = 0; j < elements.length; j++)
                    {   /** Count checked mobile devices and insert channels into devices table **/
                        if (elements[j].checked)
                        {
                            var singleObj = {};
                            count++;
                            /** save channels for each mobile device **/
                            singleObj['channel'] = elements[j].id;
                            devices.channels.push(singleObj);
                        }
                    }
                    /** List of elements **/
                    TotalList[TotalList.length] = devices;
                }
                /** Object gson with key = data and value = list of devices **/
                data['data'] = TotalList;
                startPlotting(data, count);
            }
        </script>
    </body>
</html>