$(document).ready ->

  # Advanced search animation.
  $('#advanced-button').click ->
    adv = $('.advanced')
    if adv.is('[visible]')
      adv.stop().animate({ height: '0', opacity: '0', 'margin-bottom': '0' }, 1000, -> adv.css('overflow', ''); adv.css('display', 'none'))
      adv.removeAttr('visible')
      $('#use-selected').val('')
    else
      adv.css('display', 'block')
      adv.stop().animate({ height: '150px', opacity: '1', 'margin-bottom': '20px' }, 1000, -> adv.css('overflow', ''))
      adv.attr('visible', '')
      $('#use-selected').val('true')

  # Rebuild advanced search params.
  p = $.parseJSON($('#repeat-search').text().replace(/\=\>/g, ':'))
  if(p['use-selected'])

    # Field checkboxes.
    $('#checkbox-title').removeAttr('checked') if !p['title']
    $('#checkbox-description').removeAttr('checked') if !p['description']
    $('#checkbox-body').removeAttr('checked') if !p['body']

    # Media selects.
    v = p['video']
    a = p['audio']
    $('#video option[value="' + v + '"]').attr('selected', '')
    $('#audio option[value="' + a + '"]').attr('selected', '')

    # Topic checkboxes.
    $('#topic_uk').removeAttr('checked') if !p['topic_uk']
    $('#topic_world').removeAttr('checked') if !p['topic_world']
    $('#topic_education').removeAttr('checked') if !p['topic_education']
    $('#topic_politics').removeAttr('checked') if !p['topic_politics']
    $('#topic_health').removeAttr('checked') if !p['topic_health']
    $('#topic_science_and_environment').removeAttr('checked') if !p['topic_science_and_environment']
    $('#topic_business').removeAttr('checked') if !p['topic_business']
    $('#topic_technology').removeAttr('checked') if !p['topic_technology']
    $('#topic_entertainment_and_arts').removeAttr('checked') if !p['topic_entertainment_and_arts']

    # Open advanced.
    $('#advanced-button').trigger('click')

  # Bind search form submit button.
  $('#search-button').click ->
    $('#search-form').submit()


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
  $('#begin-date').datepicker('setDate', p['begin-date']) if p['use-selected']
  $('#end-date').datepicker('setDate', p['end-date']) if p['use-selected']

  # Slider.
  w = if p['use-selected'] then p['slop'] else 0
  $('#advanced-slop .advanced-title span').text('( max distance of ' + w + ' words )')
  $('#advanced-slop input').val(w)
  $('#advanced-slop #slop').slider({
    min:0,
    max:30,
    value: w,
    range:'min'
    slide: (event, ui) ->
      t = if ui.value == 1 then '( max distance of 1 word )' else '( max distance of ' + ui.value + ' words )'
      $('#advanced-slop .advanced-title span').text(t)
      $('#advanced-slop input').val(ui.value)
  })

  # News body slider.
  $('.result-card').click ->
    body = $('.result-body', this)
    if body.is('[visible]')
      body.removeAttr('visible')
      body.stop().animate({height: 0}, 1000, -> body.css('display', 'none'))
    else
      $('.result-card .result-body[visible]').trigger('click')
      body.css('display', 'block')
      h = $('.body', body).height()
      body.attr('visible', '')
      body.stop().animate({height: h}, 1000, -> body.css('height', 'auto'))
