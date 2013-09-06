class EngineManager
  constructor: (@ui, @solver) ->
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
    @options = options
    @invokeWorker('start', options)

    @ui.progressbar.progressbar 'option', 'max', @options.ticks

  log: (message) ->
    console.log "Worker: #{message}"

  onProgress: (ticks, values) ->
    @ui.status.html(EngineManager.printValues(values))
    @ui.progressbar.progressbar 'value', ticks
    @ui.progressLabel.text "#{Math.floor(100.0*ticks/@options.ticks)}%"

  onComplete: ->
    @ui.status.html 'Completed'
    @ui.progressbar.progressbar 'value', @options.ticks
    @ui.progressLabel.text 'Completed'

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
  ui =
    status: $ '#status'
    progressbar: $ '#progressbar'
    progressLabel : $ '.progress-label'

  enman = new EngineManager(ui)

  $('#play')
    .button(
      text: no
      icons: primary: 'ui-icon-play'
    )
    .click -> enman.start()

  ui.progressbar.progressbar value: off