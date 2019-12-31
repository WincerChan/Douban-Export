import asyncio
from datetime import datetime

from requests_html import AsyncHTMLSession, HTMLSession

from config import PAGE_INTERVAL, ItemInfo, TypeAnno, User
from parses import (get_comment, get_date, get_item_count, get_movie_title,
                    get_rating, get_tags)
from mongo import do_insert
from pg import connect_pg

asyncss = AsyncHTMLSession()


def parse_movie(item: TypeAnno.Element) -> ItemInfo:
    """
    Parse one movie info.
    """
    cover = item.xpath('//img/@src', first=True)  # type: str

    date = get_date(item)  # type: datetime

    rating = get_rating(item)  # type: int

    title = get_movie_title(item)  # type: str

    comment = get_comment(item)  # type: str

    tags = get_tags(item)  # type: list

    url = item.xpath('//a/@href', first=True)  # type: str

    return ItemInfo(title, cover, date, rating, comment, tags, url)


async def get_movie_pages(page: int):
    """
    Get pages of items.
    """
    url = f'https://movie.douban.com/people/{User.id_}/collect?start={PAGE_INTERVAL*page}'
    resp = await asyncss.get(url)
    User.movie_pages = get_item_count(resp)


async def get_movies(url: str):
    """
    Get all movies in one page.
    """
    print(url)
    resp = await asyncss.get(url)  # type: TypeAnno.HTMLResponse
    movie_list = resp.html.find('.item')  # type: TypeAnno.Elements
    for movie in movie_list:
        movieinfo = parse_movie(movie)  # type: ItemInfo
        await do_insert('movie', movieinfo)


async def main():
    globals()['asyncss'] = AsyncHTMLSession(loop=asyncio.get_running_loop())
    await asyncio.gather(connect_pg(), get_movie_pages(0))
    await asyncio.gather(
        *[get_movies(f'https://movie.douban.com/people/{User.id_}/collect?start={PAGE_INTERVAL*x}') for x in range(User.movie_pages)]
    )


if __name__ == "__main__":
    asyncio.run(main())
