# API #
## Analyze ##
One of the following values:

 - UNDEFINED = 0
 - SUCCESS = 1
 - FAIL = -1

## State ##
### Properties ###

 - **raw** : Integer
 - **value** - a representative value

## EngineOptions ##
### Properties ###

 - **ticks** : Integer, optional, default: 100 - the number of tick to be tracked
 - **all** : Boolean, optional, default: false - whether find all possible solutions. If false, process will be stopped after first solution will be found.

## Enumerator ##
### Properties ###

 - **count** : Integer
 - **represent** : function(raw : Integer)

## Engine ##
Current engine. Solver's callbacks *this* is an Engine instance.
### Properties ###

 - **values** : Array[State]
 - **status** : Analyze - last analyze result

Additionally this object can contain any other custom properties which can be used by Solver as a context.
### Private Properties ###
It is not allowed to modify private properties. It is not recommended to read private properties.

 - **solver** : Solver
 - **enumerators** : Array[Enumerator]

## Solver ##
### Events ###
An *Engine* is passed as *this* to each event

 - **nextEnumerator() : Enumerator** - required
 - **analyze() : Analyze** - required
 - **onStateAdd(state: State)** - optional
 - **onStateRemove(state: State)** - optional

## EngineManager ##
### Events ###

 - **onSolution(values : Array[State])**
 - **onCompete()**
 - **onProgress(ticks: Integer, values : Array[State])**

### Methods ###

 - **start([options: EngineOptions])**
 - **pause()**
 - **resume()**
 - **stop()**