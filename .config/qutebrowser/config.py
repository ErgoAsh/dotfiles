from qutebrowser.api import interceptor

config.load_autoconfig()

c.url.searchengines = {
    'DEFAULT':  'https://google.com/search?hl=en&q={}',

    # Shopping 
    'a':       'https://allegro.pl/listing?string={}',
    'sh':      'https://shopee.pl/search?keyword={}',

    # Dictionaries
    'dd':      'https://thefreedictionary.com/{}',
    'de':      'https://www.etymonline.com/search?q={}',

    # Social media
    'fb':      'https://www.facebook.com/s.php?q={}',
    'r':       'https://www.reddit.com/search?q={}',

    # Knowledge
    'gh':      'https://github.com/search?o=desc&q={}&s=stars',
    'gist':    'https://gist.github.com/search?q={}',
    'st':      'https://stackoverflow.com/search?q={}',
    'w':       'https://en.wikipedia.org/wiki/{}',
    'p':       'https://pry.sh/{}',

    # Google
    'gi':      'https://www.google.com/search?tbm=isch&q={}&tbs=imgo:1',
    'm':       'https://www.google.com/maps/search/{}',
    'yt':      'https://www.youtube.com/results?search_query={}'
}

c.url.start_pages = [ "https://google.com" ]
c.url.default_page = "https://google.com"

# Remove Mouse 4&5 key bindings
c.input.mouse.back_forward_buttons = False

# Disable Youtube autoplay
c.content.autoplay = False

# Enhance adblocking
c.content.blocking.method = 'both'
c.content.default_encoding = 'utf-8'
c.content.geolocation = False

# Run pdfjs in new page as a default option
c.content.pdfjs = True

# Always open scrolling bar
c.scrolling.bar = 'always'

config.unbind('d', mode = 'normal')
config.unbind('u', mode = 'normal')
config.unbind('xo', mode = 'normal')
config.unbind('xO', mode = 'normal')
config.unbind('<Ctrl-v>', mode = 'normal')

config.bind('d', 'scroll-page 0 0.5', mode = 'normal')
config.bind('u', 'scroll-page 0 -0.5', mode = 'normal')
config.bind('zo', 'set-cmd-text -s :open -b', mode = 'normal')
config.bind('zO', 'set-cmd-text :open -b -r {url:pretty}', mode = 'normal')
config.bind('<Ctrl-i>', 'mode-enter passthrough', mode = 'normal')
config.bind('U', 'undo', mode = 'normal')
config.bind('D', 'tab-close', mode = 'normal')
config.bind('x', 'tab-close', mode = 'normal')

config.bind('d', 'scroll-page 0 0.5', mode = 'caret')
config.bind('u', 'scroll-page 0 -0.5', mode = 'caret')

config.bind("<Ctrl-b>", 'spawn --userscript qute-bitwarden')
