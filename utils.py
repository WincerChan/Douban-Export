import asyncio
import sys


write, flush = sys.stdout.write, sys.stdout.flush


async def flush_write(insert_id: str) -> None:
    write(insert_id)
    flush()
    await asyncio.sleep(0.1)
    write('\x08' * len(insert_id)*2)
    flush()
