module.exports = (robot) ->
  # the expected value of :room is going to vary by adapter, it 
  # might be a numeric id, name, token, or some other value
  robot.router.post '/hubot/send_to/:room', (req, res) ->
    room   = req.params.room
    data   = if req.body.payload? then JSON.parse req.body.payload else req.body
    message = data.message

    robot.messageRoom room, message

    res.send 'OK'
