from collections import namedtuple
from toml import load

ItemInfo = namedtuple('iteminfo', "title cover date rating comment tags")
config = load('_config.toml')

PAGE_INTERVAL = 15

database = config['DataBase']


class User:
    id_ = config['doubanid']
    book_pages = config['Book']['MaxLimit']
    movie_pages = config['Movie']['MaxLimit']


class TypeAnno:
    from requests_html import Element, HTMLResponse
    from typing import List
    Element = Element
    Elements = List[Element]
    HTMLResponse = HTMLResponse
