###
Sugar to allow quick creation of element properties.
###
Function::alias = ( propertyName, accessChain, sideEffect ) ->
    processChain = ( obj, propertyName, accessChain, sideEffect, value ) ->
      result = obj
      keys = accessChain.split "."
      setter = ( value isnt undefined) 
      for key, index in keys
        if index == keys.length - 1 and setter
          result[ key ] = value
          result = value
        else
          result = result[ key ]
      if setter and sideEffect?
        sideEffect.call obj, value
      result
    Object.defineProperty @prototype, propertyName,
      enumerable: true
      get: -> processChain @, propertyName, accessChain, sideEffect
      set: ( value ) -> processChain @, propertyName, accessChain, sideEffect, value

Function::getter = ( propertyName, get ) ->
  Object.defineProperty @prototype, propertyName, { get, configurable: true, enumerable: true }

# Polyfill for Function.name
unless Function::name?
  Object.defineProperty Function::, "name",
    get: ->
      /function\s+([^\( ]*)/.exec( @toString() )[1]

Function::property = ( propertyName, sideEffect, defaultValue, converter ) ->
  Object.defineProperty @prototype, propertyName,
    enumerable: true
    get: ->
      result = @._properties[ propertyName ]
      if result is undefined
        defaultValue
      else
        result
    set: ( value ) ->
      result = if converter
        converter.call @, value
      else
        value
      @._properties[ propertyName ] = result
      sideEffect?.call @, result

Function::propertyBool = ( propertyName, sideEffect, defaultValue ) ->
  @property propertyName, sideEffect, defaultValue, ( value ) ->
      String( value ) == "true"

Function::setter = ( propertyName, set ) ->
  Object.defineProperty @prototype, propertyName, { set, configurable: true, enumerable: true }
