#!/usr/bin/env python3
import argparse
import json
import signal
import sys
import urllib.parse
import urllib.request


def _get_events(subdomain, token, query, start, end, order):
    url = 'https://{}.loggly.com/apiv2/events/iterate?{}'.format(
        subdomain,
        urllib.parse.urlencode({
            'q': query,
            'from': start,
            'until': end,
            'order': order,
            'size': 1000,  # API max
        }))

    while url:
        req = urllib.request.Request(
            url,
            headers={'Authorization': f'bearer {token}'})
        body = json.load(urllib.request.urlopen(req))
        url = body.get('next')
        yield from body.get('events', [])


def _signal_handler(*_):
    sys.exit(1)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--token', required=True)
    parser.add_argument('--subdomain', required=True)

    parser.add_argument('--from', default='-24h', dest='start')
    parser.add_argument('--to', default='now', dest='end')
    parser.add_argument('--order', choices=('asc', 'desc'), default='asc')
    parser.add_argument('-n', type=int, dest='limit')
    parser.add_argument('query')

    signal.signal(signal.SIGINT, _signal_handler)
    signal.signal(signal.SIGTERM, _signal_handler)

    args = parser.parse_args()

    event_iter = _get_events(
        args.subdomain, args.token, args.query, args.start, args.end,
        args.order)

    events = []
    for event in event_iter:
        events.append(event)
        if args.limit and len(events) >= args.limit:
            break
    print(json.dumps(events, indent=2, sort_keys=True))


if __name__ == '__main__':
    main()
