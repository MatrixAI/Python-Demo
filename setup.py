#!/usr/bin/env python3

from setuptools import setup, find_packages

with open('README.md', 'r') as f:
    long_description = f.read()

setup(
    name='awesome-package',
    version='0.0.1',
    author='Your Name',
    author_email='your@email.com',
    description='Does something awesome',
    long_description=long_description,
    url='https://awesome-package.git',
    packages=find_packages(),
    install_requires=['numpy'])
