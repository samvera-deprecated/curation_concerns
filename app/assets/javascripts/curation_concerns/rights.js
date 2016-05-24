Blacklight.onLoad(function () {
  $('.force-select').each(function(){
    if ($(this).data('force-value')){
      var option = $('<option>', { value: $(this).data('force-value'), text: $(this).data('force-label')});
      $(this).append($(option).attr('selected','selected'));
    }
  });
});
