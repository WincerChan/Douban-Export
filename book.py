import asyncio
from datetime import datetime

from requests_html import AsyncHTMLSession

from config import ItemInfo, TypeAnno, PAGE_INTERVAL, User
from mongo import do_insert, init_db
from parses import get_date, get_rating, get_comment, get_tags, get_item_count

Base_URL = "https://book.douban.com/people/%s/collect?start=" % User.id_
ass = AsyncHTMLSession()


def parse_book(item: TypeAnno.Element) -> ItemInfo:
    """
    Parse one book info.
    """
    cover = item.xpath("//img/@src", first=True)

    date = get_date(item)  # type: datetime

    rating = get_rating(item)  # type: int

    title = item.xpath('//a/@title', first=True)  # type: str

    comment = get_comment(item)  # type: str

    tags = get_tags(item)  # type: list

    url = item.xpath('//a/@href', first=True)  # type: str

    return ItemInfo(title, cover, date, rating, comment, tags, url)


async def get_books(url: str, is_first=False):
    """
    Get all books in one page.
    """
    resp = await ass.get(url, cookies={'bid': 'FMmHbs6EbzY'})
    if is_first and not User.movie_pages:
        User.movie_pages = get_item_count(resp)

    book_list = resp.html.find('.subject-item')  # type: TypeAnno.Elements
    for book in book_list:
        bookinfo = parse_book(book)  # type: ItemInfo
        await do_insert(bookinfo)


def main():
    URLs = []
    loop = asyncio.get_event_loop(
    )  # type: asyncio.unix_events._UnixSelectorEventLoop
    loop.run_until_complete(get_books(Base_URL+'0', True))

    for x in range(1, User.book_pages):
        cur_page_URL = Base_URL + str(x * PAGE_INTERVAL)
        URLs.append(cur_page_URL)

    loop = asyncio.get_event_loop()
    wait_all = asyncio.wait([get_books(URL) for URL in URLs])
    loop.run_until_complete(wait_all)


if __name__ == '__main__':
    init_db('Book')
    main()
