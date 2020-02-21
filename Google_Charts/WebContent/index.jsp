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
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-csv/1.0.8/jquery.csv.js"></script>


   </head>

   <body>
       <sql:setDataSource var = "snapshot" driver = "oracle.jdbc.OracleDriver"
         url = "jdbc:oracle:thin:@10.44.113.13:1527:ACMDB"
         user = "AWSPOC"  password = "pocaws321#"/>
 
      <sql:query dataSource = "${snapshot}" var = "result">
         SELECT * from Dashboard1
      </sql:query> 
 
      <table border = "1" >
         <tr>
            <!-- <th>ID</th>
            <th>User Name</th>
            <th>Password</th>
            <th>Role</th> -->
            <th>ID</th>
            <th>SITEID</th>
            <th>DNAME</th>
            <th>PRODUCT</th>
            <th>URL</th>
            <th>VIEWS</th>
            <th>WORKSHEET</th>
            <th>MODNAME</th>
         </tr>
          <c:forEach var = "row" items = "${result.rows}">
            <%-- <tr>
               <td><c:out value = "${row.id}"/></td>
               <td><c:out value = "${row.uname}"/></td>
               <td><c:out value = "${row.password}"/></td>
               <td><c:out value = "${row.role}"/></td>
            </tr> --%>
            <tr>
               <td><c:out value = "${row.ID}"/></td>
               <td><c:out value = "${row.SITEID}"/></td>
               <td><c:out value = "${row.DNAME}"/></td>
               <td><c:out value = "${row.PRODUCT}"/></td>
               <td><c:out value = "${row.URL}"/></td>
               <td><c:out value = "${row.VIEWS}"/></td>
               <td><c:out value = "${row.WORKSHEET}"/></td>
               <td><c:out value = "${row.MODNAME}"/></td>
            </tr>
         </c:forEach> 
      </table>
      <div id = "container" style = "float:left; width: 550px; height: 400px; margin: 0 auto">
      </div>
      <div id = "container1" style = "float:left; width: 550px; height: 400px; margin-top: 0">
      </div>
<!--  <input type="file" id="fileInput">-->
<script>
/* ID
SITEID
DNAME
PRODUCT
URL
VIEWS
WORKSHEET
MODNAME */
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
		console.log(csv_data);
	}

function drawChart() {
	
			 alert("hi");
			 var csv=$.csv;
			 var arrayData = csv.toArrays(csv_data, {onParseValue: csv.hooks.castToScalar});
			 alert("hi");            
			var data = new google.visualization.DataTable();
			
			for(var i=0;i<csv_data.length;i++)
			{
				var str=csv_data[i].split(",");
				if(i==0)
				{
					
					data.addColumn({ type: 'number', id: str[0] });
					data.addColumn({ type: 'number', id: str[1] });
					data.addColumn({ type: 'string', id: str[2] });
					data.addColumn({ type: 'number', id: str[3] });
					data.addColumn({ type: 'number', id: str[4] });
					//data.addColumn('string',str[0]);
					//data.addColumn('number',str[1]);
				}
				else
				{
					data.addRow([parseFloat(str[0]),parseFloat(str[1]),str[2],parseFloat(str[3]),parseFloat(str[4])]);
					//data.addRow([str[0],parseFloat(str[1])]);
				}
			}
			
			var chart = new google.visualization.Table(document.getElementById ('container'));
            chart.draw(result, {showRowNumber: true, width: '100%', height: '100%'});
			
			/*data.addColumn('string',"name");
			data.addColumn('string',"password");
			data.addColumn('string',"role");*/
			/*<c:forEach var = "row" items = "${result.rows}">
				data.addRow(["${row.uname}","${row.password}","${row.role}"]);
			</c:forEach>
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
				  });
			  */
			  
         }

         
      </script>
 
   </body>
</html>