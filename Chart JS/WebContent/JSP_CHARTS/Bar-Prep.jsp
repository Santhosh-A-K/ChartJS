<%@ page import = "java.io.*,java.util.*,org.json.*,java.sql.*"%>
<%@ page import = "javax.servlet.http.*,javax.servlet.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix = "c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix = "sql"%>
<html>

<head>
	<link rel="stylesheet" href="../CSS/main.css">
	<script src="../JS/Chart.bundle.js"></script>
	<script src="../JS/utils.js"></script>
	<script src="../JS/functions.js"></script>
	<script src="../JS/chartjs-plugin-labels.js"></script>
	<script src="../JS/chroma.js"></script>
	<script src="../JS/jquery-3.4.1.min.js"></script>
	<style type="text/css">
/* 	.chartWrapper {
  position: relative;
}

.chartWrapper > canvas {
  position: absolute;
  left: 0;
  top: 0;
  pointer-events: none;
}

.chartAreaWrapper {
  width: 600px;
  overflow-x: scroll;
} */

        .chartWrapper {
            position: relative;
            
        }

        .chartWrapper > canvas {
            position: absolute;
            left: 0;
            top: 0;
            pointer-events:none;
        }
.chartAreaWrapper {
          overflow-x: scroll;
            position: relative;
            width: 100%;
        }

        .chartAreaWrapper2 {
          
            position: relative;
            height: 300px;
        }

	
		</style>
	
</head>

<body>

    <div>
    <div >
			<label>Top N Merchants</label><input type="number" id="topdis" name="topdis" onkeydown="assignTopValue()" style="width:35%;"/>
			<button id="clearFilter" onclick="clearFilter()">X</button>
		</div>
		<div >
			<button id="barChange" onclick="barChange()">Change</button>
			<label>Select Chart Type</label>
			<select id ="ddl" name="ddl"  onchange="changeChart(this.value);">
			  <option value='bar'>Bar</option>
			  <option value='line'>Line</option>
			  <option value='doughnut'>Doughnut</option>
			</select>
		</div>
    </div>


<div>
 <div id="container" style="width: 50%;float:left;">
 		
		<%-- <canvas id="canvas"></canvas> --%>
		<div class="chartWrapper">
      <div class="chartAreaWrapper">
        <div class="chartAreaWrapper2">
            <canvas id="myChart"></canvas>
        </div>
      </div>
        
        <canvas id="myChartAxis" height="300" width="0"></canvas>
    </div>
</div>

<div id="container1" style="width: 50%;float:right;">
		<canvas id="sumDate"></canvas>
</div>
	</div> 
<div>

<div id="container2" style="width: 50%;float:left;">
		<canvas id="weekday"></canvas>
</div>
<div id="container3" style="width: 50%;float:right;">
		<canvas id="doughnut"></canvas>
</div>

</div>


<%       
Connection con=null;
PreparedStatement stmt=null;
ResultSet rs=null;

// Remember to change the next line with your own environment 
String url="jdbc:oracle:thin:@10.44.113.13:1527:ACMDB";
String id= "AWSPOC";
String pass = "pocaws321#";
try{

Class.forName("oracle.jdbc.OracleDriver");
 con = DriverManager.getConnection(url, id, pass);

}catch(ClassNotFoundException cnfex){
cnfex.printStackTrace();

}
//String sumAmountDateMrch="select TO_CHAR(CAST(MPT_REQ_DATE AS date),'yyyy-MM-dd') as dates,mpt_merc_id,sum(CAST(mpt_txn_amt AS int)) as sum from AFS_DEMO group by TO_CHAR(CAST(MPT_REQ_DATE AS date),'yyyy-MM-dd'),mpt_merc_id order by TO_CHAR(CAST(MPT_REQ_DATE AS date),'yyyy-MM-dd')";
String sumAmountDateMrch="select TO_CHAR(CAST(MPT_REQ_DATE AS date),'yyyy-MM-dd') as dates,mpt_merc_id,sum(CAST(mpt_txn_amt AS int)) as sum,MPT_STAT_NAME from AFS_DEMO group by TO_CHAR(CAST(MPT_REQ_DATE AS date),'yyyy-MM-dd'),mpt_merc_id,MPT_STAT_NAME order by sum(CAST(mpt_txn_amt AS int)) desc";


