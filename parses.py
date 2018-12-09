
from datetime import datetime

from config import TypeAnno

from math import ceil


def get_date(item: TypeAnno.Element) -> datetime:
    date_info = item.find(".date", first=True).text  # type: str
    date_str = date_info.split(' ')[0]
    return datetime.strptime(date_str, "%Y-%m-%d")


def get_rating(item: TypeAnno.Element) -> int:
    has_rating = item.xpath(
        '//span[contains(@class, "rating")]/@class',
        first=True
    )  # type: str

    return int(
        has_rating[6]
    ) if has_rating else None


def get_movie_title(item: TypeAnno.Element) -> str:
    title_element = item.find('.title > a', first=True)
    return title_element.text.split(' /')[0]


def get_comment(item: TypeAnno.Element) -> list:
    return item.xpath(
        '//*[@class="comment"]/text()',
        first=True
    )


def get_tags(item: TypeAnno.Element) -> list:
    has_tag = item.find('.tags', first=True)
    return has_tag.text.split(' ')[1:]\
        if has_tag else []


def get_item_count(content: TypeAnno.Elements) -> int:
    count_element = content.html.find(
        '.subject-num', first=True)  # type: TypeAnno.Element
    count = int(count_element.text.split("/")[1])
    pages = count / 15
    return ceil(pages)
