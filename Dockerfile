FROM golang:1.19 as base

WORKDIR /app
COPY go.mod go.sum ./

ARG AZDO_ACCESS_TOKEN
RUN git config --global url."https://pat:${AZDO_ACCESS_TOKEN}@dev.azure.com".insteadOf "https://dev.azure.com"

RUN go mod download

COPY . .

RUN go build -o ./out/can ./cmd/

FROM alpine:3 as runtime

COPY --from=base ./app/out/ /app/

ENTRYPOINT [ "/app/can" ]
