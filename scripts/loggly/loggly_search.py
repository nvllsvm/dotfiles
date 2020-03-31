#!/usr/bin/env python3
import argparse
import json
import urllib.parse
import urllib.request


def _get_events(subdomain, token, query, start, end, order):
    url = 'https://{}.loggly.com/apiv2/events/iterate?{}'.format(
        subdomain,
        urllib.parse.urlencode({
            'q': query,
            'from': start,
            'until': end,
            'order': order}))

    while url:
        req = urllib.request.Request(
            url,
            headers={'Authorization': f'bearer {token}'})
        body = json.load(urllib.request.urlopen(req))
        url = body.get('next')
        yield from body.get('events', [])


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--token', required=True)
    parser.add_argument('--subdomain', required=True)

    parser.add_argument(
        '--from', help='%(default)s',
        default='-24h', dest='start')
    parser.add_argument(
        '--to', help='%(default)s', default='now', dest='end')
    parser.add_argument(
        '--order', help='%(default)s', choices=('asc', 'desc'), default='asc')
    parser.add_argument('-n', type=int, dest='limit')
    parser.add_argument('query')

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
