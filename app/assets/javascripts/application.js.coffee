#= require jquery
#= require jquery_ujs
#= require turbolinks
#= require bootstrap
#= require nprogress
#= require_tree .
#= require swagger-ui


$(document).on 'page:update', ->
  console.log 'update page...'

$(document).on 'page:fetch', ->
  NProgress.start()
$(document).on 'page:change', ->
  NProgress.done()
$(document).on 'page:restore', ->
  NProgress.remove()

