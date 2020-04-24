#!/bin/bash
# clone phaser typescript template into app folder, this should be done on host
#git clone https://github.com/minigraphx/docker-phaser3-typescript-project-template.git .
# run package.json - not working atm, however it is when running on bash interactive
npm install
# fix vulnerabilities, do updates
npm audit fix
