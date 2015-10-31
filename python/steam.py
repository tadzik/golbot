'''Print game info for any Steam URLs in input.

Dependencies
============

- `python-requests <http://python-requests.org>`_

Usage:
======

.. code:: console

    python steam.py '<input>'
'''


import re
import sys

import requests
from requests.exceptions import RequestException

import signal
signal.signal(signal.SIGINT, signal.SIG_DFL)

STOREFRONT_API_URL = 'http://store.steampowered.com/api/appdetails/?appids={}&filters=basic,platforms,price_overview&cc=US&l=english'
PATTERN = re.compile(r'store\.steampowered\.com/app/(\d*)')


def get_info(text):
    appids = re.findall(PATTERN, text)
    if not appids:
        return None

    output = []
    for appid in appids:
        try:
            response = requests.get(STOREFRONT_API_URL.format(appid))
        except (RequestException):
            continue
        if not response:
            return None
        results = response.json()
        if not results[appid]['success']:
            continue
        game = results[appid]['data']
        name = game['name']
        if game['is_free']:
            price = 'Free!'
        else:
            price = '${}'.format(game['price_overview']['final'] / 100)
            discount = game['price_overview']['discount_percent']
            if discount:
                price = '{} [-{}%]'.format(price, discount)
        platforms = []
        for platform, supported in game['platforms'].items():
            if supported:
                platforms.append(platform.capitalize())
        platforms = ', '.join(platforms)
        output.append('{} -- {} ({})'.format(name, price, platforms))

    return output


if __name__ == '__main__':
    if len(sys.argv) != 2:
        print(__doc__)
        sys.exit(1)
    output = get_info(sys.argv[1])
    if output:
        for line in output:
            print(line)
