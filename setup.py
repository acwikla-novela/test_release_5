version = '0.1.037'
print(version)

from setuptools import setup, find_packages

setup(
    name='test_release_5',
    version=version,
    author='Aleksander Cwikla',
    url="https://github.com/acwikla-novela/test_release_5",
    packages=['dir_to_include'],
    description='TestingHowToAutomateRelease',
    platforms='Posix; MacOS X; Windows',
    python_requires='==3.7.4',
    data_files=['LICENSE', 'meta.yaml']
)
