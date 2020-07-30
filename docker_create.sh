docker build -t fiware-app .
docker stop fiware-app
docker rm fiware-app
docker run -p 3000:3000 --name fiware-app fiware-app
