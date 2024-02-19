# Dev Container

## Build and run

Manually:

`docker build -t devcontainer .`
`docker run -it devcontainer:latest`

When developing it's handy to bind mount the current project directory:

`docker run -it --env-file .env -v .:/root/dev/ devcontainer:latest`

The advantage of this approach is that once you have built the image, you can use it in whatever directory.

Add `--rm` if you want to automatically clean up the container after closing the interactive session.
Otherwise, you can restart the container later with `docker start -i [container_name]`.
If the container was still running, you can instead *attach* to it using `docker attach [container_name]`.

Add a port mapping e.g. `-p 80:8000` to expose the container port `8000` on `localhost:80`.

**TIP**: when running a server within the Docker container, specify host `0.0.0.0` because `localhost`/`127.0.0.1` within Docker refers to the network *within* Docker and is not exposed outward.
See [this](https://stackoverflow.com/questions/75040507/how-to-access-fastapi-backend-from-a-different-machine-ip-on-the-same-local-netw/75041731#75041731) SO post.

Complete command:

`docker run -it --env-file .env -v .:/root/dev/ -p 3000:3000 devcontainer:latest`

**NOTE**: the relative path `.` in the volume mount does not work on all PCs. Why does it work on my desktop but not on my laptop?

### Docker compose

**TODO**: outdated, need to add port forwarding to the compose setup.

Using Docker compose (without bind mount):

`docker compose build`
`docker compose run --rm devcontainer`

WARNING: because bind mounts are specific to a particular file system this setup does not define it.
Instead, it used a simple volume managed by Docker.

You need to run this from within this repository.
