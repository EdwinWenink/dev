# Dev Container

## Usage

Manually:

`docker build -t devcontainer .`
`docker run -it devcontainer:latest`

Using Docker compose:

`docker compose build`
`docker compose run devcontainer`

Or, with automatic clean up:

`docker compose run --rm devcontainer`

Clean up:

`docker-compose down`

## TODO

- Volume vs mount bind
- Publish image?
