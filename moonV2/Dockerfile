FROM golang:1.25 AS builder
WORKDIR /src

COPY . .
RUN go mod download && \
    CGO_ENABLED=0 GOOS=linux go build -tags=prod -o /build/moon-v2 main.go

FROM scratch
COPY --from=builder /build/moon-v2 /moon-v2
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=builder /usr/share/zoneinfo /usr/share/zoneinfo

CMD ["/moon-v2"]
