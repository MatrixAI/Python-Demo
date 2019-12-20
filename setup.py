#!/usr/bin/env python3

import sys
from pathlib import Path
from setuptools import setup, find_packages

root_dir = Path(__file__).parent.resolve()
root_uri = root_dir.as_uri()

with open(root_dir / "README.md", "r", encoding="utf-8") as f:
    long_description = f.read()

needs_pytest = {"pytest", "test", "ptr"}.intersection(sys.argv)
pytest_runner = ["pytest-runner"] if needs_pytest else []

setup(
    name="python-demo",
    version="0.0.1",
    author="Roger Qiu",
    author_email="roger.qiu@matrix.ai",
    description="Demonstrates using Python with Nix",
    long_description=long_description,
    url="https://github.com/MatrixAI/Python-Demo.git",
    packages=find_packages(),
    scripts=["bin/python-demo", "bin/python-demo-external"],
    setup_requires=pytest_runner,
    install_requires=["numpy"],
)
