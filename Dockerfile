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

# Don't fail the setup script due to missing Procfile handler
ENV CI=yes
