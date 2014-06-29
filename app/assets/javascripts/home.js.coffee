
@add_markers_cluster = (users_json) ->
  users = JSON.parse(users_json)

  markers = []
  console.log users
  $.each users, (i, user) ->
    console.log i
    console.log user

    marker_position = new AMap.LngLat(user.coordinate[0], user.coordinate[1])
    marker_element = create_marker user
    marker = new AMap.Marker
      map: mapObj
      position: marker_position
      content: marker_element

    marker.on 'click', ->
      question = $(@.e).find('.marker').data('id')
      window.location.href = '/users/' + user

    markers.push(marker)

  mapObj.plugin ["AMap.MarkerClusterer"], ->
    cluster = new AMap.MarkerClusterer mapObj, markers


create_marker = (user) ->
  """
    <div class="marker" data-id="#{user.id.$oid}">
      #{user.content}
    </div>
  """

$ ->
  if $("#swagger-ui-container").length > 0
    swaggerUi = new SwaggerUi
      url: "http://localhost:3000/api/v1/doc.json"
      dom_id: "swagger-ui-container"
      supportedSubmitMethods: ['get', 'post', 'put', 'delete']
      onComplete: (swaggerApi, swaggerUi)->
        if console
          console.log "Loaded Swagger UI"
          console.log swaggerUi
        $('pre code').each (i, e)-> hljs.highlightBlock e
      onFailure: (data)->
        if console
          console.log data
      docExpansion: "list"
    swaggerUi.load()

  if $("#map").length > 0
    window.mapObj = new AMap.Map "map",
      # center: new AMap.LngLat(116.404, 39.915)
      center: new AMap.LngLat(116.304190533921, 39.97752620051956)
      level: 11

    mapObj.on 'complete', ->
      $.get '/users.js'
