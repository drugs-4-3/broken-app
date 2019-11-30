############################
# STEP 1 build executable binary
############################
FROM golang:1.13-alpine AS builder

# Set env values
ENV PACKAGE=github.com/drugs-4-3
ENV LISTEN=0.0.0.0:8000

WORKDIR /go/src/${PACKAGE}

# Install git.
# Git is required for fetching the dependencies.
RUN apk update && apk add curl && apk add git && apk add bash && apk add --no-cache git tzdata bash

COPY . .

# build binary
RUN GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o /go/bin/api

############################
# STEP 2 build a small image
############################
FROM alpine:3.9

RUN apk update && apk add curl bash && apk add --no-cache ca-certificates tzdata  && update-ca-certificates

# Import from builder.
COPY --from=builder /usr/share/zoneinfo /usr/share/zoneinfo
# Copy our static executable
COPY --from=builder /go/bin/api /go/bin/api

# Run the api binary.
CMD ["./go/bin/api"]
EXPOSE 8000