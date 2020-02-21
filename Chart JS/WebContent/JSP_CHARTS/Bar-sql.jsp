<%@ page import = "java.io.*,java.util.*,java.sql.*"%>
<%@ page import = "javax.servlet.http.*,javax.servlet.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix = "c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix = "sql"%>
<html>

<head>
	<script src="../JS/Chart.bundle.js"></script>
	<script src="../JS/utils.js"></script>
	<style>

	</style>
</head>

<body>

<sql:setDataSource var = "snapshot" driver = "oracle.jdbc.OracleDriver"
         url = "jdbc:oracle:thin:@10.44.113.13:1527:ACMDB"
         user = "AWSPOC"  password = "pocaws321#"/>
 
       <sql:query dataSource = "${snapshot}" var = "result">
         SELECT * from AFS_DEMO WHERE ROWNUM<10
      </sql:query> 
      
      <table border = "1" >
         <tr>
            <th>MPT_TXN_ID</th>
            <th>MPT_STOR_ID</th>
            <th>MPT_USER_ID</th>
            <th>MPT_SESS_ID</th>
         </tr>
          <c:forEach var = "row" items = "${result.rows}">
            <tr>
               <td><c:out value = "${row.MPT_TXN_ID}"/></td>
               <td><c:out value = "${row.MPT_STOR_ID}"/></td>
               <td><c:out value = "${row.MPT_USER_ID}"/></td>
               <td><c:out value = "${row.MPT_SESS_ID}"/></td>
            </tr>
         </c:forEach> 
      </table>

	<div id="container" style="width: 75%;">
		<canvas id="canvas"></canvas>
	</div>

	<script>
	var san=[];
	<c:forEach var = "row" items = "${result.rows}">
		san.push(["${row.MPT_TXN_ID}","${row.MPT_STOR_ID}","${row.MPT_SESS_ID}"]);
	</c:forEach>
	console.log(san);
		var MONTHS = ['high_amount_counts', 'AVG_AMOUNT_DEVIATION_COUNTS', 'INVALID_PIN_FLAG_COUNTS', 'HOTLIST_VPA_FLAG_COUNTS', 'HOTLIST_MOBILE_FLAG_COUNTS', 'BLACKLIST_MOBILE_FLAG_COUNTS', 'QUICK_HIT_FLAG_COUNTS'];
		var color = Chart.helpers.color;
		//alert(color(window.chartColors.blue).alpha(0.5));
		var horizontalBarChartData = {
			labels:  ['HIGH_AMOUNT_COUNTS', 'AVG_AMOUNT_DEVIATION_COUNTS', 'INVALID_PIN_FLAG_COUNTS', 'HOTLIST_VPA_FLAG_COUNTS', 'HOTLIST_MOBILE_FLAG_COUNTS', 'BLACKLIST_MOBILE_FLAG_COUNTS', 'QUICK_HIT_FLAG_COUNTS','QUICK_HIT_FLAG_COUNTS'],
			datasets: [
			           {
				label: 'no_of_transactions',
				backgroundColor: color(window.chartColors.blue).alpha(0.5).rgbString(),
				/*backgroundColor: [
						window.chartColors.red,
						window.chartColors.orange,
						window.chartColors.yellow,
						window.chartColors.green,
						window.chartColors.blue,
					],*/
				borderColor: window.chartColors.blue,
				borderWidth: 1,
				data: [
					10,2,6,0,0,0,4,5
				]
 			},
 			{
 	            label: "Group value",
 	            data: [10,2,6,0,0,0,4,5],
 	            type: "line",
 	            showLines: false
 	          }
		
		]
		};
		window.onload = function() {
			var ctx = document.getElementById('canvas').getContext('2d');
			
			/*
			// Any of the following formats may be used
			var ctx = document.getElementById('myChart');
			var ctx = document.getElementById('myChart').getContext('2d');
			var ctx = $('#myChart');
			var ctx = 'myChart';
			*/
						
			window.myHorizontalBar = new Chart(ctx, {
				type: 'bar',
				data: horizontalBarChartData,
				options: {
				
					elements: {
						rectangle: {
							borderWidth: 2,
						}
					},
					responsive: true,
					legend: {
						position: 'right',
					},
					title: {
						display: true,
						text: 'Transactions_Count'
					},
					scales: {
				        xAxes: [{
				            ticks: {
				                max: 14,
				                min: 0,
				                stepSize: 2
				            }
				        }]
				    }
				}
			});
		};

		var colorNames = Object.keys(window.chartColors);
		//alert(colorNames);//red,orange,yellow,green,blue,purple,grey
		

	</script>
</body>

</html>