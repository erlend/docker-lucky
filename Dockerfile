# vi: ft=dockerfile
ARG CRYSTAL_VERSION=0.31.1
FROM crystallang/crystal:$CRYSTAL_VERSION

# Prevent apt-get from upgrading crystal as this should be done with the
# CRYSTAL_VERSION argument
RUN apt-mark hold crystal

# Update system and install dependencies
RUN apt-get update -q && \
    apt-get upgrade -y && \
    apt-get install -y postgresql-client && \
    apt-get clean && \
    rm -rf /var/lib/apt/*

# Install Lucky CLI
ARG LUCKY_VERSION=0.18.0
RUN git clone \
      --depth=1 \
      --single-branch \
      --branch=v$LUCKY_VERSION \
      https://github.com/luckyframework/lucky_cli && \
    cd lucky_cli && \
    shards install && \
    crystal build --release src/lucky.cr && \
    install -m755 lucky /usr/local/bin/lucky && \
    cd - && rm -rf lucky_cli

WORKDIR /app

# Don't fail the setup script due to missing Procfile handler
ENV CI=yes
