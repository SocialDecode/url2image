# url2image
Create images from url

##Instalation

    npm install
    mkdir cache
    cp config.json.example config.json

## Runtime
Just start with forever or directly with coffee

    forever start -c coffee url2image.coffee
    #OR
    coffee url2image.coffee

## Usage
Depending on the configuration, just hit the server with the url you want to render:

    http://<yourserver>:<port>/<url_to_render>

The first time a new url is loaded, it will take a couple of seconds to render it, after that, all other calls will answer with the cache version of the image. Cache lasts for 24 hours before deleting itself.
