FROM registry.semaphoreci.com/golang:1.18 as builder

ENV APP_HOME /go/src/go-docker

WORKDIR "$APP_HOME"
COPY src/ .

RUN go mod download
RUN go mod verify
RUN go build -o go-docker

FROM registry.semaphoreci.com/golang:1.18

ENV APP_HOME /go/src/go-docker
RUN mkdir -p "$APP_HOME"
WORKDIR "$APP_HOME"

COPY src/conf/ conf/
COPY src/views/ views/
COPY --from=builder "$APP_HOME"/go-docker $APP_HOME

EXPOSE 8010
CMD ["./go-docker"]
