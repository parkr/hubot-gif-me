# Description:
#   Bring some Hubot magic to your personal collection of gifs.
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_GIF_ME_ENDPOINT
#
# Commands:
#   hubot gif me silly
#   hubot gif me rage

module.exports = (robot) ->
  robot.respond /gif me (\w+)/i, (msg) ->
    msg.send "Merp, 'gif me' isn't implemented yet."
