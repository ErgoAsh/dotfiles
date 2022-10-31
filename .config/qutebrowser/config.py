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
    't':       'https://www.thesaurus.com/browse/{}',

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

# Disaple Youtube autoplay
c.content.autoplay = False

# Enhance adblocking
c.content.blocking.method = 'both'
c.content.default_encoding = 'utf-8'
c.content.geolocation = False

# Run embedded pdfjs
c.content.pdfjs = True

# Always open scrolling bar
c.scrolling.bar = 'always'

#config.bind('<Ctrl-u>', 'undo')
#config.bind('d', )

config.bind("<Ctrl-b>", 'spawn --userscript qute-bitwarden')
