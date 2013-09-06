class EngineManager
  constructor: (@solver) ->
    @worker = new Worker('js/enumerate.js')
    @worker.onmessage = (event) =>
      message = JSON.parse(event.data)
      method = @[message.method]
      method.apply(@, message.args) if method

  @DEFAULT_OPTIONS =
    ticks: 100
    all: no

  start: (options) ->
    if options
      options = _.default(EngineManager.DEFAULT_OPTIONS)
    else
      options = EngineManager.DEFAULT_OPTIONS
    @invokeWorker('start', options)

  log: (message) ->
    console.log "Worker: #{message}"

  onProgress: (ticks, values) ->
    $('#status').html(EngineManager.printValues(values))

  onComplete: ->
    $('#status').html('Completed')

  invokeWorker: (method, args...) ->
    @worker.postMessage(JSON.stringify(
      method: method
      args: args
    ))

  @printValues: (values) ->
    if _.isArray(values)
      _.reduce(
        values
        (str, item) ->
          str += '-' if str.length > 0
          str += "<#{item}>"
        ''
      )
    else
      values.toString()

$ ->
  enman = new EngineManager()

  $('#play')
    .button(
      text: no
      icons: primary: 'ui-icon-play'
    )
    .click -> enman.start()
