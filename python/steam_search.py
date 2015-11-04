'''Print info of matched game for Steam searches in input (".steam <query>").

Dependencies
============

- `python-requests <http://python-requests.org>`_

Usage:
======

.. code:: console

    python steam_search.py '<input>'

Example:
========

.. code:: console

    python steam_search.py '.steam dota'
'''


from __future__ import division
import signal
import sys

import requests
from requests.exceptions import RequestException


STORE_URL = 'http://store.steampowered.com/app/{}/'
STOREFRONT_API_URL = 'http://store.steampowered.com/api/storesearch/?term={}&l=english&cc=US'

signal.signal(signal.SIGINT, signal.SIG_DFL)

def get_results(text):
    if not text.startswith('.steam'):
        return None
    query = text[7:].strip()

    try:
        response = requests.get(STOREFRONT_API_URL.format(query))
    except RequestException:
        return None
    if not response:
        return None
    results = response.json()
    if not results['items']:
        return 'No results found for "{}".'.format(query)
    game = results['items'][0]
    name = game['name']
    if not 'price' in game:
        price = 'Free!'
    else:
        price = '${}'.format(game['price']['final'] / 100)
        discount = int((game['price']['initial'] - game['price']['final']) /
                       game['price']['initial'] * 100)
        if discount:
            price = '{} [-{}%]'.format(price, discount)
    platforms = []
    for platform, supported in game['platforms'].items():
        if supported:
            platforms.append(platform.capitalize())
    platforms = ', '.join(platforms)
    url = STORE_URL.format(game['id'])
    output = '{} -- {} ({}) <{}>'.format(name, price, platforms, url)

    return output


if __name__ == '__main__':
    if len(sys.argv) != 2:
        print(__doc__)
        sys.exit(1)
    result = get_results(sys.argv[1])
    if result:
        print(result)
