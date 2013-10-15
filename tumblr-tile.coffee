class NewTile
  constructor: ->
    @configNs = "tumblr-tile"
    @target_dom = $("#container")

  saveConfig: (hash) ->
    localStorage[@configNs] = JSON.stringify hash

  loadConfig: ->
    defaultConfig = {
      hostname : "aoi-miyazaki.tumblr.com",
      baseWidth: 250,
      margin   : 10,
      limit    : 20
    }
    strage = localStorage[@configNs]
    config = if strage then JSON.parse(strage) else {}
    @config = $.extend(defaultConfig, config)
    console.log @config

  getPostCount: ->
    d = new $.Deferred
    @getJson("/info", {}, (json)=>
      @postsConut = json.response.blog.posts
      d.resolve()
    )
    d


  getPosts: ->
    d = new $.Deferred
    param = {
      offset: Math.max(Math.floor(Math.random() * @postsConut - @config.limit), 0 ),
      limit: @config.limit
    }
    console.log {offset: param.offset, limit: param.limit, postCount: @postsConut}
    @getJson("/posts/photo", param, (json) =>
      @posts = json.response.posts
      d.resolve()
    )
    d

  draw: ->
    for post in _.shuffle(@posts)
      view = @view(post)
      @target_dom.append(view)
    @target_dom.masonry({
      itemSelector: ".item",
      columnWidth: @config.baseWidth + @config.margin,
      isFitWidth: true,
      isAnimated: true
    });

  add_scroll_event: ->
    isAccessTumblr = false
    $(window).scroll =>
      scrollTop = $(window).scrollTop()
      windowheight = $(window).height()
      documentheight = $(document).height()

      if isAccessTumblr == false && (documentheight - scrollTop) <= windowheight * 1.5
        isAccessTumblr = true

        @getPosts().then(=>
          posts = ""
          for post in @posts
            posts += @view(post)

          posts = $(posts)
          for post in posts
            $(post).css({
              'margin': @config.margin / 2,
              'width': @config.baseWidth
            })

          @target_dom.append(posts).masonry('appended', posts, false)
        ).then ->
          isAccessTumblr = false

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
    p = $.extend { api_key: @config.apiKey }, param
    $.getJSON(@baseUrl() + url, p, (json) ->
      func(json)
    )

  baseUrl: ->
    "https://api.tumblr.com/v2/blog/" + @config.hostname
