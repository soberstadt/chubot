# Description
#   hubot script for finding the id of the current room  
#
# Commands:
#   hubot room - Reply with the current room
#
# Author:
#   Spencer Oberstadt

_ = require('underscore')

module.exports = (robot) ->
  # Finds the room for most adaptors
  findRoom = (msg) ->
    room = msg.envelope.room
    if _.isUndefined(room)
      room = msg.envelope.user.reply_to
    room

  robot.respond /(?:room)|(?:channel)$/i, (res) ->
    res.send("current room id: #{findRoom(res)}")
