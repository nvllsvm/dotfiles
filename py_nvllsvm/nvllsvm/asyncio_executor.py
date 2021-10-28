import asyncio
import os


class AsyncExecutor:
    def __init__(self, max_pending=None):
        self.max_pending = \
            os.cpu_count() if max_pending is None else max_pending
        self._queued = []
        self._pending = set()

    def submit(self, func, *args, **kwargs):
        self._queued.append((func, args, kwargs))
        try:
            asyncio.get_running_loop()
        except RuntimeError:
            pass
        else:
            self._fill()

    async def as_completed(self):
        while self._queued or self._pending:
            self._fill()

            done, self._pending = await asyncio.wait(
                self._pending, return_when=asyncio.FIRST_COMPLETED)

            for result in done:
                yield result

    def _fill(self):
        for _ in range(self.max_pending - len(self._pending)):
            if not self._queued:
                return
            func, args, kwargs = self._queued.pop()
            self._pending.add(asyncio.create_task(func(*args, **kwargs)))


async def _run(executor):
    async for result in executor.as_completed():
        try:
            result = result.result()
        except Exception as e:
            print('error', type(e).__name__, e)
