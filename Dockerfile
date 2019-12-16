FROM alpine:edge

# Install system dependencies
RUN apk add --no-cache \
      crystal \
      shards \
      musl-dev \
      openssl-dev \
      yaml-dev \
      zlib-dev \
      lsof

# Add wrapper for ps that supports the p argument used by `lucky watch`
COPY bin/ps /bin/

# Install Lucky CLI
ARG LUCKY_VERSION="0.18.2"
RUN wget -O- https://api.github.com/repos/luckyframework/lucky_cli/tarball/v$LUCKY_VERSION \
      | tar zx && \
    cd luckyframework* && \
    shards install && \
    crystal build src/lucky.cr --release -o /usr/local/bin/lucky && \
    cd - && rm -rf luckyframework*


# Skip check for process runner when running script/setup.
ENV CI=yes
