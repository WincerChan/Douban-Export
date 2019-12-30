from tortoise import Tortoise, fields, run_async
from tortoise.models import Model


class Item(Model):
    id = fields.UUIDField(pk=True)
    category = fields.CharField(10)
    info = fields.JSONField()


# class Book(Model):
#     id = fields.UUIDField(pk=True)
#     info = fields.JSONField()
