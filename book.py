import asyncio
from datetime import datetime

from requests_html import AsyncHTMLSession

from config import ItemInfo, TypeAnno, PAGE_INTERVAL, User
from mongo import do_insert
from parses import get_date, get_rating, get_comment, get_tags, get_item_count
from mongo import do_insert
from pg import connect_pg

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


async def get_book_pages(page: int):
    url = f'https://book.douban.com/people/{User.id_}/collect?start={PAGE_INTERVAL*page}'
    resp = await ass.get(url, cookies={'bid': 'FMmHbs6EbzY'})
    User.book_pages = get_item_count(resp)


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
        await do_insert('book', bookinfo)


async def main():
    globals()['ass'] = AsyncHTMLSession(loop=asyncio.get_running_loop())
    await asyncio.gather(connect_pg(), get_book_pages(0))
    await asyncio.gather(
        *[get_books(f'https://book.douban.com/people/{User.id_}/collect?start={PAGE_INTERVAL*x}') for x in range(User.book_pages)]
    )


if __name__ == '__main__':
    asyncio.run(main())
