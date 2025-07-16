# setup.py

from setuptools import setup, find_packages

setup(
    name="demo",
    version="1.0.2",
    packages=find_packages(),
    entry_points={
        "console_scripts": [
            "demo = demo.hello:main",
        ]
    },
)
