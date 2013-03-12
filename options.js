$(function() {

    tumblrTile.loadConfig();

    var $apiKey    = $('#setting input[name="apiKey"]');
    var $hostname  = $('#setting input[name="hostname"]');
    var $baseWidth = $('#setting input[name="baseWidth"]');
    var $margin    = $('#setting input[name="margin"]');
    var $limit    = $('#setting input[name="limit"]');

    $apiKey.val(tumblrTile.config.apiKey);
    $hostname.val(tumblrTile.config.hostname);
    $baseWidth.val(tumblrTile.config.baseWidth);
    $margin.val(tumblrTile.config.margin);
    $limit.val(tumblrTile.config.limit);

    $("#setting").submit(function() {
        var hash = {
            apiKey   : $apiKey.val(),
            hostname : $hostname.val(),
            baseWidth: parseInt($baseWidth.val()),
            margin   : parseInt($margin.val()),
            limit   : parseInt($limit.val())
        };

        tumblrTile.saveConfig(hash);
        return false;
    });
});
