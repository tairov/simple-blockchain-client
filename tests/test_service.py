from json import JSONDecodeError

from service import app, config
import dataprovider
import mock
from unittest.mock import patch

MOCK_SUCCESS_RESPONSE = {"result": "xyz"}
MOCK_BLOCK_ID = "0x2982c90"


def test_health_success():
    with app.test_client() as test_client:
        response = test_client.get(f'/health')
        assert response.status_code == 200


def test_metrics_success():
    with app.test_client() as test_client:
        response = test_client.get(f'/metrics')
        assert b'requests_total' in response.data
        assert response.status_code == 200


@patch.object(dataprovider.requests.Session, 'post')
def test_get_block_success(mock_post):
    mock_post.return_value.json = mock.Mock(return_value=MOCK_SUCCESS_RESPONSE)
    with app.test_client() as test_client:
        response = test_client.get('/block/')
        mock_post.assert_called()
        assert response.json['number'] == MOCK_SUCCESS_RESPONSE['result']
        assert response.status_code == 200


@patch.object(dataprovider.requests.Session, 'post')
def test_get_block_by_number_success(mock_post):
    mock_post.return_value.json = mock.Mock(return_value=MOCK_SUCCESS_RESPONSE)
    with app.test_client() as test_client:
        response = test_client.get('/block_by_number/' + MOCK_BLOCK_ID)
        mock_post.assert_called()
        assert response.status_code == 200
