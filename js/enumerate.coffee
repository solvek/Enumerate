Analyze =
  UNDEFINED: 0
  SUCCESS: 1
  FAIL: -1

class Average
  constructor: ->
    @value = 0.0
    @count = 0

  add: (val) ->
    next = @count + 1
    @value *= @count/next
    @value += val/next
    @count = next

class Engine
  start: (options) ->
    @_options = options
    @reset()
    @execute()

  reset: ->
    @values = []
    @size = 0
    @status = Analyze.UNDEFINED
    @_lastTicks = -1

  execute: ->
    loop
      @status = @analyze()
      if @status == Analyze.SUCCESS
        @trigger('onSolution', @pureValues())
        break unless @_options.all

      if @status != Analyze.FAIL
        enumerator = @nextEnumerator()
        if enumerator
          value = @values[@size] ? {avr : new Average}
          value.raw = 0
          value.enumerator = enumerator
          value.avr.add(enumerator.count)
          @addValue(value)
          continue

      while @size > 0
        last = @values[@size-1]
        @onStateRemove(last) if @onStateRemove
        @size--
        if last.raw < last.enumerator.count - 1
          last.raw++
          @addValue(last)
          break

      break if @size == 0
    @trigger('onComplete')

  addValue: (value) ->
    value.value = value.enumerator.toValue(value.raw)
    ticksPerOne =
      if @size == 0
        @_options.ticks
      else
        @values[@size-1].ticksPerOne
    value.ticksPerOne = ticksPerOne / value.avr.value
    value.ticks = (if @size == 0 then 0 else @values[@size-1].ticks)+Math.floor(value.ticksPerOne*value.raw)
    if value.ticks > @_lastTicks
      @trigger('onProgress', value.ticks, @pureValues())
      @_lastTicks = value.ticks
    @onStateAdd(value) if @onStateAdd
    @values[@size++] = value

  trigger: (method, args...) ->
    postMessage(JSON.stringify(
      method: method
      args: args
    ))

  pureValues: -> @values.map (item) -> item.enumerator.toString(item.value, item.raw)

## Solver
  @queenPosition =
    count: 64
    toValue: (row) ->
      x: Math.floor(row / 8)
      y: row % 8
    toString: (value) -> "(#{String.fromCharCode(65+value.x)}#{1+value.y})"

  nextEnumerator: -> Engine.queenPosition

  analyze: ->
    if @size == 8
      Analyze.SUCCESS
    else
      if @isConflicted
        Analyze.FAIL
      else
        Analyze.UNDEFINED

  onStateRemove: -> @isConflicted = no

  onStateAdd: (state) ->
    for idx in [0...@size]
      other = @values[idx]
      difx = state.value.x - other.value.x
      dify = state.value.y - other.value.y
      if state.value.x == other.value.x or state.value.y == other.value.y or difx == dify or difx == - dify
        @isConflicted = yes
        return
    return

engine = new Engine()

addEventListener 'message', (event) ->
  message = JSON.parse(event.data)
  engine[message.method].apply(engine, message.args)
