/* 
 * Created By KCHARA . Last Updated 02/03/2017
 */
/* global Highcharts */

$.getScript(src="https://code.highcharts.com/highcharts.js");   
$.getScript(src="https://code.highcharts.com/modules/exporting.js");   
$.getScript(src="https://ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js"); 
$.demo.css;

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

