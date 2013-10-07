class NewTile
  constructor: ->
    @configNs = "tumblr-tile"

  saveConfig: (hash) ->
    localStorage[@configNS] = JSON.stringify hash

  loadConfig: ->
    defaultConfig = {
      apiKey : "BKst4XKB2qdHl7eOFmjmCXDvYh7lV3xzklIakwcmAgMMSqeNEc",
      hostName : "aoi-miyazaki.tumblr.com",
      baseWidth: 250,
      margin   : 10,
      limit    : 20
    }
    strage = localStorage[@configNS]
    config = if strage then JSON.parse(strage) else {}
    @config = $.extend defaultConfig, config

$ ->
  s = new NewTile
  s.loadConfig()
