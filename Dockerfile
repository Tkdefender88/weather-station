FROM ghcr.io/gleam-lang/gleam:v1.3.2-erlang-alpine

WORKDIR /build

COPY ./client /build/client
COPY ./server /build/server
COPY ./shared /build/shared

RUN mkdir -p /build/server/priv

RUN cd /build/client \
    && gleam clean \
    && gleam deps download \
    && gleam run -m lustre/dev build --outdir=/build/server/priv


RUN cd /build/server \
    && gleam export erlang-shipment \
    && mv build/erlang-shipment /app \
    && rm -r /build

WORKDIR /app
ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["run"]

