var tumblrTile;

tumblrTile || (function() {

    tumblrTile = {
        configNs       : "tumblr-tile",
        saveConfig     : saveConfig,
        loadConfig     : loadConfig,
        draw           : draw,
        getTumblrPhotos: getTumblrPhotos,
        config         : undefined,
    };

    function saveConfig(hash) {
        localStorage[this.configNs] = JSON.stringify(hash);
    }

    function loadConfig() {
        var configStr = localStorage[this.configNs];
        var config    = configStr ? JSON.parse(configStr) : {};

        var defaultConfig = {
            apiKey : "BKst4XKB2qdHl7eOFmjmCXDvYh7lV3xzklIakwcmAgMMSqeNEc",
            hostname : "aoi-miyazaki.tumblr.com",
            baseWidth: 250,
            margin   : 10,
            limit    : 20
        };

        this.config = $.extend(defaultConfig, config);
    }

    function draw() {
        var self = this;

        self.loadConfig();

        if ( ! self.config.apiKey ) {
            console.log("not exists api key");
            return 1;
        }
        var isAccessTumblr = false;
        var items = new Array;
        var i = 0;

        self.getTumblrPhotos(function(div) {
            items[i] = div;
            i++;
        }).then(function() {
            items = shuffle(items);
            for (i = 0; i <= items.length; i++) {
                $("#container").append($(items[i]));
            }
            $("#container").masonry({
                itemSelector: ".item",
                columnWidth: self.config.baseWidth + self.config.margin,
                isFitWidth: true,
                isAnimated: true
            });
        }).then(function() {
            $(window).scroll(function() {
                if ( isAccessTumblr == false && $(window).scrollTop() + $(window).height() >= $(document).height() ) {

                    isAccessTumblr = true;
                    var items = "";

                    self.getTumblrPhotos(function(div) {
                       items += div;

                    }).then(function() {
                        var $items = $(items);

                        if($items.length !== 0){
                            for(i = 0 ; i < $items.length ; i++){
                                $($items.get(i)).css({
                                    'margin':(self.config.margin / 2),
                                    'width':self.config.baseWidth
                                });
                            }
                        }

                        $("#container").append($items).masonry( 'appended', $items, false );
                    }).then(function() {
                        isAccessTumblr = false;
                    });
                }
            });
        });

    }

    function getTumblrPhotos(func) {

        var self = this;
        var d = $.Deferred();
        param = {
            api_key: self.config.apiKey,
            offset: Math.floor(Math.random() * 1000),
            limit: self.config.limit
        }
        $.getJSON(
            "https://api.tumblr.com/v2/blog/" + self.config.hostname + "/posts/photo",
            param,
            function(json) {

                json.response.posts.forEach(function(val, index, array) {
                    if ( ! val.photos ) {
                        return 1;
                    }
                    var j    = 0;
                    var diffSizes = val.photos[0].alt_sizes.map(function(alt_size) {
                        return {
                            diffWidth: Math.abs(alt_size.width - self.config.baseWidth),
                            index    : j++
                        };
                    });

                    diffSizes.sort(function(a, b) {
                        if ( a.diffWidth > b.diffWidth ) {
                            return 1;
                        }
                        else if ( a.diffWidth < b.diffWidth ) {
                            return -1;
                        }
                        return 0;
                    });

                    var altSize = val.photos[0].alt_sizes[diffSizes[0].index];
                    width = self.config.baseWidth;
                    height = altSize.height * (self.config.baseWidth / altSize.width);
                    var div = '<div class="item"><a href="' + val.post_url + '"><img src="' + altSize.url+ '" width="' + width + '" height="' + height + '" /></a></div>';
                    func(div);
                });

                d.resolve();
            }
        );

        return d;
    }

    var shuffle = function(a){
        for(var j, x, i = a.length; i; j = parseInt(Math.random() * i), x = a[--i], a[i] = a[j], a[j] = x);
        return a;
    };
})();
