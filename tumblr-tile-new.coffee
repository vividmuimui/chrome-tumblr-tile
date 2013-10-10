class NewTile
  constructor: ->
    @configNs = "tumblr-tile"
    @target_dom = $("#container")

  saveConfig: (hash) ->
    localStorage[@configNS] = JSON.stringify hash

  loadConfig: ->
    defaultConfig = {
      apiKey : "BKst4XKB2qdHl7eOFmjmCXDvYh7lV3xzklIakwcmAgMMSqeNEc",
      hostname : "aoi-miyazaki.tumblr.com",
      baseWidth: 250,
      margin   : 10,
      limit    : 20
    }
    strage = localStorage[@configNs]
    config = if strage then JSON.parse(strage) else {}
    @config = $.extend(defaultConfig, config)

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

  draw: ->
    for post in _.shuffle(@posts)
      view = @view(post)
      @target_dom.append(view)

  masonry: ->
    @target_dom.masonry({
      itemSelector: ".item",
      columnWidth: @config.baseWidth + @config.margin,
      isFitWidth: true,
      isAnimated: true
    });

  view: (post) ->
    alt_size = post.photos[0].alt_sizes[0];
    width = @config.baseWidth;
    height = alt_size.height * (@config.baseWidth / alt_size.width);
    '<div class="item">' +
        '<a href="' + post.post_url + '">' +
            '<img src="' + alt_size.url + '" width="' + width + '" height="' + height + '" title="' +  post.tags + '" />' +
        '</a>' +
        "<div><a href='#{post.link_url}'</a><font size='2'>#{post.tags}</font></div>" +
    '</div>'

  getJson: (url, param, func) ->
    d = new $.Deferred
    p = $.extend { api_key: @config.apiKey }, param
    $.getJSON(@baseUrl() + url, p, (json) ->
      func(json)
      d.resolve()
    )
    d

  baseUrl: ->
    "https://api.tumblr.com/v2/blog/" + @config.hostname

$ ->
  s = new NewTile
  s.loadConfig()
  s.getPostCount().then(->
    s.getPosts().then(->
      s.draw()
      s.masonry()
    )
  )
