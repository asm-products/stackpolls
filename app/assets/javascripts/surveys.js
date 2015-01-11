// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/



// Manage the survey items
var SurveyItems = {
  itemsEndpoint: $('#survey-item-form-template').attr('rel'),
  itemEmptyImageUrl: $('#survey-item-form-template thumbnail img').attr('src'),
  itemFormTemplate: $('#survey-item-form-template').remove().html(),
  itemShowTemplate: $('#survey-item-show-template').remove().html(),
  currentlyEditing: null,
  currentlyEditingObject: null,
  
  init: function() {
    $( document ).ajaxError(function( event, jqxhr, settings, thrownError ) {
      if (jqxhr.status == 422 && SurveyItems.currentlyEditing && jqxhr.responseJSON) {
        SurveyItems.showValidationErrors(jqxhr.responseJSON);
      } else {
        console.log("Ajax Error: ", event, jqxhr, settings, thrownError);
        alert("Sorry, there was a server error that we couldn't recover from, for the last action you took. =[ ");
      }
    });
    
    this.fetchItems();
    
    // listen to add item button
    $('#survey-items-add-button').click(function(ev) {
      ev.preventDefault();
      if (SurveyItems.currentlyEditing && !SurveyItems.formItemEmpty()) {
        SurveyItems.saveEditingItem(function() { SurveyItems.appendNewForm(); });
      }
      else if (SurveyItems.currentlyEditing && SurveyItems.formItemEmpty()) {
        SurveyItems.currentlyEditing.remove();
        SurveyItems.currentlyEditing = null;
        SurveyItems.currentlyEditingObject = null;
        SurveyItems.appendNewForm();
      }
      else {
        SurveyItems.appendNewForm();
      }
    });

    
    // set photo url
    $('#survey-item-thumnail-url-set').click(function (ev) { 
      var newUrl = $('#set_thumbnail_url').val();
      SurveyItems.currentlyEditingObject.thumbnail_url = newUrl;
      SurveyItems.currentlyEditing.find('#survey_item_thumbnail_url').val( newUrl );
      
      SurveyItems.currentlyEditing.find('.thumbnail img').attr('src', ( newUrl && newUrl != '' ? newUrl : SurveyItems.itemEmptyImageUrl))
      
      $('#survey-item-thumbnail-url-modal').modal('hide');
    });
    
    // set thumbnail url field on popup 
    $('#survey-item-thumbnail-url-modal').on('show.bs.modal', function (ev) {
      $('#set_thumbnail_url').val( $('#survey_item_thumbnail_url').val() );
    });
    
    // auto-highlight thumbnail url field on popup
    $('#survey-item-thumbnail-url-modal').on('shown.bs.modal', function (ev) {
      $('#set_thumbnail_url').get(0).focus();
    });
  },
  
  showValidationErrors: function(errs) {
    var firstKey = null;
    for (var key in errs) {
      if (!firstKey && $('#survey_item_'+key).get(0)) { firstKey = key; }
      $('#survey_item_'+key).closest('.form-group').addClass('has-error');
    }
    $('#survey_item_'+firstKey).get(0).focus();
    $('#survey-item-fields-loading').hide();
  },
  
  // Return a observed div from itemFormTemplate
  editItemDiv: function() {
    var newEl = $("" + SurveyItems.itemFormTemplate);
    
    newEl.find('#save-current-survey-item-button').click(function(ev) {
      ev.preventDefault();
      SurveyItems.saveEditingItem();
    });
    
    newEl.find('#revert-current-survey-item-button').click(function(ev) {
      ev.preventDefault();
      SurveyItems.revertEditingItem();
    });
    
    return newEl;
  },
  
  appendNewForm: function() {
    var newEl = SurveyItems.editItemDiv();

    $('#no-survey-items').hide();
    $('#survey-items').show();
    $('#survey-items').append(newEl);
    SurveyItems.currentlyEditing = newEl;
    $('#survey_item_headline').get(0).focus();
  },
  
  formItemEmpty: function() {
    var nonEmptyValExists = false;
    if (SurveyItems.currentlyEditing) {
      $('#survey-item-fields input, #survey-item-fields textarea').each(function(i) {
        var valVal = $(this).val();
        if (valVal && valVal != '') {
          nonEmptyValExists = true;
        }
      });
    }
    return !nonEmptyValExists;
  },
  
  turnEditingItemToShow: function(data) {
    var showLi = SurveyItems.showItemDiv(data);
    if (SurveyItems.currentlyEditing) {
      SurveyItems.currentlyEditing.replaceWith(showLi);
    }
    SurveyItems.currentlyEditing = null;
    SurveyItems.currentlyEditingObject = null;
  },
  
  revertEditingItem: function(callback) {
    var idFieldVal = $('#survey_item_id').val();
    if (idFieldVal && idFieldVal != '') { // wasn't new, load original from server
      $('#survey-item-fields-loading').show();
      var endpoint = SurveyItems.itemsEndpoint;
      endpoint = endpoint.replace('/survey_items.json', '/survey_items/'+idFieldVal+'.json');
      $.getJSON(endpoint, function(data) {
        $('#survey-item-fields-loading').hide();
        SurveyItems.turnEditingItemToShow(data);
        if (callback) { callback(); }
      });
    }
    else { // was new, just get rid of it
      SurveyItems.currentlyEditing.remove();
      SurveyItems.currentlyEditing = null;
      SurveyItems.currentlyEditingObject = null;
    }
    
  },
  
  saveEditingItem: function(callback) {
    $('#survey-item-fields-loading').show();
    
    var endpoint = SurveyItems.itemsEndpoint;
    var serializedForm = $('#survey-item-fields input, #survey-item-fields textarea').serialize();
    var idFieldVal = $('#survey_item_id').val();
    if (idFieldVal && idFieldVal != '') {
      endpoint = endpoint.replace('/survey_items.json', '/survey_items/'+idFieldVal+'.json');
      serializedForm = serializedForm + "&_method=put";
    }
    
    $.post(endpoint, serializedForm, function(data) {
      if (data.errors && data.errors.length > 0) {
        alert("Saving failed =[");
        $('#survey-item-fields-loading').hide();
      } else {
        $('#survey-item-fields-loading').hide();
        SurveyItems.turnEditingItemToShow(data);
        if (callback) { callback(); }
      }
    }, 'json');
  },
  
  showItemDiv: function(itemObject) {
    var showLi = $(""+this.itemShowTemplate);
    if (itemObject.thumbnail_url && itemObject.thumbnail_url != '') {
      showLi.find('.thumbnail img').attr('src', itemObject.thumbnail_url);
    }
    if (itemObject.thumbnail_url || itemObject.thumbnail_url == '') {
      showLi.find('.survey-item').removeClass('no-thumbnail');
    } else {
      showLi.addClass('no-thumbnail');
    }
    showLi.find('h3.headline').text(itemObject.headline);
    showLi.find('div.description').text(itemObject.description);
    if (itemObject.id) {
      showLi.find('.survey-item').attr('id', showLi.find('.survey-item').attr('id') + itemObject.id);
      showLi.find('.survey-item').attr('rel', showLi.find('.survey-item').attr('rel').replace('/survey_items.json', '/survey_items/'+itemObject.id+'.json'));
    }
    
    showLi.click(function(ev) {
      var showedItem = $(this); 
      if (SurveyItems.currentlyEditing && !SurveyItems.formItemEmpty()) {
        SurveyItems.saveEditingItem(function() { SurveyItems.turnShowToEditingItem(showedItem); });
      }
      else if (SurveyItems.currentlyEditing && SurveyItems.formItemEmpty()) {
        SurveyItems.currentlyEditing.remove();
        SurveyItems.currentlyEditing = null;
        SurveyItems.currentlyEditingObject = null;
        SurveyItems.turnShowToEditingItem(showedItem);
      }
      else {
        SurveyItems.turnShowToEditingItem(showedItem);
      }
    });
    return showLi;
  },
  
  turnShowToEditingItem: function(showedItem, callback) {
    var editDiv = this.editItemDiv();
    this.currentlyEditing = editDiv;
    this.currentlyEditingObject = null;
    var itemUrl = showedItem.find('.survey-item').attr('rel');
    showedItem.replaceWith(editDiv);
    editDiv.find('#survey-item-fields-loading').show();
    $.getJSON(itemUrl, function(data) {
      SurveyItems.currentlyEditingObject = data;
      editDiv.find('#survey_item_id').val(data.id);
      editDiv.find('#survey_item_headline').val(data.headline);
      editDiv.find('#survey_item_description').val(data.description);
      editDiv.find('#survey_item_thumbnail_url').val(data.thumbnail_url);
      if (data.thumbnail_url && data.thumbnail_url != '') {
        editDiv.find('.thumbnail img').attr('src', data.thumbnail_url);
      }
      editDiv.find('#survey_item_headline').get(0).focus();
      editDiv.find('#survey-item-fields-loading').hide();
    });
  },
  
  fetchItems: function() {
    $.getJSON(this.itemsEndpoint, function(array) {
      for (var i=0; i < array.length; ++i) {
        var showLi = SurveyItems.showItemDiv(array[i]);
        $('#survey-items').append(showLi);
      }
      
      $('#survey-items-loading').remove();
      $('#survey-items-has-loaded').show();
      if (array.length == 0) {
        $('#no-survey-items').show();
        $('#survey-items').hide();
      } else {
        $('#no-survey-items').hide();
        $('#survey-items').show();
      }
    });
  }
};

// Main - make sure we're on a survey items page
if ($('#survey-items-loading').get(0)) {
  SurveyItems.init();
}