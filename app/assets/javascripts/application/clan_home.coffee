$ ->
  $('.js-switch a').click ->
    $(@).tab('show')
    $(@).parent().find('a').removeClass('active')
    $(@).addClass('active')
    false
