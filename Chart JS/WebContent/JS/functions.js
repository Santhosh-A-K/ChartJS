function barChange()
{
	var tempConfig=$.extend(true, {}, merchIdConfigBar1);//$.extend(true, {}, merchIdConfigBar1);//BarChart.chart.config;
	BarChart.destroy();
	if(tempConfig.type=="bar"||tempConfig.type=="horizontalBar")
	{
		var xaxis=tempConfig.options.scales.xAxes;
		var yaxis=tempConfig.options.scales.yAxes;
		if(tempConfig.type=="bar")
		{
			tempConfig.type="horizontalBar";
			tempConfig.options.animation.onComplete=function() {
	    		
               /* var sourceCanvas = BarChart.chart.canvas;
                var copyWidth = BarChart.scales['x-axis-0'].width - 10;
                var copyHeight = BarChart.scales['x-axis-0'].height + BarChart.scales['x-axis-0'].top + 10;
                var targetCtx = document.getElementById("myChartAxis").getContext("2d");
                targetCtx.canvas.width = copyWidth;
        targetCtx.drawImage(sourceCanvas, 0, 0, copyWidth, copyHeight, 0, 0, copyWidth, copyHeight);*/
            // To only draw at the end of animation, check for easing === 1
           /* var ctx = this.chart.ctx;
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

                
            });*/
            

           
    	};
			
		}
		else if(tempConfig.type=="horizontalBar")
		{
			tempConfig.type="bar";
		}
		tempConfig.options.scales.xAxes=yaxis;
		tempConfig.options.scales.yAxes=xaxis;
		
		BarChart=new Chart(barCtx,tempConfig);
	}
	
}
var axeslabel="";
function findLabel(dataset)
{
	var max=Math.max.apply(null,dataset)
	if(max>Math.pow(1000,(4)))
	{
		axeslabel="T";
	}
	else if(max>Math.pow(1000,(3)))
	{
		axeslabel="B";
	}
	else if(max>Math.pow(1000,(2)))
	{
		axeslabel="M";
	}
	else if(max>Math.pow(1000,(1)))
	{
		axeslabel="K";
	}
	else
	{
		axeslabel="";
	}
}
function axesRange(currency,value,label)
{
	var units = ["K", "M", "B", "T"];
	var val=units.indexOf(label);
	if(value==0)
	{
		return "";
	}
	
	if(val!=-1)
	{
		return currency+(value / Math.pow(1000,(val+1))).toFixed(2)+units[val];
	}
	else
	{
		return currency+value;
	}
}

function sortLabelAndData(arrayData,arrayLabel,san,master)
{/*if(master.localeCompare("asc")==0)
		{
			var vj1="b.data>a.data";
			var vj2="b.data<a.data";
		}
		else
		{
			var vj1="b.data<a.data";
			var vj2="b.data>a.data";
		}
		var sortedArrayOfObj = arrayOfObj.sort(function(a, b) {
			if(eval(vj1))
		  		return 1;
			else if(eval(vj2))
				return -1;
			else
				return 0;
		});*/
	
	
	
	var arrayOfObj = arrayLabel.map(function(d, i) {
		  return {
		    label: d,
		    data: arrayData[i] || 0
		  };
		});
	if(san.localeCompare("data")==0)
	{
		var sortedArrayOfObj = arrayOfObj.sort(function(a, b) {
			if((master.localeCompare("asc")==0)?b.data<a.data:b.data>a.data)
		  		return 1;
			else if((master.localeCompare("asc")==0)?b.data>a.data:b.data<a.data)
				return -1;
			else
				return 0;
		});

		return sortedArrayOfObj;
	}
	else
	{
		var sortedArrayOfObj = arrayOfObj.sort(function(a, b) {
			if((master.localeCompare("asc")==0)?b.label<a.label:b.label>a.label)
		  		return 1;
			else if((master.localeCompare("asc")==0)?b.label>a.label:b.label<a.label)
				return -1;
			else
				return 0;
		});

		return sortedArrayOfObj;
	}
}

function getBarchartDataMerchID()
{
	targetLabels=[];
	targetDataset = [{label:"TotalAmount", backgroundColor: color(window.chartColors.blue).alpha(0.5).rgbString(),data:[]}];
	sumAmountDateMrchJs.forEach(function(o){
		var x=targetLabels.indexOf(o.mpt_merc_id);
		if(x==-1)
		{
			targetLabels.push(o.mpt_merc_id);
			targetDataset[0].data.push(o.sum);
		}
		else
		{
			targetDataset[0].data[x]+=o.sum;
		}
	 	
	 });
	 var sort=sortLabelAndData(targetDataset[0].data,targetLabels,"data","desc");
	 targetLabels=[];
	 targetDataset[0].data=[];
	 sort.forEach(function(t){
		 targetLabels.push(t.label);
		 targetDataset[0].data.push(t.data);
	 });
	 return {labels:targetLabels, datasets:targetDataset};
}

