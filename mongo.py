from hashlib import md5

from config import ItemInfo, database
from utils import flush_write
from pg import insert, connect_pg
from tortoise import exceptions


async def add_id(type_: str, item: ItemInfo):
    """
    Hash title of ItemInfo as id.
    """
    result = item._asdict()
    await insert(type_, **result)
    # title = item.title.encode('utf-8')
    # result['_id'] = md5(title).hexdigest()


async def do_insert(type_: str, item: ItemInfo) -> None:
    """
    Insert doc to mongoDB asynchronously.
    """
    try:
        await add_id(type_, item)
    except exceptions.IntegrityError:
        print("{} 该信息已插入...".format(item.title))
    else:
        await flush_write(item.title)
        # print(result.inserted_id)
