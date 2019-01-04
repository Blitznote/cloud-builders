FROM blitznote/golang:latest as gotools

FROM gcr.io/distroless/static
COPY --from=gotools /usr/local/bin/ineffassign /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/ineffassign"]
