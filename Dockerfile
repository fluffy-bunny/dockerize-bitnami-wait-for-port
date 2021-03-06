FROM golang:alpine as alpine

RUN apk add -U --no-cache ca-certificates \ 
    git

RUN git clone https://github.com/bitnami/wait-for-port.git

WORKDIR /go/wait-for-port
RUN go mod tidy
RUN go build .

RUN addgroup -S mappedgroup && adduser -S mappeduser -G mappedgroup

# CLI for k8s startup probe (to understand when container is ready to work)
RUN GRPC_HEALTH_PROBE_VERSION=v0.4.4 && \
    wget -qO/bin/grpc_health_probe https://github.com/grpc-ecosystem/grpc-health-probe/releases/download/${GRPC_HEALTH_PROBE_VERSION}/grpc_health_probe-linux-amd64 && \
    chmod +x /bin/grpc_health_probe

FROM alpine:latest

WORKDIR /
COPY --from=alpine /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=alpine /etc/passwd /etc/passwd
COPY --from=alpine /bin/grpc_health_probe /bin/grpc_health_probe
COPY --from=alpine /go/wait-for-port/wait-for-port /app/wait-for-port