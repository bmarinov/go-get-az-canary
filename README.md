# Go get packages from private repositories

Working with private packages effectively requires repository credentials to be set up on the host. The examples in this repo cover HTTPS and Azure DevOps repositories only.

## CI Builds

Building on a CI server requires some form of secrets management in the build environment. See `./.github/workflows/build.yml` for details and an example using GH Actions.  

### Configure credentials through the Git config

The repository URL has to be rewritten to include an access token. See [insteadOf](https://git-scm.com/docs/git-config#Documentation/git-config.txt-urlltbasegtinsteadOf) for more details.


```sh
docker build --build-arg AZDO_ACCESS_TOKEN="${AZDO_TOKEN_SECRET}" .

# RUN git config --global url."https://pat:${AZDO_ACCESS_TOKEN}@dev.azure.com".insteadOf "https://dev.azure.com"

```

### Using .netrc

The credentials for a given remote host can be configured in a `.netrc` file residing in the home directory.

```sh
docker build -f ./Dockerfile.netrc --build-arg AZDO_ACCESS_TOKEN="${AZDO_TOKEN_SECRET}" .

# RUN echo "machine dev.azure.com login pat password ${AZDO_ACCESS_TOKEN}" > ~/.netrc
```

## Development

Using private packages has a negative impact on the UX and workflow in local development environments.  

### Working with the code

Developers are required to set credentials (using `.gitconfig` or `.netrc`) once per machine. This is a minor inconvenicence and a standard requirement for working with private packages in any tech stack.

### Docker Compose

The impact to a docker-compose workflow is much worse.  

The secret has to be passed as a build argument through an environment variable. There are a few ways of doing that, but none of the solutions feels particularly good.

```sh
SECRET_AZDO_ACCESS_TOKEN=<access_token> docker-compose up --build
```

Alternatively, the token can be set through an environment file. The default convention is to name it `.env` and drop it next to the docker-compose manifest. It is basically guaranteed, that sooner or later the file will be checked in and pushed by mistake. 


## Vendoring

Vendoring the dependencies deals with most of the practical & usability problems around private packages. 
