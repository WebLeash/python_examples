#!/bin/bash
echo "Running a Grid"
echo "Setting up a Selenium Grid only requires a few different steps."

echo "To start a small grid with 1 Chrome and 1 Firefox node you can run the following commands:"

echo "$ docker run -d -p 4444:4444 --name selenium-hub selenium/hub:3.4.0"
#nohup docker run -d -p 4444:4444 --name selenium-hub selenium/hub:3.4.0 &
sudo docker run -d -p 4444:4444 --name selenium-hub selenium/hub:3.4.0 

echo "nohup docker run -d --link selenium-hub:hub selenium/node-chrome:3.4.0"
nohup docker run -d --link selenium-hub:hub selenium/node-chrome:3.4.0 &
sudo docker run -d --link selenium-hub:hub selenium/node-chrome:3.4.0 

echo "docker run -d --link selenium-hub:hub selenium/node-firefox:3.4.0"
#nohup docker run -d --link selenium-hub:hub selenium/node-firefox:3.4.0 &
sudo docker run -d --link selenium-hub:hub selenium/node-firefox:3.4.0 
