# Description
#   hubot script for notifying people when merge compatibility is broken
#
# Commands:
#   merge test subscribe CruGlobal\repo_name - subscribes the current room to receive notifications about the defined repo
#   merge test list all - lists all repo subscriptions for all rooms
#
# Author:
#   Spencer Oberstadt

_ = require('underscore')

module.exports = (robot) ->
  updateBrain = (subs) ->
    robot.brain.set 'repo_subscriptions', subs

  getSubscriptions = ->
    robot.brain.get('repo_subscriptions') or []

  getSubscriptionsForRepo = (repo) ->
    _.where getSubscriptions(), repo: repo

  saveSubscription = (room, repo, res) ->
    subs = getSubscriptions()
    newSub =
      room: room
      repo: repo
    subs.push newSub
    updateBrain subs
    res.send "Ok, I'll alert this room of errors to merge on #{repo}"
  
  # Finds the room for most adaptors
  findRoom = (res) ->
    room = res.envelope.room
    if _.isUndefined(room)
      room = res.envelope.user.reply_to
    room

  listAllSubscriptions = (res) ->
    subs = getSubscriptions()
    if subs.length == 0
      res.send 'No merge status subscriptions yet :('
    else
      subsText = ["Here's the merge status subscriptions for every room:"].concat(_.map(subs, (sub) ->
        "Room: #{sub.room}, Repo: #{sub.repo}"
      ))
      res.send subsText.join('\n')
    return

  robot.respond /merge test subscribe (CruGlobal\/[\w-]+)/i, (res) ->
    saveSubscription(findRoom(res), res.match[1], res)

  robot.respond /merge test list all/i, (res) ->
    listAllSubscriptions(res)

  robot.router.post '/hubot/failed_merge_check', (req, res) ->
    data   = if req.body.payload? then JSON.parse req.body.payload else req.body
    repo   = data.repo
    author = data.author

    console.log("Request notifying failure of #{repo} by #{author}")

    message = "Failed to merge master into staging on #{repo}. " + 
                "Fix it soon before another developer ties to merge their branch into staging!"

    for sub in getSubscriptionsForRepo(repo)
      robot.messageRoom(sub.room, message)

    res.send 'OK'
