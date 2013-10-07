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

  getPostCount: ->
    @getJson("/info", {}, (json)=>
      @postsConut = json.response.blog.posts
    )

  getPosts: ->
    param = {
      offset: Math.max(Math.floor(Math.random() * @postsConut - @config.limit), 0 ),
      limit: @config.limit
    }
    console.log {offset: param.offset, limit: param.limit, postCount: @postsConut}
    @getJson("/posts/photo", param, (json) =>
      @posts = json.response.posts
    )

  getJson: (url, param, func) ->
    d = new $.Deferred
    p = $.extend { api_key: @config.apiKey }, param
    $.getJSON(@baseUrl() + url, p, (json) ->
      func(json)
      d.resolve()
    )
    d

  baseUrl: ->
    "https://api.tumblr.com/v2/blog/" + @config.hostName

$ ->
  s = new NewTile
  s.loadConfig()
