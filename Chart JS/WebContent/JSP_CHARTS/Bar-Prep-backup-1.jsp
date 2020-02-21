<%@ page import = "java.io.*,java.util.*,org.json.*,java.sql.*"%>
<%@ page import = "javax.servlet.http.*,javax.servlet.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix = "c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix = "sql"%>
<html>

<head>
	<script src="../JS/Chart.bundle.js"></script>
	<script src="../JS/utils.js"></script>
	<script src="../JS/functions.js"></script>
	<style>
#topdis
{
margin-right:-30px;
width:10%;
}
	</style>
</head>

<body>

<div>
<div id="container" style="width: 50%;float:left;">
		<label>Top N Merchants</label><input type="number" id="topdis" name="topdis" onkeydown="assignTopValue()"/>
		<canvas id="canvas"></canvas>
	</div>
<div id="container1" style="width: 50%;float:right;">
		<canvas id="sumDate"></canvas>
</div>
</div>
<div>
<div id="container3" style="width: 50%;float:right;">
		<canvas id="doughnut"></canvas>
</div>
<div id="container2" style="width: 50%;float:left;">
		<canvas id="weekday"></canvas>
</div>


</div>



<script type="text/javascript">
var flagTop=false;
var targetLabels;
var color = Chart.helpers.color;
var targetDataset;
var data=[];
var label=[];
</script>
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
String sql = "select * from AFS_DEMO where rownum<=100";
//String sumAmountMrchId="select mpt_merc_id,sum(CAST(mpt_txn_amt AS int)) as sum from AFS_DEMO  group by mpt_merc_id order by sum(CAST(mpt_txn_amt AS int)) desc";
String sumAmountMrchId="select * from (select mpt_merc_id,sum(CAST(mpt_txn_amt AS int)) as sum from AFS_DEMO group by mpt_merc_id order by sum(CAST(mpt_txn_amt AS int)) desc) where rownum<25";
String sumAmountDate="select TO_CHAR(CAST(MPT_REQ_DATE AS date),'yyyy-MM-dd') as dates,sum(CAST(mpt_txn_amt AS int)) as sum from AFS_DEMO group by TO_CHAR(CAST(MPT_REQ_DATE AS date),'yyyy-MM-dd') order by TO_CHAR(CAST(MPT_REQ_DATE AS date),'yyyy-MM-dd')";
String sumAmountDateMrch="select TO_CHAR(CAST(MPT_REQ_DATE AS date),'yyyy-MM-dd') as dates,mpt_merc_id,sum(CAST(mpt_txn_amt AS int)) as sum from AFS_DEMO group by TO_CHAR(CAST(MPT_REQ_DATE AS date),'yyyy-MM-dd'),mpt_merc_id order by sum(CAST(mpt_txn_amt AS int)) desc";
//String sumAmountDateMrch="select TO_CHAR(CAST(MPT_REQ_DATE AS date),'yyyy-MM-dd') as dates,mpt_merc_id,sum(CAST(mpt_txn_amt AS int)) as sum from AFS_DEMO group by TO_CHAR(CAST(MPT_REQ_DATE AS date),'yyyy-MM-dd'),mpt_merc_id order by TO_CHAR(CAST(MPT_REQ_DATE AS date),'yyyy-MM-dd')";

//String sumAmountDate="select MPT_REQ_DATE as dates,sum(CAST(mpt_txn_amt AS int)) as sum from AFS_DEMO group by MPT_REQ_DATE order by MPT_REQ_DATE";


//sumAmountDate sql query
try{
	stmt=con.prepareStatement(sumAmountDate);
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
  var sumAmountDateJs=<%=jsonArraySumAmount%>;
  console.log(sumAmountDateJs);
  </script>
  <%
  	
}
catch(Exception e)
{
	e.printStackTrace();
}


//sumAmountDateMrchID sql query
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
console.log(sumAmountDateMrchJs);
</script>
<%
	
}
catch(Exception e)
{
	e.printStackTrace();
}

//sumAmountMrchId sql query
try{
	stmt=con.prepareStatement(sumAmountMrchId);
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
  var sumAmountMrchJs=<%=jsonArraySumAmount%>;
  console.log(sumAmountMrchJs);
  </script>
    <%	
}
catch(Exception e)
{
	e.printStackTrace();
}


