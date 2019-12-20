import python_demo
import numpy as np


def test_demo(project_root):
    assert 1 == 1


def test_numpy():
    assert np.alltrue(python_demo.numpy_demo.give_matrix() == np.array([1, 2, 3, 4]))
