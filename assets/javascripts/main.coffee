$(document).ready ->

  # Advanced search animation.
  $('#advanced-button').click ->
    adv = $('.advanced')
    if adv.is('[visible]')
      adv.stop().animate({ height: '0', opacity: '0', 'margin-bottom': '0' }, 1000, -> adv.css('overflow', ''); adv.css('display', 'none'))
      adv.removeAttr('visible')
    else
      adv.css('display', 'block')
      adv.stop().animate({ height: '150px', opacity: '1', 'margin-bottom': '20px' }, 1000, -> adv.css('overflow', ''))
      adv.attr('visible', '')

  # Better checkboxes.
  $('.advanced-check').iCheck({
    checkboxClass: 'icheckbox_square-grey',
    radioClass: 'iradio_square-grey',
    increaseArea: '20%'
  })

  # Better dropdowns.
  $('.advanced-select').dropkick({
    theme: 'black',
    change: (value, label) ->
      $(this).dropkick('black', value)
  })

  # Date pickers.
  $('#advanced-date input').datepicker()
  $('#advanced-date input').datepicker('option', 'dateFormat', 'yy-mm-dd')

  # Slider.
  $('#advanced-slop .advanced-title span').text('( max distance of 0 words )')
  $('#advanced-slop input').val(0)
  $('#advanced-slop #slop').slider({
    min:0,
    max:30,
    value:0,
    range:'min'
    slide: (event, ui) ->
      t = if ui.value == 1 then '( max distance of 1 word )' else '( max distance of ' + ui.value + ' words )'
      $('#advanced-slop .advanced-title span').text(t)
      $('#advanced-slop input').val(ui.value)
  })

  # Test.
  #$('#search-button').click ->
    #adv = $('#test')
    #if adv.is('[visible]')
      #adv.stop().animate({ height: '50px', 'margin-bottom': '0' }, 1000, -> adv.css('overflow', '');)
      #adv.removeAttr('visible')
    #else
      #curHeight = adv.height()
      #autoHeight = adv.css('height', 'auto').height()
      #adv.height(curHeight)
      #adv.stop().animate({ height: autoHeight, 'margin-bottom': '20px' }, 1000, ->
        #adv.css('overflow', '')
        #adv.height('auto'))
      #adv.attr('visible', '')
