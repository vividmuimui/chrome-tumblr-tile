$ ->
  s = new NewTile
  s.loadConfig()

  $apiKey    = $('#setting input[name="apiKey"]')
  $hostname  = $('#setting input[name="hostname"]')
  $baseWidth = $('#setting input[name="baseWidth"]')
  $margin    = $('#setting input[name="margin"]')
  $limit     = $('#setting input[name="limit"]')

  $apiKey.val(s.config.apiKey)
  $hostname.val(s.config.hostname)
  $baseWidth.val(s.config.baseWidth)
  $margin.val(s.config.margin)
  $limit.val(s.config.limit)

  $("#setting").submit(->
    hash = {
        apiKey    : $apiKey.val(),
        hostname  : $hostname.val(),
        baseWidth : parseInt($baseWidth.val()),
        margin    : parseInt($margin.val()),
        limit     : parseInt($limit.val())
    }
    s.saveConfig(hash)
    return false
  )