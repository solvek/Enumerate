Enumerators =
  simple: (count) ->
    count : count
    represent: (raw) -> raw
  range: (from, to) ->
    count: to - from + 1
    represent: (raw) -> from+raw
  set: (item...) ->
    count: item.length
    represent: (raw) -> item[raw]

Analyze =
  UNDEFINED: 0
  SUCCESS: 1
  FAIL: 2

class Engine
  start: (options) ->
    @_options = options
    @reset()
    @idx = 0
    @execute()

  reset: ->
    @values = []
    @status = Analyze.UNDEFINED
    @_enumerators = []

  execute: ->
    if @idx < @_options.ticks
      @trigger('onProgress', @idx, [@idx])
      @idx++
      setTimeout(
        => @execute()
        500
      )
    else
      @trigger('onComplete')

  trigger: (method, args...) ->
    postMessage(JSON.stringify(
      method: method
      args: args
    ))

  log: (message) ->
    @trigger('log', message)

## Solver
  nextEnumerator: ->
    if @values.length < 10
      Enumerators.simple(10000)

  analyze: ->

engine = new Engine()
#engine.start()

addEventListener 'message', (event) ->
  message = JSON.parse(event.data)
  engine[message.method].apply(engine, message.args)
