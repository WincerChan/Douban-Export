# -*- coding: utf-8 -*-

import asyncio
import json
from datetime import datetime

import asyncpg

from models import Item
from pg import connect_pg, fetch_item

this_year = f'{datetime.now().year}-01-01'

items = []


async def gen_item(con):
    for item in await con.fetch(f"select category, info from item where info->>'date' > '{this_year}' order by info->>'date' DESC;"):
        info = json.loads(item.get('info'))
        category = item.get('category')
        info['tips'] = "读过" if category == "book" else "看过"
        if category == "book":
            info['cover'] = f"https://img1.doubanio.com/lpic/{info['cover'].split('/')[-1]}"
        items.append(info)


def fmt_output():
    for item in items:
        print(f"{{% figure '{item['cover']}' '{item['title']}' "
              f"'{item['url']}' '{item['date'].split(' ')[0]} {item['tips']}' %}}")


async def main():
    con = await asyncpg.connect(user='postgres', database='douban')
    await gen_item(con)
    fmt_output()

if __name__ == "__main__":
    asyncio.run(main())
