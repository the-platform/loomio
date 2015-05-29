angular.module('loomioApp').factory '$exceptionHandler', ->
  (exception, cause) ->
    if window.Loomio.environment == 'production'
      Airbrake.push
        error:
          message : exception.toString()
          stack : exception.stack
        params:
          user_id: window.Loomio.currentUserId

    console.log "Loomio exception: #{exception.message}", exception, cause
