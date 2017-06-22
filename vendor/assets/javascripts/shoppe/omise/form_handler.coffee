$ ->
  $('form.omiseForm').on 'submit', ->
    # The form
    form = $(this)

    # Build a hash of params which will be sent to Omise
    omiseCardParams = {}
    $.each ['number', 'exp-month', 'exp-year', 'cvc', 'name', 'address_line1', 'address_line2', 'address_city', 'address_state', 'address_zip', 'address_country'], (i,f)->
      omiseCardParams[f] = $("[data-omise='#{f}']").val()

    # Send the data to Omise and define a method to be executed when the response
    # comes back from Omise.
    Omise.card.createToken omiseCardParams, (status, response)->
      if response.error
        $('p.omiseError', form).remove()
        $("<p class='omiseError'>#{response.error.message}</p>").prependTo(form)
        $('input[type=submit]', form).removeClass('disabled').prop('disabled', false)
      else
        $('[data-omise=token]').val(response['id'])
        form.get(0).submit()

    # Return false to ensure that the form doesn't submit on first click
    false
