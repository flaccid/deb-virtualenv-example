import setuptools

with open("README.md", "r") as fh:
    long_description = fh.read()

setuptools.setup(
    name="helloart",
    version="0.0.1",
    author="Chris Fordham",
    author_email="chris@fordham.id.au",
    description="hello world with the art package",
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="https://github.com/flaccid/deb-virtualenv-example",
    packages=setuptools.find_packages(),
    classifiers=[
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
    ],
    entry_points={
        "gui_scripts": [
            "helloart = helloart.serve:main",
        ]
    },
    python_requires='>=3.5',
)
