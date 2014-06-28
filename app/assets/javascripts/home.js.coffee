$ ->
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
