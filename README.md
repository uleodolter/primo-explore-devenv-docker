# Primo New UI Customization Docker Development Environment

Run the https://github.com/uleodolter/primo-explore-devenv

## Downloading:

ensure the latest versions of `docker` and `docker-compose` are installed.

download the project with:
```sh
git clone https://github.com/uleodolter/primo-explore-devenv-docker.git
```

`docker-compose.example.yml` contains an example configuration for the development environment. you will need to rename it `docker-compose.yml` and make some changes (detailed below) to start working.

## Usage:

### Setup

you need a view code package to use the development environment. you can provide your own by downloading it from the "back office", or acquire a fresh one from [here](https://github.com/ExLibrisGroup/primo-explore-package).

to add a view to the development environment, ensure that the line:
```yml
volumes:
  - ./:/app/primo-explore-devenv/custom/NAME_OF_VIEW
```
appears in your `docker-compose.yml`, where the path on the left is the absolute path to your view code folder.

- to select a view, edit the `VIEW` property in `docker-compose.yml` to match the name you provided in the `volumes` stanza, e.g. `NAME_OF_VIEW`.
- to select a proxy server to view live primo results, edit the `PROXY` property in `docker-compose.yml`.

you can create an `.env` which is read by docker-compose, please adjust:

```
VIEW=NAME_OF_VIEW
PROXY=https://primo.domain.name:443
GULP_BROWSERIFY=--browserify
GULP_USESCSS=--useScss
```


to start developing, open a terminal in this directory and run:
```sh
docker-compose up
```

- logs will be displayed in your terminal.
- you can edit the files in your package's folder and changes will be made in real-time.
- you can observe the view using a browser at `localhost:8003/primo-explore/search?vid=NAME_OF_VIEW`.

### Changing views

first, ensure that the line:
```yml
volumes:
  - ./:/app/primo-explore-devenv/custom/NAME_OF_OTHER_VIEW
```
appears in your `docker-compose.yml`, providing access to the new view.

to change the currently displayed view, edit the `VIEW` property in `.env`, open a terminal in the project directory, and run:
```sh
docker-compose restart
```

- making changes to `VIEW` or `PROXY` will require the above restart command to take effect.
- you can add as many views as you like to the `volumes` stanza.
- you can add a central package by mounting it in the above manner and naming it `CENTRAL_PACKAGE`.

### Creating packages

first, make sure that the line:
```yml
volumes:
  - ./:/app/primo-explore-devenv/packages # used to access generated package .zip files
```
appears in your `docker-compose.yml` file, so that packages will appear outside the container.

to create a package, open a terminal in this directory and run:
```sh
docker-compose run devenv gulp create-package
```
select a package when prompted. the zip file will appear in this folder.

## References

Based on https://github.com/thatbudakguy/primo-explore-devenv-docker by Nick Budak.
