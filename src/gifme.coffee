# Description:
#   Bring some Hubot magic to your personal collection of gifs.
#
# Dependencies:
#   underscore
#   url
#
# Configuration:
#   HUBOT_GIF_INDEX - the full URL to the JSON index file
#
# Commands:
#   hubot gif me silly
#   hubot gif me rage

_   = require 'underscore'
Url = require 'url'

class GifManager

  constructor: (host, index) ->
    @host        = host
    @index       = index
    @categorized = null

  groupedCategories: ->
    @categorized = _.groupBy @index, (gifHash) ->
      gifHash.path.split("/")[0]

  random: (array) ->
    array[_.random(0, array.length)]

  fullUrl: (path) ->
    "#{@host}/#{path}"

  fetchFromCategory: (query) ->
    match = null
    @groupedCategories() unless @categorized?
    _.each @categorized, (gifs, category) ->
      if not match? and query.test category
        match = gifs
    if match?
      @fullUrl(@random(match).path)

  fetchFromIndex: (query) ->
    match = null
    _.each @index, (gif) ->
      if not match? and query.test gif.path
        match = gif
    if match?
      @fullUrl(match.path)

  fetch: (query) ->
    @fetchFromCategory(query) or @fetchFromIndex(query) or "No match for #{query}."

module.exports = (robot) ->
  robot.respond /gif me( \w+)?/i, (msg) ->
    asked = msg.match[1].trim()
    unless asked?
      msg.send "Gotta ask me for somethin' homeboy."
      return
    query = new RegExp(asked, 'i')
    index = process.env.HUBOT_GIF_INDEX

    unless index?
      msg.send "HUBOT_GIF_INDEX isn't set, don't know where your gifs are!"
      return

    robot.http(index).get() (err, res, body) ->
      if err
        msg.send "gifme: There was an error fetching the index: #{err}"
        return
      info = Url.parse index
      mgr = new GifManager("#{info.protocol}//#{info.hostname}", JSON.parse(body))
      msg.send mgr.fetch(query)
