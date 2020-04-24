# Phaser 3 Docker TypeScript Project Template

This quick-start project template combines Nodejs in a docker machine, Phaser 3 with [TypeScript](https://www.typescriptlang.org/) and uses [Rollup](https://rollupjs.org) for bundling.
It runs npm run watch in docker machine, so no local nodejs is required.

The Debug Project can be viewed on Host Port 8080.<br>

## Requirements

[docker](https://www.docker.com/products/docker-desktop) is required to run docker images.

## Available Commands

| Command | Description |
|---------|-------------|
| `make docker-pre-build` | build Docker Container and install project requirements i.e. node modules |
| `make docker-build` | Build project and open web server running project, watching for changes |
| `make docker-dev` | Start Machine, build project and open web server but do not watch for changes |
| `make docker-dist` | Builds code bundle with production settings (minification, no source maps, etc..) |

## Writing Code

After running `make docker-pre-build` the Container is ready for serving files.
Then, you can start the local development server by running one of the other make commands.
`make docker-build` starts server. The first time you run this you should see the demo running.

After starting the development server with `make docker-build`, you can edit any files in the `src` folder
and Rollup will automatically recompile and reload your server (available at `http://localhost:8080`
by default).

## Changing the Server Port

* Edit `.docker/docker-compose.yml` and modify Port 8080 to your preferred Port. 
Inside the Docker Container uses local Port 10001. You don't need to change that.

## Configuring Rollup

* Edit the file `rollup.config.dev.js` to edit the development build.
* Edit the file `rollup.config.dist.js` to edit the distribution build.

You will find lots of comments inside the rollup config files to help you do this.

Note that due to the build process involved, it can take around 20 seconds to build the initial bundle. Times will vary based on CPU and local drive speeds. The development config does not minify the code in order to save build time, but it does generate source maps. If you do not require these, disable them in the config to speed it up further.

