{LineRawMessageListener, LineImageListener, LineVideoListener, LineAudioListener, LineLocationListener,
LineStickerListener, LineContactListener, LineRawOperationListener, LineFriendListener, LineBlockListener,
LineTextAction, LineImageAction, LineVideoAction, LineAudioAction, LineLocationAction, LineStickerAction
} = require 'hubot-line'


module.exports = (robot) ->
  # LINE platform will access the endpoint to get image and audio contents.
  contentEndpoint = 'https://your-server/download'

  robot.respond /badger/i, (res) ->
    res.send "Badgers? BADGERS? WE DON'T NEED NO STINKIN BADGERS"

  robot.listeners.push new LineImageListener robot, (() -> true), (res) ->
    res.message.content (content) ->
      robot.brain.set res.message.id, new Buffer(content, 'binary').toString('base64')
      originalContentUrl = "#{contentEndpoint}?id=#{res.message.id}"
      res.message.previewContent (previewContent) ->
        robot.brain.set "p#{res.message.id}", new Buffer(previewContent, 'binary').toString('base64')
        previewImageUrl = "#{contentEndpoint}?id=p#{res.message.id}"
        res.emote new LineImageAction originalContentUrl, previewImageUrl

  robot.listeners.push new LineVideoListener robot, (() -> true), (res) ->
    res.message.content (content) ->
      originalContentUrl = "https://github.com/umakoz/hubot-line-example/raw/master/content/video.mp4"
      res.message.previewContent (previewContent) ->
        previewImageUrl = "https://github.com/umakoz/hubot-line-example/raw/master/content/video.jpg"
        res.emote new LineVideoAction originalContentUrl, previewImageUrl

  robot.listeners.push new LineAudioListener robot, (() -> true), (res) ->
    res.message.content (content) ->
      robot.brain.set res.message.id, new Buffer(content, 'binary').toString('base64')
      originalContentUrl = "#{contentEndpoint}?id=#{res.message.id}"
      res.emote new LineAudioAction originalContentUrl, 1000

  robot.listeners.push new LineLocationListener robot, (() -> true), (res) ->
    res.emote new LineLocationAction res.message.address, res.message.latitude, res.message.longitude

  robot.listeners.push new LineStickerListener robot, (() -> true), (res) ->
    res.emote new LineStickerAction res.message.STKID, res.message.STKPKGID

  robot.listeners.push new LineContactListener robot, (() -> true), (res) ->
    res.send "got a contact. mid: #{res.message.mid} displayName: #{res.message.displayName}"

  # If you want to listen summarized messages like following.
  #robot.listeners.push new LineRawMessageListener robot, (() -> true), (res) ->
  #  res.send "RawMessage! id: #{res.message.id}"

  robot.listeners.push new LineFriendListener robot, (() -> true), (res) ->
    res.send "be a friend. mid: #{res.message.mid}"

  robot.listeners.push new LineBlockListener robot, (() -> true), (res) ->
    # process something when a bot account was blocked.

  # If you want to listen summarized operations like following.
  #robot.listeners.push new LineRawOperationListener robot, (() -> true), (res) ->
  #  res.send "RawOperation!"



  # LINE platform will access the endpoint to get image and audio contents.
  robot.router.get "/download", (req, res) =>
    content = robot.brain.get req.query.id
    robot.brain.remove req.query.id
    res.set('Content-Type', 'binary')
    res.send new Buffer(content, 'base64')