//sumAmountDateMrch sql query
try{
	stmt=con.prepareStatement(sumAmountDateMrch);
	 rs=stmt.executeQuery(); 
	 JSONArray jsonArraySumAmount = new JSONArray();
while (rs.next()) {
    int total_rows = rs.getMetaData().getColumnCount();
    JSONObject obj = new JSONObject();
    for (int i = 0; i < total_rows; i++) {
        
        obj.put(rs.getMetaData().getColumnLabel(i + 1)
                .toLowerCase(), rs.getObject(i + 1));
        
    }
    jsonArraySumAmount.put(obj);
}

%>
<script type="text/javascript">
var sumAmountDateMrchJs=<%=jsonArraySumAmount%>;





</script>
<%
	
}
catch(Exception e)
{
	e.printStackTrace();
}
finally{
if(con!=null) con.close();
}
 %>
 <script>
 var flagTop=false;
 var flag=false;
 var targetLabels=[];
 var color = Chart.helpers.color;
 var targetDataset=[{label:"TotalAmount", backgroundColor: color(window.chartColors.blue).alpha(0.5).rgbString(),data:[]}];
 var data=[];
 var label=[];
 var dateLabels = [];
 var dateDataset = [{label:"TotalAmount", backgroundColor: color(window.chartColors.blue).alpha(0.5).rgbString(),data:[]}];
 var weekdayLabels=[];						//lineTension: 0,fill: false -->to display in straight line and fill no
 var weekdayDataset = [{label:"TotalAmount", backgroundColor: color(window.chartColors.blue).alpha(0.5).rgbString(),data:[]}];
 var doughnutLabel=['VISA','MASTERCARD','OMANNET','OTHERS'];
 var doughnutData= [{label:"Txncount",backgroundColor: ['#903031','#7f7f7f','#344e63','#f2f2f2','#243746'],data:[0,0,0,0]}];
 //"#8e5ea2","#3cba9f",color(window.chartColors.blue).alpha(0.6).rgbString(),"#e8c3b9","#c45850"
 
 
 
 





  /* var BarChartData = getBarchartDataMerchID();
 	//console.log(targetDataset);
 	
 	var barCtx = document.getElementById('canvas').getContext('2d');
 	var merchIdConfigBar={
 			type: 'bar',
 			data: BarChartData,
 			maintainAspectRatio: false,
 		    responsive: true, 
 			options: {
 				 onClick: function(evt, item)  {
 					 var temp=BarChart.getDatasetAtEvent(evt);
 					var index = item[0]["_index"];
 					var axesVal = item[0]["_chart"].data.labels[index];
 					var chartVal = item[0]["_chart"].data.datasets[0].data[index];
 					var dateData=[];
 					var dateLabel=[];
 					var weekdayLabel=['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'];
 					var weekData=[0,0,0,0,0,0,0];
 					var doughnutLabelTemp=['VISA','MASTERCARD','OMANNET','OTHERS'];
 					var doughnutDataTemp=[0,0,0,0];
 					sumAmountDateMrchJs.forEach(function(o){
 						if(o.mpt_merc_id==axesVal)
 							{
 								var val=new Date(String(o.dates)).getDay();
 								weekData[val]=weekData[val]+parseInt(o.sum);
 								dateData.push(o.sum);
 								dateLabel.push(o.dates);
 								if(String(o.mpt_stat_name).includes("OMANNET"))
 								{
 									doughnutDataTemp[doughnutLabelTemp.indexOf("OMANNET")]+=1;
 								}
 								else if(String(o.mpt_stat_name).includes("VISA"))
 								{
 									doughnutDataTemp[doughnutLabelTemp.indexOf("VISA")]+=1;
 								}
 								else if(String(o.mpt_stat_name).includes("MASTERCARD"))
 								{
 									doughnutDataTemp[doughnutLabelTemp.indexOf("MASTERCARD")]+=1;
 								}
 								else
 								{
 									doughnutDataTemp[doughnutLabelTemp.indexOf("OTHERS")]+=1;
 								}
 							}
 						 });
 					var sort=sortLabelAndData(dateData,dateLabel,"label","asc");
 					dateData=[];
 					dateLabel=[];
 					sort.forEach(function(t){
 						dateData.push(t.data);
 						dateLabel.push(t.label);
 					});	 
 					lineChart.data.labels=dateLabel;
 					lineChart.data.datasets[0].data=dateData;
 					weekDayChart.data.labels=weekdayLabel;
 					weekDayChart.data.datasets[0].data=weekData;
 					doughnutChart.data.labels=doughnutLabelTemp;
 					doughnutChart.data.datasets[0].data=doughnutDataTemp;
 					lineChart.update();
 					weekDayChart.update(); 
 					doughnutChart.update(); 
 		            
 		        }, 
 			
 				elements: {
 					rectangle: {
 						borderWidth: 2
 					}
 				},
 				responsive: true,
 				legend: {
 					//display: false
 					position: 'right'
 				},
 				title: {
 					display: true,
 					text: 'Transaction Value in Million'
 				},
 				 plugins: {
 				       labels: {
 				    	  render:  function (args) {
 				    		  //findLabel(targetDataset[0].data);
 				    		  //return axesRange("$",args.value,axeslabel);
 				    	      //return '$' + args.value;
 				    	      return "";
 				    	    }
 				      } 
 				}, 
 				scales: {
 			        xAxes: [{
 			        	scaleLabel: {
 			                display: true,
 			                labelString: 'Merch ID'
 			              },
 			            gridLines: {
 			            	drawOnChartArea: false
 			            }
 			        }],
 			        yAxes: [{
 			        	scaleLabel: {
 			                display: true,
 			                labelString: 'Txn Value'
 			              },
 			              ticks: {
 			            	  
 			                    // Include a dollar sign in the ticks
 			                    callback:
 			                    	function(value, index, values) {
 			                    	findLabel(targetDataset[0].data);
 			                        return axesRange("$",value,axeslabel);
 			                    }},
 			            gridLines: {
 			            	drawOnChartArea: false
 			            }   
 			        }]
 			    },
 			    animation: {
 			    	onComplete: function() {
 		                // To only draw at the end of animation, check for easing === 1
 		                var ctx = this.chart.ctx;
 		                var chart = this;
 		                var datasets = this.config.data.datasets;
 		                var xval=(this.chart.config.type=="bar")?0:25;
 		                var padding = (this.chart.config.type=="bar")?10:0;//0 for horizontalBar
 		                
 		                datasets.forEach(function (dataset, i) {
 		                    ctx.font = "20px Arial";
 		                            ctx.fillStyle = 'rgb(0, 0, 0)';
 		                            var fontSize = 12;
 		                            var fontStyle = 'normal';
 		                            var fontFamily = 'Helvetica Neue';
 		                            ctx.font = Chart.helpers.fontString(fontSize, fontStyle, fontFamily);
 		                            chart.getDatasetMeta(i).data.forEach(function (p, j) {
 		                            	ctx.textAlign = 'center';
 		                                ctx.textBaseline = 'top';
 		                                var dataString=axesRange("$",parseInt(datasets[i].data[j]),axeslabel);
 		                                ctx.fillText(dataString, p._model.x+xval, p._model.y - (fontSize / 2) - padding);
 		                            });

 		                    
 		                });
 		                

 		               
 			    	}
 			    }

 			}
 		}; */
 	
 		/* var BarChart= new Chart(barCtx,merchIdConfigBar); */
 		
 		

 		//https://github.com/chartjs/Chart.js/issues/2958#issuecomment-261949718

 		var barCtx = document.getElementById("myChart").getContext("2d");


		 var san1={labels:[],datasets:[{label:"TotalAmount", backgroundColor: color(window.chartColors.blue).alpha(0.5).rgbString(),data:[]}]};
		
		var merchIdConfigBar1={
				type: 'bar',
				data: san1,
				
				options: {
					maintainAspectRatio: false,
				    responsive: true, 
					 onClick: function(evt, item)  {
						 var temp=BarChart.getDatasetAtEvent(evt);
						var index = item[0]["_index"];
						var axesVal = item[0]["_chart"].data.labels[index];
						var chartVal = item[0]["_chart"].data.datasets[0].data[index];
						var dateData=[];
						var dateLabel=[];
						var weekdayLabel=['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'];
						var weekData=[0,0,0,0,0,0,0];
						var doughnutLabelTemp=['VISA','MASTERCARD','OMANNET','OTHERS'];
						var doughnutDataTemp=[0,0,0,0];
						sumAmountDateMrchJs.forEach(function(o){
							if(o.mpt_merc_id==axesVal)
								{
									var val=new Date(String(o.dates)).getDay();
									weekData[val]=weekData[val]+parseInt(o.sum);
									dateData.push(o.sum);
									dateLabel.push(o.dates);
									if(String(o.mpt_stat_name).includes("OMANNET"))
									{
										doughnutDataTemp[doughnutLabelTemp.indexOf("OMANNET")]+=1;
									}
									else if(String(o.mpt_stat_name).includes("VISA"))
									{
										doughnutDataTemp[doughnutLabelTemp.indexOf("VISA")]+=1;
									}
									else if(String(o.mpt_stat_name).includes("MASTERCARD"))
									{
										doughnutDataTemp[doughnutLabelTemp.indexOf("MASTERCARD")]+=1;
									}
									else
									{
										doughnutDataTemp[doughnutLabelTemp.indexOf("OTHERS")]+=1;
									}
								}
							 });
						var sort=sortLabelAndData(dateData,dateLabel,"label","asc");
						dateData=[];
						dateLabel=[];
						sort.forEach(function(t){
							dateData.push(t.data);
							dateLabel.push(t.label);
						});	 
						lineChart.data.labels=dateLabel;
						lineChart.data.datasets[0].data=dateData;
						weekDayChart.data.labels=weekdayLabel;
						weekDayChart.data.datasets[0].data=weekData;
						doughnutChart.data.labels=doughnutLabelTemp;
						doughnutChart.data.datasets[0].data=doughnutDataTemp;
						lineChart.update();
						weekDayChart.update(); 
						doughnutChart.update(); 
			            
			        }, 
				
					elements: {
						rectangle: {
							borderWidth: 2
						}
					},
					responsive: true,
					legend: {
						//display: false
						position: 'right'
					},
					title: {
						display: true,
						text: 'Transaction Value in Million'
					},
					 plugins: {
					       labels: {
					    	  render:  function (args) {
					    		  //findLabel(targetDataset[0].data);
					    		  //return axesRange("$",args.value,axeslabel);
					    	      //return '$' + args.value;
					    	      return "";
					    	    }
					      } 
					}, 
					scales: {
				        xAxes: [{
				        	scaleLabel: {
				                display: true,
				                labelString: 'Merch ID'
				              },
				            gridLines: {
				            	drawOnChartArea: false
				            }
				        }],
				        yAxes: [{
				        	scaleLabel: {
				                display: true,
				                labelString: 'Txn Value'
				              },
				              ticks: {
				            	  
				                    // Include a dollar sign in the ticks
				                    callback:
				                    	function(value, index, values) {
				                    	findLabel(targetDataset[0].data);
				                        return axesRange("$",value,axeslabel);
				                    }},
				            gridLines: {
				            	drawOnChartArea: false
				            }   
				        }]
				    },
				    animation: {
				    	onComplete: function() {
				    		
		                        var sourceCanvas = BarChart.chart.canvas;
		                        var copyWidth = BarChart.scales['y-axis-0'].width - 10;
		                        var copyHeight = BarChart.scales['y-axis-0'].height + BarChart.scales['y-axis-0'].top + 10;
		                        var targetCtx = document.getElementById("myChartAxis").getContext("2d");
		                        targetCtx.canvas.width = copyWidth;
		                targetCtx.drawImage(sourceCanvas, 0, 0, copyWidth, copyHeight, 0, 0, copyWidth, copyHeight);
			                // To only draw at the end of animation, check for easing === 1
			                var ctx = this.chart.ctx;
			                var chart = this;
			                var datasets = this.config.data.datasets;
			                var xval=(this.chart.config.type=="bar")?0:25;
			                var padding = (this.chart.config.type=="bar")?10:0;//0 for horizontalBar
			                
			                datasets.forEach(function (dataset, i) {
			                    ctx.font = "20px Arial";
			                            ctx.fillStyle = 'rgb(0, 0, 0)';
			                            var fontSize = 12;
			                            var fontStyle = 'normal';
			                            var fontFamily = 'Helvetica Neue';
			                            ctx.font = Chart.helpers.fontString(fontSize, fontStyle, fontFamily);
			                            chart.getDatasetMeta(i).data.forEach(function (p, j) {
			                            	ctx.textAlign = 'center';
			                                ctx.textBaseline = 'top';
			                                var dataString=axesRange("$",parseInt(datasets[i].data[j]),axeslabel);
			                                ctx.fillText(dataString, p._model.x+xval, p._model.y - (fontSize / 2) - padding);
			                            });

			                    
			                });
			                

			               
				    	}
				    }

				}
			};
		var BarChart= new Chart(barCtx,merchIdConfigBar1);
		//var myLiveChart = new Chart(ctx, merchIdConfigBar1);
		var san2=getBarchartDataMerchID();
		var sl=san2.labels;
		var sd=san2.datasets[0].data;
		 for(x=0;x<sl.length;x++)
		{
			 BarChart.data.datasets[0].data.push(sd[x]);
			 BarChart.data.labels.push(sl[x]);
		  var newwidth = $('.chartAreaWrapper2').width() +60;
		  $('.chartAreaWrapper2').width(newwidth);
		} 
 		 

 		
 		
 		
 		
 		
 var finalDate=getLinechartDataDate();
 var sumDateConfigLine={
 	    type: 'line',
 	    data: finalDate,
 	    options: {onClick: function(evt, item)  {
 			
 	        var index = item[0]["_index"];
 	        var date = item[0]["_chart"].data.labels[index];
 	        var dateData = item[0]["_chart"].data.datasets[0].data[index];
 	        var fdata=[];
 			var flabel=[];
 			var weekdayLabel=['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'];
 			var weekData=[0,0,0,0,0,0,0];
 			weekData[new Date(String(date)).getDay()]=parseInt(dateData);
 			sumAmountDateMrchJs.forEach(function(o){
 				if(o.dates==date)
 					{
 					var x=flabel.indexOf(o.mpt_merc_id);
 					
 						if(x==-1)
 						{
 							flabel.push(o.mpt_merc_id);
 							fdata.push(o.sum);
 						}
 						else
 						{
 							fdata[x]+=o.sum;
 						}
 					}
 				 });
 			var sortedArray=sortLabelAndData(fdata,flabel,"data","desc");
 			var newArrayLabel = [];
 			var newArrayData = [];
 			sortedArray.forEach(function(d){
 			  newArrayLabel.push(d.label);
 			  newArrayData.push(d.data);
 			});	  
 			BarChart.data.datasets[0].data=newArrayData;
 			BarChart.data.labels=newArrayLabel;
 			weekDayChart.data.labels=weekdayLabel;
 			weekDayChart.data.datasets[0].data=weekData;
 			weekDayChart.update();
 	        BarChart.update();
 	        flag=true;
 	        flagTop=true;
 			assignTopValueFilter(newArrayData,newArrayLabel);
 	    },

 		elements: {
 			rectangle: {
 				borderWidth: 2
 			}
 		},
 		responsive: true,
 		legend: {
 			position: 'right'
 		},
 	    	title: {
 				display: true,
 				text: 'Transactions Value in Million'
 			},
 			scales: {
 		        xAxes: [{
 		        	scaleLabel: {
 		                display: true,
 		                labelString: 'Date'
 		              },
 		            gridLines: {
 		            	drawOnChartArea: false
 		            }
 		        }],
 		        yAxes: [{
 		        	scaleLabel: {
 		                display: true,
 		                labelString: 'Txn Value'
 		              },
 		              ticks: {
 		                    // Include a dollar sign in the ticks
 		                    callback: function(value, index, values) {
 		                    	findLabel(dateDataset[0].data);
 		                        return axesRange("$",value,axeslabel);
 		                    }},
 		            gridLines: {
 		            	drawOnChartArea: false
 		            }   
 		        }]
 		    }
 	    }
 	};
 	
 var lineDateCtx=document.getElementById("sumDate");
 var lineChart = new Chart(lineDateCtx,sumDateConfigLine);


 var hel=getLineChartDataWeekday(finalDate);
 weekdayDataset[0].data=hel.data;
 weekdayLabels=hel.labels;
 var finalWeekData={
 		labels:weekdayLabels,
 		datasets:weekdayDataset
 } 

 var weekdayCongigLine={
 		type: 'line',
 	    data: finalWeekData,
 	    options: {
 	    	onClick: function(evt, item)  {
 			
 	        var index = item[0]["_index"];
 	        var label = item[0]["_chart"].data.labels[index];
 	        var lData = item[0]["_chart"].data.datasets[0].data[index];
 	        var weekdayLabel=['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'];
 	        var bardata=[];
 			var barlabel=[];
 			var linedata=[];
 			var linelabel=[];
 			var val=weekdayLabel.indexOf(label);
 			sumAmountDateMrchJs.forEach(function(o){
 				if(new Date(String(o.dates)).getDay()==val)
 					{
 					var x=barlabel.indexOf(o.mpt_merc_id);
 					var y=linelabel.indexOf(o.dates);
 						if(x==-1)
 						{
 							barlabel.push(o.mpt_merc_id);
 							bardata.push(o.sum);
 						}
 						else
 						{
 							bardata[x]+=o.sum;
 						}
 						if(y==-1)
 						{
 							linelabel.push(o.dates);
 							linedata.push(o.sum);
 						}
 						else
 						{
 							linedata[y]+=o.sum;
 						}
 					}
 				 });
 			var sortedArrayBar=sortLabelAndData(bardata,barlabel,"data","desc");
 			var sortedArrayLine=sortLabelAndData(linedata,linelabel,"label","asc");
 			bardata=[];
 			barlabel=[];
 			linedata=[];
 			linelabel=[];
 			sortedArrayBar.forEach(function(d){
 			  barlabel.push(d.label);
 			  bardata.push(d.data);
 			});	
 			sortedArrayLine.forEach(function(d){
 				linelabel.push(d.label);
 				  linedata.push(d.data);
 				});
 			BarChart.data.datasets[0].data=bardata;
 			BarChart.data.labels=barlabel;
 			lineChart.data.datasets[0].data=linedata;
 			lineChart.data.labels=linelabel;
 			flag=true;
 			flagTop=true;
 			assignTopValueFilter(bardata,barlabel);
 	        BarChart.update();
 	        lineChart.update();
 	    },

 		elements: {
 			rectangle: {
 				borderWidth: 2
 			}
 		},
 		responsive: true,
 		legend: {
 			position: 'right'
 		},
 	    	title: {
 				display: true,
 				text: 'Transactions Value in Million'
 			},
 			scales: {
 		        xAxes: [{
 		        	scaleLabel: {
 		                display: true,
 		                labelString: 'Date'
 		              },
 		            gridLines: {
 		            	drawOnChartArea: false
 		            }
 		        }],
 		        yAxes: [{
 		        	scaleLabel: {
 		                display: true,
 		                labelString: 'Txn Value'
 		              },
 		               ticks: {
 		                    // Include a dollar sign in the ticks
 		                    callback: function(value, index, values) {
 		                    	findLabel(weekdayDataset[0].data);
 		                        return axesRange("$",value,axeslabel);
 		                    }}, 
 		            gridLines: {
 		            	drawOnChartArea: false
 		            }   
 		        }]
 		    },
 			animation:{
 				onComplete:function() {
 	                // To only draw at the end of animation, check for easing === 1
 	                var ctx = this.chart.ctx;
 	                var chart = this;
 	                var datasets = this.config.data.datasets;
 	                var xval=(this.chart.config.type=="bar")?0:25;
 	                var padding = (this.chart.config.type=="bar")?10:0;//0 for horizontalBar
 	                findLabel(weekdayDataset[0].data);
 	                datasets.forEach(function (dataset, i) {
 	                    ctx.font = "20px Arial";
 	                            ctx.fillStyle = 'rgb(0, 0, 0)';
 	                            var fontSize = 12;
 	                            var fontStyle = 'normal';
 	                            var fontFamily = 'Helvetica Neue';
 	                            ctx.font = Chart.helpers.fontString(fontSize, fontStyle, fontFamily);
 	                            chart.getDatasetMeta(i).data.forEach(function (p, j) {
 	                            	ctx.textAlign = 'center';
 	                                ctx.textBaseline = 'top';
 	                                var dataString=axesRange("$",parseInt(datasets[i].data[j]),axeslabel);
 	                                ctx.fillText(dataString, p._model.x+xval, p._model.y - (fontSize / 2) - padding);
 	                            });

 	                    
 	                });
 	                

 	               
 		    	}
 			}
 	    }	
 		
 	};  
 	
 var weekdayCtx=document.getElementById("weekday");
 var weekDayChart=new Chart(weekdayCtx,weekdayCongigLine);

 var doughnutCtx=document.getElementById("doughnut");

 var doughChartData=getDoughnutChartData();

 var doughnutChartConfig={
  type: 'doughnut',
  data: doughChartData,
    options: {
 	   onClick: function(evt, item)  {
 			
 	        var index = item[0]["_index"];
 	        var label = item[0]["_chart"].data.labels[index];
 	        var lData = item[0]["_chart"].data.datasets[0].data[index];
 	        var weekdayLabel=['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'];
 	        var weekdayData=[0,0,0,0,0,0,0];
 	        var bardata=[];
 			var barlabel=[];
 			var linedata=[];
 			var linelabel=[];
 	    },
 	   
      title: {
        display: true,
        text: 'Cardtype Trend'
      },
      layout: {
          padding: {
              left: 50,
              right: 0,
              top: 0,
              bottom: 0
          }
      },

      plugins: {
     	 legend: false,
     	 labels:[
     	         {
     		 	render: 'label',
     		    arc: true,
     		    fontColor: '#000',
     		    position: 'outside'
     		  },
     		  {
     			  render: function (args) {
     				  findLabel(doughnutData[0].data);
                       return axesRange("",args.value,axeslabel);
 		    		  //return axesRange("",args.value,"K");
 		    	    },
 		    	    arc: true,
 		    	    fontColor: '#000',
 		    	    position: 'border'
     		  
     		  }
     		  ]
      }
      
    }
 };

 var doughnutChart = new Chart(doughnutCtx, doughnutChartConfig);

 /*
   
  {
      labels: ["Africa", "Asia", "Europe", "Latin America", "North America"],
      datasets: [
        {
          label: "Population (millions)",
          backgroundColor: [color(window.chartColors.blue).alpha(0.5).rgbString(), "#8e5ea2","#3cba9f","#e8c3b9","#c45850"],
          data: [2478,5267,734,784,433]
        }
      ]
    }
    */
    
    

 </script>
 </body>

 </html>