$ ->
    $('.js-region ul .active a').each ->
        setClassAndRegionHiddenValue.apply(@);

    $('.js-region ul a').click ->
        setClassAndRegionHiddenValue.apply(@)

setClassAndRegionHiddenValue = () ->
    $parent = $(@).parents('.js-region')
    $parent.find('.value').html($(this).html())
    $parent.find('li').removeClass('active')
    $(@).parent().addClass('active')
    $(@).parent().click()
    $(@).parents('form').find('[id$="region"]').val($(this).data('region'))
    false