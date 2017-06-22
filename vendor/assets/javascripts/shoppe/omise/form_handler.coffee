$ ->
  $('form.stripeForm').on 'submit', ->
    # The form
    form = $(this)

    # Build a hash of params which will be sent to Stripe
    stripeCardParams = {}
    $.each ['number', 'exp-month', 'exp-year', 'cvc', 'name', 'address_line1', 'address_line2', 'address_city', 'address_state', 'address_zip', 'address_country'], (i,f)->
      stripeCardParams[f] = $("[data-stripe='#{f}']").val()

    # Send the data to Stripe and define a method to be executed when the response
    # comes back from Stripe.
    Stripe.card.createToken stripeCardParams, (status, response)->
      if response.error
        $('p.stripeError', form).remove()
        $("<p class='stripeError'>#{response.error.message}</p>").prependTo(form)
        $('input[type=submit]', form).removeClass('disabled').prop('disabled', false)
      else
        $('[data-stripe=token]').val(response['id'])
        form.get(0).submit()

    # Return false to ensure that the form doesn't submit on first click
    false
