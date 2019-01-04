FROM blitznote/golang:latest as gotools

FROM gcr.io/distroless/static
COPY --from=gotools /opt/go/bin/gofmt /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/gofmt"]
CMD ["-l"]