//to get rownum data
try{
	 stmt=con.prepareStatement(sql);
	 rs=stmt.executeQuery(); 
	 JSONArray jsonArray = new JSONArray();
     while (rs.next()) {
         int total_col = rs.getMetaData().getColumnCount();
         JSONObject obj = new JSONObject();
         for (int i = 0; i < total_col; i++) {
             
             obj.put(rs.getMetaData().getColumnLabel(i + 1)
                     .toLowerCase(), rs.getObject(i + 1));
             
         }
         jsonArray.put(obj);
     }
	 %>
	 <script>

	 var color = Chart.helpers.color;
		
		var BarChartData = getBarchartData();
		var barCtx = document.getElementById('canvas').getContext('2d');
		var merchIdConfigBar={
				type: 'bar',
				data: BarChartData,
				options: {
					 onClick: function(evt, item)  {
						 var temp=BarChart.getDatasetAtEvent(evt);
						var index = item[0]["_index"];
						var axesVal = item[0]["_chart"].data.labels[index];
						var chartVal = item[0]["_chart"].data.datasets[0].data[index];
						var fdata=[];
						var flabel=[];
						var weekdayLabel=['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'];
						var weekData=[0,0,0,0,0,0,0];
						sumAmountDateMrchJs.forEach(function(o){
							if(o.mpt_merc_id==axesVal)
								{
									var val=new Date(String(o.dates)).getDay();
									weekData[val]=weekData[val]+parseInt(o.sum);
									fdata.push(o.sum);
									flabel.push(o.dates);
								}
							 });
							 
						lineChart.data.labels=flabel;
						lineChart.data.datasets[0].data=fdata;
						weekDayChart.data.labels=weekdayLabel;
						weekDayChart.data.datasets[0].data=weekData;
						lineChart.update();
						weekDayChart.update(); 
			            
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
						text: 'Transaction Value in Million'
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
				    }

				}
			};
			var BarChart= new Chart(barCtx,merchIdConfigBar);
			

	 var dateLabels = [];
	 var color = Chart.helpers.color;
	 var dateDataset = [{label:"TotalAmount", backgroundColor: color(window.chartColors.blue).alpha(0.5).rgbString(),data:[]}];
	 sumAmountDateJs.forEach(function(o){
		 dateLabels.push(o.dates);
		 dateDataset[0].data.push(o.sum);
	 });
	var finalDate={
			labels:dateLabels,
			datasets:dateDataset
	}
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
					 })
				var sortedArray=sortLabelAndData(fdata,flabel);
				var newArrayLabel = [];
				var newArrayData = [];
				sortedArray.forEach(function(d){
				  newArrayLabel.push(d.label);
				  newArrayData.push(d.data);
				});	  
				BarChart.data.datasets[0].data=newArrayData;
				BarChart.data.labels=newArrayLabel;
		        BarChart.update();
		        flag=true;
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
var lineChart = new Chart(document.getElementById("sumDate"),sumDateConfigLine);
	 
	 var weekdayLabels=[];						//lineTension: 0,fill: false -->to display in straight line and fill no
	 var weekdayDataset = [{label:"TotalAmount", backgroundColor: color(window.chartColors.blue).alpha(0.5).rgbString(),data:[]}];
	 var hel=dataPrepareForWeekChart(finalDate);
	 weekdayDataset[0].data=hel.data;
	 weekdayLabels=hel.labels;
	var finalWeekData={
			labels:weekdayLabels,
			datasets:weekdayDataset
	} 
	 
	var weekdayCongigLine={
			type: 'line',
		    data: finalWeekData,
		    options: {onClick: function(evt, item)  {
				
		        var index = item[0]["_index"];
		        var label = item[0]["_chart"].data.labels[index];
		        var lData = item[0]["_chart"].data.datasets[0].data[index];
		        var fdata=[];
				var flabel=[];
				sumAmountDateMrchJs.forEach(function(o){
					if(o.dates==label)
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
				var sortedArray=sortLabelAndData(fdata,flabel);
				var newArrayLabel = [];
				var newArrayData = [];
				sortedArray.forEach(function(d){
				  newArrayLabel.push(d.label);
				  newArrayData.push(d.data);
				});	  
				BarChart.data.datasets[0].data=newArrayData;
				BarChart.data.labels=newArrayLabel;
		        BarChart.update();
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
			    }
		    }	
			
		};  
var weekDayChart=new Chart(document.getElementById("weekday"),weekdayCongigLine);


	
	 </script>
	 <%-- <%
	 
	 ResultSetMetaData rmd = rs.getMetaData();
	 int col = rmd.getColumnCount();
	  //System.out.println("Number of Column : "+ col);
	  //System.out.println("Columns Name: ");
	  for (int i = 1; i <= col; i++){
	  %>
	  <script>
	  columnNames.push("<%=rmd.getColumnName(i)%>"); 
	   </script>
	  <%
	  }
%> --%>

<%
}
catch(Exception e){e.printStackTrace();}
finally{
//if(rs!=null) rs.close();
//if(s!=null) s.close();
if(con!=null) con.close();
}

%>
  
      

	

	<script>
		

		var colorNames = Object.keys(window.chartColors);
		//alert(colorNames);//red,orange,yellow,green,blue,purple,grey
		
		
		
					/*document.getElementById('canvas').onclick = function (evt) {
				var activeSector = BarChart.getBarsAtEvent(evt);
				alert("hi  "+activeSector);
			};*/
			 
	 <%-- var jdata=<%=jsonArray%>; --%>
	 /*var result = [];
	 jdata.sort(function(a,b){
	 	//if(a.mpt_term_id === b.mpt_term_id){
	   	//return a.tenant> b.tenant ?1 : a.tenant <b.tenant ?-1: 0;
	   //}else{
	   	return a.mpt_merc_id> b.mpt_merc_id ?1 : a.mpt_merc_id <b.mpt_merc_id ?-1: 0;
	   //}
	 }).reduce(function(c,n,i){
	 	if(c){
	 	if(c.mpt_merc_id === n.mpt_merc_id){
	 		var temp=parseInt(n.mpt_txn_amt)+parseInt(c.mpt_txn_amt);
	   	n.mpt_txn_amt =temp.toString();
	     if(i===jdata.length-1)
	     	result.push(n);
	   }
	   else{
	 		result.push(c);  
	   }
	   }
	   return n;
	 },null)*/
//console.log("result"+result);
	 /*var targetLabels = [];
	 var color = Chart.helpers.color;
	 //var targetDataset = [{label:"TotalAmount",data:[]}];
	 var targetDataset = [{label:"TotalAmount", backgroundColor: color(window.chartColors.blue).alpha(0.5).rgbString(),data:[]}];
	 result.forEach(function(o){
	 	targetLabels.push(o.mpt_merc_id);
	   targetDataset[0].data.push(o.mpt_txn_amt);
	 })*/
	 //console.log("targetLabels-->",targetLabels);
//console.log("targetDataset-->",targetDataset);
/*var labelsDate =[];
var color = Chart.helpers.color;
//var targetDataset = [{label:"TotalAmount",data:[]}];
var DatasetDate = [{label:"TotalAmount", backgroundColor: color(window.chartColors.blue).alpha(0.5).rgbString(),data:[]}];

sumAmountDateJs.forEach(function(o){
	  //alert(o.sum);
	  //labelsDate.push(o.dates);
	  DatasetDate[0].data.push(o.sum);
	 })
	 labelsDate.push("abc");
	 console.log("labelsDate\n"+labelsDate);
console.log("DatasetDate"+DatasetDate);
	 var x={
	  labels:labelsDate,
			 datasets:DatasetDate
}

var lineChartSumAmountDateJs = new Chart(document.getElementById("sumDate"), {
	    type: 'line',
	    data: DatasetDate,
	    options: {
	    	title: {
				display: true,
				text: 'Transactions_Volume_Date_Trend'
			}
	    }
	});*/
	
	/*var result = [];
	 jdata.sort(function(a,b){
	 	/*if(a.mpt_term_id === b.mpt_term_id){
	   	return a.tenant> b.tenant ?1 : a.tenant <b.tenant ?-1: 0;
	   }else{
	   	return a.mpt_term_id> b.mpt_term_id ?1 : a.mpt_term_id <b.mpt_term_id ?-1: 0;
	   //}
	 }).reduce(function(c,n,i){
	 	if(c){
	 	if(c.mpt_term_id === n.mpt_term_id){
	 		var temp=parseInt(n.mpt_txn_amt)+parseInt(c.mpt_txn_amt);
	   	n.mpt_txn_amt =temp.toString();
	     if(i===jdata.length-1)
	     	result.push(n);
	   }
	   else{
	 		result.push(c);  
	   }
	   }
	   return n;
	 },null)
console.log("result"+result);*/
/*  function commarize(min) {
min = min || 1e3;
// Alter numbers larger than 1k
if (this >= min) {
  var units = ["k", "M", "B", "T"];
  //console.log(Math.log(this)/ Math.log(1000));
  var order = Math.floor(Math.log(min)/ Math.log(1000));
  console.log("order----"+order);

  var unitname = units[(order - 1)];
  console.log("unitname----"+unitname);
  var num = (min / Math.pow(1000,order)).toFixed(2);
  console.log("num----"+num);
  
  // output number remainder + unitname
  return num + unitname
}

// return formatted original number
return this.toLocaleString()
} */ 
		

	</script>
</body>

</html>