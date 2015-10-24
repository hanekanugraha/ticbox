// By ichsan@gmail.com

var SurveyChartRenderer = function() {

};
  
// [1, 3] will be [25, 75]
SurveyChartRenderer.prototype.calcPercentage = function(amounts) {
  var total = 0;

  var i = 0;
  for (i = 0; i < amounts.length; i++) {
    total += amounts[i];
  }

  var percentage = [];
  for (i = 0; i < amounts.length; i++) {
    percentage[i] = 100 * amounts[i] / total;
  }

  return percentage;
}

// Requires jqplot.barRenderer.js plugin
SurveyChartRenderer.prototype.forStar = function(amounts, canvasObj, title) {
  var s1 = amounts;
  var ticks = [];

  var i = 0;
  for (i = 0; i < amounts.length; i++) {
    ticks[i] = '&#9733; ' + (i + 1);
  }

  // Create labels with percentage
  var percentages = this.calcPercentage(amounts);

  var labels = [];
  for (i = 0; i < amounts.length; i++) {
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

  var i = 0;
  var labels = [];
  for (i = 0; i < amounts.length; i++) {
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
