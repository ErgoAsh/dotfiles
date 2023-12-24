from qutebrowser.api import interceptor
config.load_autoconfig()

c.url.searchengines = {
    'DEFAULT':  'https://google.com/search?hl=en&q={}',

    # Dictionaries
    'd':       'https://www.dictionary.com/browse/{}',
    'dc':      'https://dictionary.cambridge.org/dictionary/english/{}',
    'dm':      'https://www.merriam-webster.com/dictionary/{}',
    'e':       'https://www.etymonline.com/search?q={}',

    # Translators
    't':       'https://www.deepl.com/en/translator#en/pl/{}',
    'tg':      'https://translate.google.com/?sl=en&tl=pl&text={}&op=translate',

    # Knowledge
    'gh':      'https://github.com/search?o=desc&q={}&s=stars',
    'gist':    'https://gist.github.com/search?q={}',
    's':       'https://stackoverflow.com/search?q={}',
    'w':       'https://en.wikipedia.org/wiki/{}',
    'p':       'https://pry.sh/{}',

    # Google
    'i':      'https://www.google.com/search?tbm=isch&q={}&tbs=imgo:1',
    'm':       'https://www.google.com/maps/search/{}',
    'yt':      'https://www.youtube.com/results?search_query={}',

    # Shopping 
    'a':       'https://allegro.pl/listing?string={}',
    'sh':      'https://shopee.pl/search?keyword={}',

    # Social media
    'r':       'https://www.reddit.com/search?q={}'
}

# Open Word/PowerPoint (Office 365), Google Suite and JupyterLab (localhost:8888) in passthrough mode by default
config.set("input.mode_override", "passthrough", "*://localhost/*")
config.set("input.mode_override", "passthrough", "*://onedrive.live.com/*")
config.set("input.mode_override", "passthrough", "*://docs.google.com/*")
config.set("input.mode_override", "passthrough", "*://*.overleaf.com/project/*")

# Set default websites
c.url.start_pages = [ "https://google.com" ]
c.url.default_page = "https://google.com"

# Remove mouse 4&5 key bindings
c.input.mouse.back_forward_buttons = False

# Remove bookmarks and filesystem completion for :open
c.completion.open_categories = [ "searchengines", "quickmarks", "history" ]

# Disable Youtube autoplay
c.content.autoplay = False

# Use UTF-8
c.content.default_encoding = 'utf-8'

# Enhance adblocking
c.content.blocking.method = 'adblock'
c.content.geolocation = False

# Do not use browser notification system
c.content.notifications.enabled = False

# Run pdfjs in new page as a default option
c.content.pdfjs = True

# Always open scrolling bar
c.scrolling.bar = 'always'

# Restore windows after restart
c.auto_save.session = True

# Close finished downloads after 5 seconds
c.downloads.remove_finished = 10000

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

config.bind("<Ctrl-b>", 'spawn --userscript qute-custom-bitwarden')

config.bind('<Ctrl-J>', 'back', mode = 'passthrough')
config.bind('<Ctrl-K>', 'forward', mode = 'passthrough')
