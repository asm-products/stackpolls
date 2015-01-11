// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/
var EditorAccept = {
  active: false,
  init: function() {
    $('#accept-editor-invite-button').click(function(ev) {
      if (EditorAccept.active) { return; } // return 
      
      EditorAccept.active = true;
      var btn = $('#accept-editor-invite-button');
      btn.addClass('disabled').text(btn.text().replace("Accept ", "Accepting ") + "...");
      
      $.post(btn.attr('rel'), { editor: { accepted: '1' }, _method: 'put' }, function(data) {
        window.location = btn.attr('data-success-url'); 
      }, 'json')
    });
  }
};

// main
if ($('#accept-editor-invite-button').get(0)) {
  EditorAccept.init();
}