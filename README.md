# APT Cache Proxy Container

A docker container for an apt cache proxy.

## Usage

Create the necessary volumes with `make createvols`,
then run `make start` to start the container.

Install the apt configuration file with `make PROXYADDR=example.com installconfig`,
but be aware that this needs rood privileges.
