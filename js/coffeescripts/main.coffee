class SlideShowManager
  constructor: () ->
    $(document).pitchdeck({
      link_labels: true
    })
    
class ROICalculator
  constructor: () ->
    $('img[rel=tooltip]').tooltip()
    $('#revenue_goal, #average_revenue').live('keyup', @handle_text)
    $('#funnel_it').live('click', @funnel)
    $('#rev_it').live('click', @rev)
    
  handle_text: () ->
    format_number = (x) ->
      x = x.toString()
      pattern = /(-?\d+)(\d{3})/
      while (pattern.test(x))
        x = x.replace(pattern, "$1,$2")
      return x
    
    ok = true
    $('#revenue_goal, #average_revenue').each (index, value) =>
      val = parseInt($(value).val().replace(/,/gi, ''))
      if val <= 0 or isNaN(val) then ok = false
      else
        $(value).val(format_number val)
    
    if ok then $('#funnel_it').removeClass('disabled')
    
  funnel: () ->
    if $(this).hasClass('disabled') then return
    $("#funnel_1").show().goTo()
    
    format_number = (x) ->
      x = x.toString()
      pattern = /(-?\d+)(\d{3})/
      while (pattern.test(x))
        x = x.replace(pattern, "$1,$2")
      return x
    
    revenue_goal = parseFloat($('#revenue_goal').val().replace(/,/gi, ''))
    average_revenue = parseFloat($('#average_revenue').val().replace(/,/gi, ''))
    revenue_marketing = parseFloat($('#revenue_marketing').val().replace(/,/gi, ''))
    if isNaN(revenue_marketing) or conversion == ""
      revenue_marketing = 35
    conversion = parseFloat($('#conversion').val().replace(/,/gi, ''))
    if isNaN(conversion) or conversion == ""
      conversion = 2
    lead = parseFloat($('#lead').val().replace(/,/gi, ''))
    if isNaN(lead) or lead == ""
      lead = 0.25
    else
      lead = lead.toFixed(2)
      
    
    e7 = conversion / 100
    e11 = lead / 100
    e16 = Math.round(revenue_goal * revenue_marketing / 100)
    e13 = Math.round(e16 / average_revenue)
    e9 = Math.round(e13 / e11)
    e5 = Math.round(e9 / e7)
    
    g5 = 0.074
    g7 = 0.2
    g11 = 0.25
    
    i5 = e5*(1 + g5)
    i7 = e7*(1 + g7)
    i9 = i5*i7
    i11 = (e11*(1 + g11) * 100).toFixed(2)
    i13 = i9*i11 / 100
    i16 = i13*average_revenue
    
    i5 = Math.round i5
    i9 = Math.round i9
    i13 = Math.round i13
    i16 = Math.round i16
    
    k5 = i5 - e5
    k9 = i9 - e9
    k13 = i13 - e13
    k16 = i16 - e16
    
    lift = Math.round ((i5 * 100 / e5) - 100).toFixed(2)
    i7 = (i7*100).toFixed(2)
    
    if lead < 1 then lead = lead.toString().replace('0.', '.')
    if i7 < 1 then i7 = i7.toString().replace('0.', '.')
    if i11 < 1 then i11 = i11.toString().replace('0.', '.')
    if lift < 1 then lift = lift.toString().replace('0.', '.')
    $('.conversion.leads .value').text("#{conversion}%")
    $('.conversion.customers .value').text("#{lead}%")
    $('.machine_conversion.lift .value').text("#{lift}%")
    $('.machine_conversion.new_leads .value').text("#{i7}%")
    $('.machine_conversion.new_customers .value').text("#{i11}%")
    
    $('.funnel .value.visitors').text("#{format_number e5}")
    $('.funnel .value.leads').text("#{format_number e9}")
    $('.funnel .value.customers').text("#{format_number e13}")
    $('.funnel_value').text("$#{format_number e16}")
    
    $('.funnel_2 .value.visitors').append("<span class='new'>#{format_number i5}</span>")
    $('.funnel_2 .value.leads').append("<span class='new'>#{format_number i9}</span>")
    $('.funnel_2 .value.customers').append("<span class='new'>#{format_number i13}</span>")
    $('#funnel_2 .funnel_value').append("<span class='new'>$#{format_number i16}</span>")
      
    $('#funnel_2 .gains.visitors .value').text(format_number k5)
    $('#funnel_2 .gains.leads .value').text(format_number k9)
    $('#funnel_2 .gains.customers .value').text(format_number k13)
    $('#funnel_2 .gains.revenue .value').text("$#{format_number k16}")
    
  rev: () ->
    $("#funnel_2").show().goTo()

$(document).ready () ->
  # $.stellar({
  #   hideDistantElements: false
  # })
  
  
  $(".fancyVideo").live('click', () ->
    $.fancybox({
          'width'         : 800,
          'height'        : 482,
          'href'          : this.href.replace(new RegExp("watch\\?v=", "i"), 'v/'),
          'type'          : 'swf',
          'swf'           : {
          'wmode'             : 'transparent',
          'allowfullscreen'   : 'true'
          }
      });

    return false
  )

  
  new ROICalculator
  new SlideShowManager
  
(($) ->
  $.fn.goTo = () ->
    $('html, body').animate({
      scrollTop: $(this).offset().top - 90 + 'px'
    }, 'slow');
    return this
)(jQuery);

  