function getLinechartDataDate()
{
	sumAmountDateMrchJs.forEach(function(o){
		var x=dateLabels.indexOf(o.dates);
		if(x==-1)
		{
			dateLabels.push(o.dates);
			dateDataset[0].data.push(o.sum);
		}
		else
		{
			dateDataset[0].data[x]+=o.sum;
		}
		 
	});
	var sortedDateArray=sortLabelAndData(dateDataset[0].data,dateLabels,"label","asc");
	dateLabels = [];
	dateDataset[0].data=[];
	sortedDateArray.forEach(function(d){
		dateLabels.push(d.label);
		dateDataset[0].data.push(d.data);
		});
	 return {
			labels:dateLabels,
			datasets:dateDataset
	};
}

function getLineChartDataWeekday(finalDateTemp)//finalDate
{
	var weekdayLabel=['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'];
		var tempLabel=finalDateTemp.labels;
		var tempDataset=finalDateTemp.datasets[0].data;
		var weekData=[0,0,0,0,0,0,0];
		for(var i=0;i<tempLabel.length;i++)
		{
			var val=new Date(String(tempLabel[i])).getDay();
			weekData[val]=weekData[val]+parseInt(tempDataset[i]);
		}
		return {labels:weekdayLabel,data:weekData};
}

function getDoughnutChartData()
{
	sumAmountDateMrchJs.forEach(function(o){
		if(String(o.mpt_stat_name).includes("OMANNET"))
		{
			doughnutData[0].data[doughnutLabel.indexOf("OMANNET")]+=1;
		}
		else if(String(o.mpt_stat_name).includes("VISA"))
		{
			doughnutData[0].data[doughnutLabel.indexOf("VISA")]+=1;
		}
		else if(String(o.mpt_stat_name).includes("MASTERCARD"))
		{
			doughnutData[0].data[doughnutLabel.indexOf("MASTERCARD")]+=1;
		}
		else
		{
			doughnutData[0].data[doughnutLabel.indexOf("OTHERS")]+=1;
		}
	});
	return {labels:doughnutLabel,datasets:doughnutData};
}

function assignTopValue() {
	
	if(event.key === 'Enter' ||(flag==true && document.getElementById('topdis').value>1)) //|| flagTop==true) 
	{
	  flag=false;
	  var x = document.getElementById('topdis').value; 
	  var barchartDataTop;
	  var lineDateLabelTop=[];
	  var lineDateDataTop=[];
	  var lineWeekdayLabelTop=weekdayLabels;//['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday']
	  var lineWeekdayDataTop=[0,0,0,0,0,0,0];
	  var doughnutLabelTop=doughnutLabel;//['VISA','MASTERCARD','OMANNET','OTHERS']
	  var doughnutDataTop=[0,0,0,0];
	  if(flagTop==false)
	  {
		  barchartDataTop=getBarchartDataMerchID();
		  data=barchartDataTop.datasets[0].data;
		  label=barchartDataTop.labels;
	  }
	  
	  if(x>1)
		  {
		  var topValue=parseInt(x);
		  var len=data.length>=topValue?topValue:data.length;
		  var Labels=[];
		  var Dataset = [];
		  for(var i=0;i<len;i++)
			  {
			  Labels.push(label[i]);
			  Dataset.push(data[i]);
			  }
		  sumAmountDateMrchJs.forEach(function(o){
			  if(Labels.indexOf(o.mpt_merc_id)!=-1)
			  {
				  var lineDateCheck=lineDateLabelTop.indexOf(o.dates);
				  var lineWeekdayCheck=new Date(String(o.dates)).getDay();
				  if(lineDateCheck==-1)
				  {
					  lineDateLabelTop.push(o.dates);
					  lineDateDataTop.push(o.sum);
				  }
				  else
				  {
					  lineDateDataTop[lineDateCheck]+=o.sum;
				  }
				  lineWeekdayDataTop[lineWeekdayCheck]+=o.sum;
				  if(String(o.mpt_stat_name).includes("OMANNET"))
					{
					  doughnutDataTop[doughnutLabelTop.indexOf("OMANNET")]+=1;
					}
					else if(String(o.mpt_stat_name).includes("VISA"))
					{
						doughnutDataTop[doughnutLabelTop.indexOf("VISA")]+=1;
					}
					else if(String(o.mpt_stat_name).includes("MASTERCARD"))
					{
						doughnutDataTop[doughnutLabelTop.indexOf("MASTERCARD")]+=1;
					}
					else
					{
						doughnutDataTop[doughnutLabelTop.indexOf("OTHERS")]+=1;
					}
				  
			  }
		  });
		  var tempBarConfig=BarChart.chart.config;
		  BarChart.destroy();
		  tempBarConfig.data.labels=Labels;
		  tempBarConfig.data.datasets[0].data=Dataset;
		  
		  tempBarConfig.options.animation.onComplete=function(){};
		  console.log(tempBarConfig);
		  //merchIdConfigBar1.data.labels=Labels;
		  //merchIdConfigBar1.data.datasets[0].data=Dataset;
		  
		  lineChart.destroy();
		  sumDateConfigLine.data.labels=lineDateLabelTop;
		  sumDateConfigLine.data.datasets[0].data=lineDateDataTop;
		  
		  weekDayChart.destroy();
		  weekdayCongigLine.data.labels=lineWeekdayLabelTop;
		  weekdayCongigLine.data.datasets[0].data=lineWeekdayDataTop;
		  
		  doughnutChart.destroy();
		  doughnutChartConfig.data.labels=doughnutLabelTop;
		  doughnutChartConfig.data.datasets[0].data=doughnutDataTop;

		  BarChart = new Chart(barCtx,tempBarConfig);
		  //BarChart = new Chart(barCtx,merchIdConfigBar1);
		  lineChart = new Chart(lineDateCtx,sumDateConfigLine);
		  weekDayChart = new Chart(weekdayCtx,weekdayCongigLine);
		  doughnutChart = new Chart(doughnutCtx,doughnutChartConfig);
		  }
	  else
		  {
		  alert("Enter value greater than 1");
		  }  
	  
	}
}

