#!/usr/bin/env python
import argparse
import getpass
import json
import urllib.parse

import httpx


def _pretty_json(data):
    return json.dumps(data, indent=2, sort_keys=True)


class RabbitMQ:

    def __init__(self, url, vhost, username, password):
        self._url = url
        self._vhost = urllib.parse.quote(vhost, safe='')
        self._client = httpx.Client()
        self._client.auth = (username, password)

    def create_exchange(self, exchange, exchange_type, durable=False):
        payload = {'type': exchange_type}
        if durable:
            payload['durable'] = durable
        exchange = self._quote(exchange)
        url = f'{self._url}/api/exchanges/{self._vhost}/{exchange}'
        response = self._client.put(url, json=payload)
        assert response.status_code in (201, 204)

    def create_queue(self, queue, message_ttl=None, dead_letter_exchange=None,
                     durable=False):
        payload = {'arguments': {}}
        if message_ttl:
            payload['arguments']['x-message-ttl'] = message_ttl
        if dead_letter_exchange:
            payload['arguments']['dead-letter-exchange'] = dead_letter_exchange
        if durable:
            payload['durable'] = durable

        queue = self._quote(queue)
        url = f'{self._url}/api/queues/{self._vhost}/{queue}'
        response = self._client.put(url, json=payload)
        assert response.status_code in (201, 204)

    def delete_queue(self, queue):
        queue = self._quote(queue)
        url = f'{self._url}/api/queues/{self._vhost}/{queue}'
        response = self._client.delete(url)
        assert response.status_code in (201, 204, 404)

    def delete_exchange(self, exchange):
        exchange = self._quote(exchange)
        url = f'{self._url}/api/exchanges/{self._vhost}/{exchange}'
        response = self._client.delete(url)
        assert response.status_code in (201, 204, 404)

    def exchange_binding_source(self, exchange):
        exchange = self._quote(exchange)
        url = f'{self._url}/api/exchanges/{self._vhost}/{exchange}/bindings/source'
        response = self._client.get(url)
        assert response.status_code == 200
        return response.json()

    def exchange_binding_destination(self, exchange):
        exchange = self._quote(exchange)
        url = f'{self._url}/api/exchanges/{self._vhost}/{exchange}/bindings/destination'
        response = self._client.get(url)
        assert response.status_code == 200
        return response.json()

    def bind(self, exchange, queue, routing):
        exchange = self._quote(exchange)
        queue = self._quote(queue)
        url = f'{self._url}/api/bindings/{self._vhost}/e/{exchange}/q/{queue}'
        response = self._client.post(
            url,
            json={
                'routing_key': routing
            })
        assert response.status_code in (201, 204)

    def list_exchanges(self):
        response = self._client.get(f'{self._url}/api/exchanges/{self._vhost}')
        assert response.status_code == 200
        return response.json()

    def list_queues(self):
        response = self._client.get(f'{self._url}/api/queues/{self._vhost}')
        assert response.status_code == 200
        return response.json()

    def describe_queue(self, queue):
        response = self._client.get(f'{self._url}/api/queues/{self._vhost}/{queue}')
        assert response.status_code == 200
        return response.json()

    def describe_exchange(self, exchange):
        response = self._client.get(f'{self._url}/api/exchanges/{self._vhost}/{exchange}')
        assert response.status_code == 200
        return response.json()

    def create_user(self, username, password, tags):
        response = self._client.put(
            f'{self._url}/api/users/{username}',
            json={'password': password, 'tags': tags})
        assert response.status_code == 201

    def permit_user(self, username, configure, read, write):
        response = self._client.put(
            f'{self._url}/api/permissions/{self._vhost}/{username}',
            json={'configure': configure, 'read': read, 'write': write})
        assert response.status_code == 201

    def delete_user(self, username):
        response = self._client.delete(f'{self._url}/api/users/{username}')
        assert response.status_code in (204, 404)

    @staticmethod
    def _quote(value):
        return urllib.parse.quote(value, safe='')


