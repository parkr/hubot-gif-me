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
#   hubot gif me
#   hubot gif me <query>
#   hubot gif list
#   hubot gif bomb <n>

_     = require 'underscore'
Url   = require 'url'

# Setup index:
indexUrl = process.env.HUBOT_GIF_INDEX
index    = null

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
    match = _.find @index, (gif) ->
      query.test gif.path
    if match?
      @fullUrl(match.path)

  fetchRandom: ->
    @fullUrl(@random(@index).path)

  fetch: (query) ->
    @fetchFromCategory(query) or @fetchFromIndex(query) or "No match for #{query}."

  list: ->
    @index.map (gif) ->
      gif.path
    .join("\n")

  bomb: (num) ->
    self = @
    _.range(0, num).map ->
      self.fetchRandom()

module.exports = (robot) ->

  # Fetch index every hour.
  fetchIndex = () ->
    robot.http(indexUrl).get() (err, res, body) ->
      if err
        robot.logger.info "gif-me encountered a problem fetching the index: #{err}"
        return
      info  = Url.parse(indexUrl)
      index = new GifManager("#{info.protocol}//#{info.hostname}", JSON.parse(body))
      robot.logger.info "gif-me index updated."
  fetchIndex()
  setInterval fetchIndex, 1000*60*60

  # /gif me
  robot.respond /gif me$/i, (msg) ->
    msg.send index.bomb(1)...

  # /gif me <query>
  robot.respond /gif me( \w+)/i, (msg) ->
    asked = msg.match[1].trim()
    query = new RegExp(asked, 'i')

    if index?
      msg.send index.fetch(query)
    else
      msg.send "No index available."

  # /gif list
  robot.respond /gif list/i, (msg) ->
    msg.send index.list()

  # /gif bomb [n]
  robot.respond /gif bomb( \w+)?/i, (msg) ->
    num = parseInt((msg.match[1] || "5").trim())

    if index?
      msg.send index.bomb(num)...
    else
      msg.send "No index available."
