// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/

var ResponseForm = {
  submitInProgress: false,
  init: function() {
    
    $('#new_response').submit(function(ev) {
      if (ResponseForm.submitInProgress) {
        alert("It seems like you tried to submit a response twice in a row... standby while we record the first one, sorry!");
        ev.PreventDefault();
        return;
      }
      ResponseForm.submitInProgress = true;
      $('#submitting-modal').modal('show');
    });
    
    $( "#item-ranks-list" ).sortable({
      axis: "y",
      containment: "#new_response",
      opacity: 0.7,
      update: function( event, ui ) {
        ResponseForm.updateAllRanks();
      }
    });
    
    $('#survey-item-thumbnail-zoom-modal').on('show.bs.modal', function(ev) {
      var trigger = $(ev.relatedTarget) // Button that triggered the modal
      var imageUrl = trigger.data('fullsize-url');
      var modal = $(this);
      modal.find('img.thumbnail-zoomed').attr('src', imageUrl);
    });
  },
  updateAllRanks: function() {
    $( "#item-ranks-list li" ).each(function(i) {
      $(this).find('.rank-field').val(i);
    });
  }
};

var ResponseShow = {
  init: function() {
    $('table.tablesorter').tablesorter();
  }
};

var ResponseIndex = {
  chartOptions:  {
    title: '',
    legend: { position: 'none' },
    vAxis: {
      textPosition: 'none',
      baselineColor: 'none',
      gridlines: {
        color: 'transparent'
      }
    },
    hAxis: {
      textPosition: 'none',
      baselineColor: 'none',
      gridlines: {
        color: 'transparent'
      }
    }
  },
  init: function() {
    // Wait until everything is loaded to do js
    ResponseIndex.initHistograms();
    $('#responses-histogram-table').tablesorter();
  },
  initHistograms: function() {
    google.load("visualization", "1", { packages:["corechart"],  callback: 'ResponseIndex.drawHistograms()' });
  },
  drawHistograms: function() {
    $('td .histogram').each(function(i) {
      var el = $(this);
      var histogramHash = JSON.parse(el.attr('data-histogram'));
      var chart = new google.visualization.ColumnChart(el.get(0));

      var dataArray = [ ['Rank', 'Number of People', { role: 'style' } ] ];
      for (var i=histogramHash.min; i < histogramHash.max+1; i++) {
        var fixedFreq = (typeof histogramHash.frequencies[""+i] != 'undefined') ? histogramHash.frequencies[""+i] : 0;
        dataArray.push( ["Ranked #"+i, fixedFreq, 'opacity: 0.4'] );
      }
      chart.draw(google.visualization.arrayToDataTable(dataArray), ResponseIndex.chartOptions);
    });
  }
};

// Main
if ($('#item-ranks.survey-item-responses').get(0)) {
  ResponseForm.init();
}
else if ($('body.controller-name-responses.controller-action-index').get(0)) {
  ResponseIndex.init();
}
else if ($('#item-ranks-ranking-table').get(0)) {
  ResponseShow.init();
}