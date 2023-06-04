"""
Class for providing data for webservice
"""
from json import JSONDecodeError
import json

import requests
from retry import retry

DELAY = 3
RETRIES = 3


class DataProvider:
    def __init__(self, config):
        self.session = requests.Session()
        self.base_url = config['base_url']
        self.user_agent = config['user_agent']

    def get_block_number(self):
        result = self._get_block_number()
        try:
            result = result.json()
            result = result['result']
        except (ValueError, JSONDecodeError) as ex:
            return {'error': 'value_error', 'error_msg': 'json decode error'}
        return result

    def get_block_by_number(self, block_number):
        result = self._get_block_by_number(block_number)
        try:
            result = result.json()
        except (ValueError, JSONDecodeError) as ex:
            return {'error': 'value_error', 'error_msg': 'json decode error'}
        return result

    # retry request in case of it returned error
    @retry((requests.ConnectionError, requests.HTTPError), delay=DELAY, tries=RETRIES)
    def _get_block_number(self):
        payload = json.dumps({
            "jsonrpc": "2.0",
            "method": "eth_blockNumber",
            "id": "2"
        })
        headers = {
            'content-type': 'application/json',
            'user-agent': self.user_agent
        }
        return self.session.post(self.base_url, headers=headers, data=payload)

    # retry request in case of it returned error
    @retry((requests.ConnectionError, requests.HTTPError), delay=DELAY, tries=RETRIES)
    def _get_block_by_number(self, block_number):
        payload = json.dumps({
            "jsonrpc": "2.0",
            "method": "eth_getBlockByNumber",
            "params": [
                block_number,
                True
            ],
            "id": 2
        })
        headers = {
            'content-type': 'application/json',
            'user-agent': self.user_agent
        }
        return self.session.post(self.base_url, headers=headers, data=payload)
