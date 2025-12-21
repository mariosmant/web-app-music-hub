# Find docker containers' IP Address
```bash
docker ps -q | xargs docker inspect -f '{{.Name}} - {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'
```
