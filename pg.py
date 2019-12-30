from tortoise import Tortoise, fields, run_async
from tortoise.models import Model
from tortoise.backends.asyncpg.client import AsyncpgDBClient
import models
from hashlib import md5


async def connect_pg():
    await Tortoise.init(
        db_url='postgres://localhost:5432/douban?user=postgres',
        modules={'models': ['models']}
    )
    # await Tortoise.generate_schemas()


async def insert(type_, **kwargs):
    title = f'{kwargs.get("title")}-{kwargs.get("date")}'
    kwargs['date'] = str(kwargs['date'])
    id_ = md5(title.encode('utf-8')).hexdigest()
    await models.Item.create(id=id_, category=type_, info=kwargs)


async def fetch_item():
    for i in await models.Item.all():
        print(i)


async def test():
    await connect_pg()
    await fetch_item()

run_async(test())