class _Parser:

    @staticmethod
    def _setup_rabbitmq(args):
        password = args.password
        if password is None:
            password = getpass.getpass()
        return RabbitMQ(args.url, args.vhost, args.user, password)

    @staticmethod
    def create_exchange(args):
        rabbitmq = _Parser._setup_rabbitmq(args)
        rabbitmq.create_exchange(
            exchange=args.exchange,
            exchange_type=args.type,
            durable=args.durable)

    @staticmethod
    def create_queue(args):
        rabbitmq = _Parser._setup_rabbitmq(args)
        rabbitmq.create_queue(
            queue=args.queue,
            message_ttl=args.message_ttl,
            dead_letter_exchange=args.dlx,
            durable=args.durable)

    @staticmethod
    def create_user(args):
        rabbitmq = _Parser._setup_rabbitmq(args)
        rabbitmq.create_user(
            username=args.usern,
            password=args.passw,
            tags=args.tags)

    @staticmethod
    def permit_user(args):
        rabbitmq = _Parser._setup_rabbitmq(args)
        rabbitmq.permit_user(
            username=args.usern,
            configure=args.configure,
            read=args.read,
            write=args.write)

    @staticmethod
    def delete_user(args):
        rabbitmq = _Parser._setup_rabbitmq(args)
        rabbitmq.delete_user(username=args.usern)

    @staticmethod
    def delete_queue(args):
        rabbitmq = _Parser._setup_rabbitmq(args)
        rabbitmq.delete_queue(queue=args.queue)

    @staticmethod
    def delete_exchange(args):
        rabbitmq = _Parser._setup_rabbitmq(args)
        rabbitmq.delete_exchange(exchange=args.exchange)

    @staticmethod
    def describe_exchange(args):
        rabbitmq = _Parser._setup_rabbitmq(args)
        source = rabbitmq.describe_exchange(exchange=args.exchange)
        print(_pretty_json(source))

    @staticmethod
    def describe_queue(args):
        rabbitmq = _Parser._setup_rabbitmq(args)
        source = rabbitmq.describe_queue()
        print(_pretty_json(source))

    @staticmethod
    def bind(args):
        rabbitmq = _Parser._setup_rabbitmq(args)
        rabbitmq.bind(
            exchange=args.exchange,
            queue=args.queue,
            routing=args.routing)

    @staticmethod
    def list_exchanges(args):
        rabbitmq = _Parser._setup_rabbitmq(args)
        print(_pretty_json(rabbitmq.list_exchanges()))

    @staticmethod
    def list_queues(args):
        rabbitmq = _Parser._setup_rabbitmq(args)
        print(_pretty_json(rabbitmq.list_queues()))


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--url', required=True)
    parser.add_argument('--user', required=True)
    parser.add_argument('--password')
    parser.add_argument('--vhost', default='/')

    subparsers = parser.add_subparsers(dest='command', metavar='COMMAND',
                                       required=True)
    create_exchange = subparsers.add_parser('create-exchange')
    create_exchange.set_defaults(func=_Parser.create_exchange)
    create_exchange.add_argument('--durable', action='store_true')
    create_exchange.add_argument('--type', choices=['topic'], default='topic')
    create_exchange.add_argument('exchange')

    create_queue = subparsers.add_parser('create-queue')
    create_queue.set_defaults(func=_Parser.create_queue)
    create_queue.add_argument('--durable', action='store_true')
    create_queue.add_argument('--message-ttl', type=int)
    create_queue.add_argument('--dlx')
    create_queue.add_argument('queue')

    create_user = subparsers.add_parser('create-user')
    create_user.set_defaults(func=_Parser.create_user)
    create_user.add_argument('--tags', default='')
    create_user.add_argument('usern')
    create_user.add_argument('passw')

    permit_user = subparsers.add_parser('permit-user')
    permit_user.set_defaults(func=_Parser.permit_user)
    permit_user.add_argument('--configure', default='.*')
    permit_user.add_argument('--read', default='.*')
    permit_user.add_argument('--write', default='.*')
    permit_user.add_argument('usern')

    delete_user = subparsers.add_parser('delete-user')
    delete_user.set_defaults(func=_Parser.delete_user)
    delete_user.add_argument('usern')

    delete_exchange = subparsers.add_parser('delete-exchange')
    delete_exchange.set_defaults(func=_Parser.delete_exchange)
    delete_exchange.add_argument('exchange')

    delete_queue = subparsers.add_parser('delete-queue')
    delete_queue.set_defaults(func=_Parser.delete_queue)
    delete_queue.add_argument('queue')

    describe_exchange = subparsers.add_parser('describe-exchange')
    describe_exchange.set_defaults(func=_Parser.describe_exchange)
    describe_exchange.add_argument('exchange')

    describe_queue = subparsers.add_parser('describe-queue')
    describe_queue.set_defaults(func=_Parser.describe_queue)
    describe_queue.add_argument('queue')

    list_exchanges = subparsers.add_parser('list-exchanges')
    list_exchanges.set_defaults(func=_Parser.list_exchanges)

    list_queues = subparsers.add_parser('list-queues')
    list_queues.set_defaults(func=_Parser.list_queues)

    bind = subparsers.add_parser('bind')
    bind.set_defaults(func=_Parser.bind)
    bind.add_argument('--exchange', required=True)
    bind.add_argument('--queue', required=True)
    bind.add_argument('--routing', default='#')

    args = parser.parse_args()
    args.func(args)


if __name__ == '__main__':
    main()
