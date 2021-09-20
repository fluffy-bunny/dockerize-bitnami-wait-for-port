# dockerize-bitnami-wait-for-port

[/bitnami/wait-for-port](https://github.com/bitnami/wait-for-port)  

```
docker build . -t dockerize-bitnami-wait-for-port:local && docker run --network docker_mapped-in-a-box -it dockerize-bitnami-wait-for-port:local /app/wait-for-port 8080
```