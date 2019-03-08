import pytest
from pathlib import Path


@pytest.fixture(scope='session')
def project_root(pytestconfig):
    return Path(pytestconfig.rootdir)
