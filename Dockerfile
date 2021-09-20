FROM alpine:latest as alpine

RUN apk add -U --no-cache ca-certificates
RUN addgroup -S mappedgroup && adduser -S mappeduser -G mappedgroup

# CLI for k8s startup probe (to understand when container is ready to work)
RUN GRPC_HEALTH_PROBE_VERSION=v0.4.4 && \
    wget -qO/bin/grpc_health_probe https://github.com/grpc-ecosystem/grpc-health-probe/releases/download/${GRPC_HEALTH_PROBE_VERSION}/grpc_health_probe-linux-amd64 && \
    chmod +x /bin/grpc_health_probe

FROM scratch
ENTRYPOINT []
WORKDIR /
COPY --from=alpine /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=alpine /etc/passwd /etc/passwd
COPY --from=alpine /bin/grpc_health_probe /bin/grpc_health_probe

COPY ./wait-for-port/wait-for-port ./app/wait-for-port