function assignTopValueFilter(newArrayData,newArrayLabel) {
	  data=newArrayData;
	  label=newArrayLabel;
	  assignTopValue();
}

function clearFilter()
{
	document.getElementById('topdis').value="";
	BarChart.destroy();
	lineChart.destroy();
	weekDayChart.destroy();
	doughnutChart.destroy();
	merchIdConfigBar1.data=getBarchartDataMerchID();
	sumDateConfigLine.data=getLinechartDataDate();
	 var temp=getLineChartDataWeekday(finalDate);
	 weekdayDataset[0].data=temp.data;
	 weekdayLabels=temp.labels;
	 var tempdata={
	 		labels:weekdayLabels,
	 		datasets:weekdayDataset
	 }
	weekdayCongigLine.data=tempdata;//finalDate;
	doughnutChartConfig.data=getDoughnutChartData();
	BarChart = new Chart(barCtx,merchIdConfigBar1);
	lineChart = new Chart(lineDateCtx,sumDateConfigLine);
	weekDayChart = new Chart(weekdayCtx,weekdayCongigLine);
	doughnutChart = new Chart(doughnutCtx,doughnutChartConfig);
	
}

function changeChart(value)
{
	if(BarChart.chart.config.type=="horizontalBar")
	barChange();
	var curConfig=$.extend(true, {}, BarChart.chart.config);
	var tempConfig=$.extend(true, {}, merchIdConfigBar1);//same jQuery.extend(true, {}, merchIdConfigBar1)
	BarChart.destroy();
	if(value.localeCompare("bar")==0)
	{
		curConfig.type="bar";
		curConfig.options.scales=tempConfig.options.scales;
		curConfig.options.plugins=tempConfig.options.plugins;
		curConfig.data.datasets[0].backgroundColor=tempConfig.data.datasets[0].backgroundColor;
		curConfig.options.animation.onComplete=tempConfig.options.animation.onComplete;
		BarChart=new Chart(barCtx,curConfig);
	}
	else if(value.localeCompare("line")==0)
	{
		curConfig.type="line";
		curConfig.options.scales=tempConfig.options.scales;
		curConfig.options.plugins=tempConfig.options.plugins;
		curConfig.data.datasets[0].backgroundColor=tempConfig.data.datasets[0].backgroundColor;
		curConfig.options.animation.onComplete=tempConfig.options.animation.onComplete;
		BarChart=new Chart(barCtx,curConfig);
	}
	else if(value.localeCompare("doughnut")==0)
	{
		
		var len=curConfig.data.labels.length;
		var col=chroma.scale('Spectral').domain([1,0]).colors(len);
		//var col=chroma.scale('YlGnBu').colors(len);
		curConfig.options.scales={};
		curConfig.type="doughnut";
		curConfig.data.datasets[0].backgroundColor=col;
		curConfig.options.animation.onComplete=function(){};
		curConfig.options.plugins={
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
	    				  findLabel(curConfig.data.datasets[0].data);
	                      return axesRange("$",args.value,axeslabel);
			    		  //return axesRange("",args.value,"K");
			    	    },
			    	    arc: false,
			    	    fontColor: '#000',
			    	    position: 'border'
	    		  
	    		  }
	    		  ]
	     };
		alert("hi");
		BarChart=new Chart(barCtx,curConfig);
	}
	
}
