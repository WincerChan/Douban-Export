from hashlib import md5

from motor import motor_asyncio
from pymongo.errors import DuplicateKeyError

from config import ItemInfo, database
from utils import flush_write


class DBHelper:
    client = motor_asyncio.AsyncIOMotorClient(database['ip'], database['port'])
    db = client.douban  # type: motor_asyncio.AsyncIOMotorDatabase
    collection = db.Movie  # type: motor_asyncio.AsyncIOMotorCollection

    @classmethod
    def set_collection(cls, coll_name: str):
        cls.collection = cls.db.get_collection(coll_name)


def add_id(item: ItemInfo):
    """
    Hash title of ItemInfo as id.
    """
    result = item._asdict()
    title = item.title.encode('utf-8')
    result['_id'] = md5(title).hexdigest()
    return result


async def do_insert(item: ItemInfo) -> None:
    """
    Insert doc to mongoDB asynchronously.
    """
    doc = add_id(item)
    try:
        result = await DBHelper.collection.insert_one(doc)
    except DuplicateKeyError:
        print(item)
        print("{} 该信息已插入...".format(item.title))
        # exit()
    else:
        await flush_write(result.inserted_id)
        # print(result.inserted_id)


def init_db(name: str):
    from mongo import DBHelper
    DBHelper.set_collection(name)
