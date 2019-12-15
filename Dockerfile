FROM alpine:edge

# Install system dependencies
RUN apk add --no-cache \
      crystal \
      shards \
      musl-dev \
      openssl-dev \
      yaml-dev \
      zlib-dev

# Install Lucky CLI
ARG LUCKY_VERSION="0.18.2"
RUN wget -O- https://api.github.com/repos/luckyframework/lucky_cli/tarball/v$LUCKY_VERSION \
      | tar zx && \
    cd luckyframework* && \
    shards install && \
    crystal build src/lucky.cr --release -o /usr/local/bin/lucky && \
    cd - && rm -rf luckyframework*

# Lucky's test to see if port 3001 is available does not work with BusyBox's
# lsof and ps. If you need lsof you'll have to run `busybox lsof`.
RUN rm $(which lsof)

# Skip check for process runner when running script/setup.
ENV CI=yes
