// By ichsan@gmail.com

var SurveyChartRenderer = function() {

};
  
// [1, 3] will be [25, 75]
SurveyChartRenderer.prototype.calcPercentage = function(amounts) {
  var total = 0;

  for (var i = 0; i < amounts.length; i++) {
    total += amounts[i];
  }

  var percentage = [];
  for (var i = 0; i < amounts.length; i++) {
    percentage[i] = 100 * amounts[i] / total;
  }

  return percentage;
}

// Requires jqplot.barRenderer.js plugin
SurveyChartRenderer.prototype.forStar = function(amounts, canvasObj, title) {
  var s1 = amounts;
  var ticks = [];

  for (var i = 0; i < amounts.length; i++) {
    ticks[i] = '&#9733; ' + (i + 1);
  }

  // Create labels with percentage
  var percentages = this.calcPercentage(amounts);

  var labels = [];
  for (var i = 0; i < amounts.length; i++) {
    labels[i] = amounts[i] + ' (' + Math.round(percentages[i]) + '%)'; // '21 (5%)'
  }

  // Draw now!
  plot2 = canvasObj.jqplot([s1], {
    seriesDefaults: {
      renderer:$.jqplot.BarRenderer,
        pointLabels: { 
          show: true,
          labels: labels,
          edgeTolerance: -100
        },
        rendererOptions: {
          barDirection: 'horizontal',
		  varyBarColor: true // Just like Google Play :)
        }
    },
    axes: {
      yaxis: {
        renderer: $.jqplot.CategoryAxisRenderer,
          ticks: ticks
      }
    },
    title: {
      text: title
    }
  });
}

// Requires jqplot.barRenderer.js plugin
SurveyChartRenderer.prototype.forChoice = function(ticks, amounts, canvasObj, title) {
  var s1 = amounts;
 
  // Create labels with percentage
  var percentages = this.calcPercentage(amounts);

  var labels = [];
  for (var i = 0; i < amounts.length; i++) {
    labels[i] = amounts[i] + ' (' + Math.round(percentages[i]) + '%)'; // '21 (5%)'
  }

  // Draw now!
  plot2 = canvasObj.jqplot([s1], {
    seriesDefaults: {
      renderer:$.jqplot.BarRenderer,
        pointLabels: { 
          show: true,
          labels: labels,
          edgeTolerance: -100
        },
        rendererOptions: {
          barDirection: 'horizontal',
		  varyBarColor: true // Just like Google Play :)
        }
    },
    axes: {
      yaxis: {
        renderer: $.jqplot.CategoryAxisRenderer,
          ticks: ticks
      }
    },
    title: {
      text: title
    }
  });
}

SurveyChartRenderer.prototype.forScale = function(scaleLabels, itemValuesRows, canvasObj, title) {
  var numOfRows = itemValuesRows.length;
  var length = itemValuesRows[0].values.length;

  var body = document.getElementsByTagName('body')[0];

  var tbl = document.createElement('table');
  
  tbl.style.width = '100%';
  tbl.setAttribute('style', 'border-collapse: collapse; border: 0px solid #999999; color: #424242');
  
  var colorSteps = ['#ffffe0', '#fffcdb', '#fffad7', '#fff8d1', '#fff5cd', '#fff2c8', '#fff0c4', '#ffedbf', '#ffeaba', '#ffe8b7', '#ffe5b2', '#ffe3af', '#ffe1ab', '#ffdda7', '#ffdba4', '#ffd8a0', '#ffd59c', '#ffd299', '#ffd096', '#ffcd93', '#ffcb90', '#ffc88d', '#ffc58a', '#ffc288', '#ffc086', '#ffbd83', '#ffb981', '#ffb67f', '#ffb47d', '#ffb07b', '#ffae79', '#ffab77', '#ffa775', '#ffa474', '#ffa172', '#ff9e70', '#ff9a6f', '#ff976d', '#ff956c', '#fe916b', '#fe8f6a', '#fd8b69', '#fc8868', '#fb8567', '#fa8366', '#f98065', '#f87d64', '#f77b63', '#f67762', '#f57562', '#f37261', '#f36f60', '#f16c5f', '#f0695e', '#ee665d', '#ed635c', '#ec615b', '#ea5f5b', '#e95b59', '#e75859', '#e55658', '#e45356', '#e35056', '#e14d54', '#df4b53', '#dd4852', '#db4551', '#da434f', '#d7404e', '#d53d4d', '#d43b4b', '#d2384a', '#d03548', '#ce3346', '#cc3045', '#c92e43', '#c82b42', '#c52840', '#c3263d', '#c0233c', '#be213a', '#bb1e37', '#ba1c35', '#b71933', '#b41731', '#b2152e', '#af122c', '#ad1029', '#aa0e27', '#a80b24', '#a50921', '#a2071f', '#a0051c', '#9d0418', '#990215', '#970111', '#93010e', '#91000a', '#8e0006', '#8b0000'];
  
  var tbdy = document.createElement('tbody');
  for (var i = 0; i < numOfRows; i++) {
    var tr = document.createElement('tr');
    var label = itemValuesRows[i].label;
    var values = itemValuesRows[i].values;
    var percentage = this.calcPercentage(values);

    var td = document.createElement('td');
	td.setAttribute('style', 'border: 1px solid #999999; padding: 5px 20px; white-space:nowrap');
    td.appendChild(document.createTextNode(label))
    tr.appendChild(td)

	for (var j = 0; j < length; j++) {
        td = document.createElement('td');
		var percentageJ = percentage[j];
		var color = colorSteps[parseInt(percentageJ) - 1];
		var fontColor = '#000000';
		if (percentageJ >= 80) {
			fontColor = '#ffffff';
		}

		td.setAttribute('style', 'border: 1px solid #999999; padding: 5px 20px; background-color:' + color + '; color: ' + fontColor);
        td.appendChild(document.createTextNode(values[j]))
        tr.appendChild(td)
	}
	tbdy.appendChild(tr);
  }

  // For scale labels
  var tr = document.createElement('tr');
  var td = document.createElement('td');
  tr.appendChild(td)

  for (var j = 0; j < scaleLabels.length; j++) {
	  td = document.createElement('td');
	  td.setAttribute('style', 'border: 0px solid #999999; padding: 20px 5px; font-size: 0.8em; white-space:nowrap; -ms-transform: rotate(30deg); -webkit-transform: rotate(30deg); transform: rotate(30deg); position: relative');
	  
	  var wrapper = document.createElement('span');
	  wrapper.appendChild(document.createTextNode(scaleLabels[j]))
	  wrapper.setAttribute('style', 'position: absolute');

	  td.appendChild(wrapper)
	  tr.appendChild(td)
  }
  tbdy.appendChild(tr);

  tbl.appendChild(tbdy);

  var titleDiv = document.createElement('div');
  titleDiv.setAttribute('class', 'jqplot-title');
  titleDiv.setAttribute('style', 'text-align: center;');
  titleDiv.appendChild(document.createTextNode(title));
  canvasObj.get(0).appendChild(titleDiv);

  canvasObj.get(0).appendChild(tbl);
}

