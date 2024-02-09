# Dev Container

## Usage

### Regular docker commands

Manually:

`docker build -t devcontainer .`
`docker run -it devcontainer:latest`

When developing it's handy to bind mount the current project directory:

`docker run -it --rm --env-file .env -v .:/root/dev/ devcontainer:latest`

The advantage of this approach is that once you have built the image, you can use it in whatever directory.

### Docker compose

Using Docker compose (without bind mount):

`docker compose build`
`docker compose run --rm devcontainer`

WARNING: because bind mounts are specific to a particular file system this setup does not define it.
Instead, it used a simple volume managed by Docker.

You need to run this from within this repository.


## TODO

- Volume vs mount bind
- Publish image?
