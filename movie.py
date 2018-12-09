import asyncio
from datetime import datetime

from requests_html import AsyncHTMLSession, HTMLSession

from parses import (get_comment, get_date, get_item_count, get_movie_title,
                    get_rating, get_tags)

Base_URL = 'https://movie.douban.com/people/guessme/collect?start='
asyncss = AsyncHTMLSession()


def parse_movie(item):
    """
    Parse one movie info.
    """
    cover = item.xpath('//img/@src', first=True)  # type: str

    date = get_date(item)  # type: datetime

    rating = get_rating(item)  # type: int

    title = get_movie_title(item)  # type: str

    comment = get_comment(item)  # type: str

    tags = get_tags(item)  # type: list

    return ItemInfo(title, cover, date, rating, comment, tags)


async def get_movies(url: str, is_first=False):
    """
    Get all movies in one page.
    """
    resp = await asyncss.get(url)
    if is_first and not User.movie_pages:
        User.movie_pages = get_item_count(resp)

    movie_list = resp.html.find('.item')
    for movie in movie_list:
        movieinfo = parse_movie(movie)
        await do_insert(movieinfo)


def main():
    URLs = []
    loop = asyncio.get_event_loop(
    )  # type: asyncio.unix_events._UnixSelectorEventLoop
    loop.run_until_complete(get_movies(Base_URL+'0', True))

    for x in range(1, User.movie_pages):
        cur_page_URL = Base_URL + str(x * PAGE_INTERVAL)
        URLs.append(cur_page_URL)

    wait_all = asyncio.wait([get_movies(URL) for URL in URLs])
    loop.run_until_complete(wait_all)


if __name__ == '__main__':
    main()
