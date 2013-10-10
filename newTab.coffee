$ ->
  s = new NewTile
  s.loadConfig()
  s.getPostCount().then(->
    s.getPosts().then(->
      s.draw()
    )
  )
  s.add_scroll_event()