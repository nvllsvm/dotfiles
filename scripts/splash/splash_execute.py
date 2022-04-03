#!/usr/bin/env python3
import argparse
import asyncio
import json

import httpx


class Splash:
    def __init__(self, url):
        self.url = url
        self.client = httpx.AsyncClient()

    async def execute(self, url, wait=0.5):
        lua = """
        function main(splash, args)
          assert(splash:go(args.url))
          assert(splash:wait(args.wait))
          return {
            har = splash:har(),
            --png = splash:png(),
          }
        end
        """
        body = {
            'console': 1,
            'lua_source': lua,
            'script': 1,
            'url': url,
            'wait': wait,
        }
        response = await self.client.post(f'{self.url}/execute', json=body)
        return response.json()


def pretty_json(data):
    return json.dumps(data, indent=2, sort_keys=True, ensure_ascii=False)


async def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--splash', metavar='URL', required=True)
    parser.add_argument('url')
    args = parser.parse_args()

    splash = Splash(url=args.splash)
    print(pretty_json(await splash.execute(args.url)))


if __name__ == '__main__':
    asyncio.run(main())
