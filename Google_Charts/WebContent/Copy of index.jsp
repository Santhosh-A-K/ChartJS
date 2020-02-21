<%@ page import = "java.io.*,java.util.*,java.sql.*"%>
<%@ page import = "javax.servlet.http.*,javax.servlet.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix = "c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix = "sql"%>
 
<html>
   <head>
      <title>Google Charts</title>
            <script type = "text/javascript" src = "https://www.gstatic.com/charts/loader.js"></script>
	  <script type="text/javascript" src="https://www.google.com/jsapi"></script>
	  <script src="http://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>

 <script src="jquery.csv.min.js"></script>
<script src="jquery-csv.js"></script>


   </head>

   <body>
      <%-- <sql:setDataSource var = "snapshot" driver = "oracle.jdbc.OracleDriver"
         url = "jdbc:oracle:thin:@10.44.113.13:1527:ACMDB"
         user = "AWSPOC"  password = "pocaws321#"/>
 
      <sql:query dataSource = "${snapshot}" var = "result">
         SELECT * from Auth
      </sql:query> --%>
 <p>hi</p>
      <table border = "1" >
         <tr>
            <th>ID</th>
            <th>User Name</th>
            <th>Password</th>
            <th>Role</th>
         </tr>
          <c:forEach var = "row" items = "${result.rows}">
            <tr>
               <td><c:out value = "${row.id}"/></td>
               <td><c:out value = "${row.uname}"/></td>
               <td><c:out value = "${row.password}"/></td>
               <td><c:out value = "${row.role}"/></td>
            </tr>
         </c:forEach> 
      </table>
      <div id = "container" style = "float:left; width: 550px; height: 400px; margin: 0 auto">
      </div>
      <div id = "container1" style = "float:left; width: 550px; height: 400px; margin-top: 0">
      </div>
<!--  <input type="file" id="fileInput">-->
<script>
$(document).ready(function(){
	$.ajax({
        type: "GET",
        url: "abk__2019.csv",
        dataType: "text",
        success: function(data) {processData(data);}
     });
	var csv_data="";
	google.charts.load('current', {packages: ['table','corechart']});  
	google.charts.setOnLoadCallback(drawChart);
});
	
	function processData(data)
	{
		csv_data=data;
	}

function drawChart() {
	
		 alert("hi");
		 var csv=$.csv;
		 var arrayData = csv.toArrays(csv_data, {onParseValue: csv.hooks.castToScalar});
		 alert("hi");

        	 
            // Define the chart to be drawn.
			//alert(content);
            /*var san={
            <c:forEach var = "row" items = "${result.rows}" varStatus="loop">
            
            '${row.id}': ${row.uname}${!loop.last ? ',' : ''}
         </c:forEach>
            };
           
            alert("san");*/
            
			//var lines=content.split("\r\n");
            
			var data = new google.visualization.DataTable();
			data.addColumn('string',"name");
			data.addColumn('string',"password");
			data.addColumn('string',"role");
			<c:forEach var = "row" items = "${result.rows}">
				data.addRow(["${row.uname}","${row.password}","${row.role}"]);
			</c:forEach>
			
			/*for(var i=0;i<lines.length;i++)
			{
				var str=lines[i].split(",");
				if(i==0)
				{
					data.addColumn({ type: 'string', id: str[0] });
					data.addColumn({ type: 'number', id: str[1] });
					//data.addColumn('string',str[0]);
					//data.addColumn('number',str[1]);
				}
				else
				{
					data.addRow([str[0],parseFloat(str[1])]);
					//data.addRow([str[0],parseFloat(str[1])]);
				}
			}*/
			
			//data.addRow(["2014",50]);
            
           /* data.addColumn('string','type');
            data.addColumn('number','per');
            data.addRows([
               ['Firefox', 45.0],
               ['IE', 26.8],
               ['Chrome', 12.8],
               ['Safari', 8.5],
               ['Opera', 6.2],
               ['Others', 0.7]
            ]);*/
			
			//var result = google.visualization.data.group(data,[0],[{'column': 1, 'aggregation': google.visualization.data.sum, 'type': 'number'}]);
               
            // Set chart options
            //var options = {'title':'Browser market shares at a specific website'};

            // Instantiate and draw the chart.
            //var chart = new google.visualization.BarChart(document.getElementById ('container'));
            //var chart = new google.visualization.BarChart(document.getElementById ('container'));
            //chart.draw(data, {showRowNumber: true, width: '100%', height: '100%'});
            //chart.draw(result, options);
            //chart.draw(data, options);
            var count=google.visualization.data.group(data,[2],[{'column': 2, 'aggregation': google.visualization.data.count, 'type': 'number'}]);
            
            var col = new google.visualization.ChartWrapper({
			    chartType: 'PieChart',
			    containerId: 'container',
			    options: {'title': 'Database data'},
			    dataTable: count
			    
			  });
            google.visualization.events.addListener(col, 'select', function() {
			    var rows = col.getChart().getSelection();
			    if(rows)
			    	{
			    	alert("hello  "+rows[0].column+"  "+rows[0].row);
			    	}
			    //alert('You selected ' + data.getRowLabel(rows[0].row));
			    //alert("hello");
			  });
			  col.draw();
            
			var table = new google.visualization.ChartWrapper({
			    chartType: 'Table',
			    containerId: 'container1',
			    options: {'title': 'Database data'},
			    dataTable: data
			    
			  });
			  table.draw();
			  google.visualization.events.addListener(table, 'select', function() {
				    //var row = table.getSelection()[0].row;
				    //alert('You selected ' + data.getValue(row, 0));
				    alert("hi");
				  });
			  
			  
         }

         
      </script>
 
   </body>
</html>