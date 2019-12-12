# Lucky

Docker images for working with [Lucky](https://luckyframework.org) projects.

## Tags

- `latest` or `${LUCKY_VERSION}` -- smallest image for API projects
- `full` or `full-${LUCKY_VERSION}` -- includes node, yarn and chromium

## Using with compose

### API projects

```yaml
version: "3.4"
x-defaults: &defaults
  image: erlend/lucky:0.18
  user: "${UID:-1000}:${GID:-1000}"
  environment:
    DB_HOST: database
  volumes:
    - .:/app
    - crystal_libs:/app/lib
    - crystal_cache:/app/.crystal
    - crystal_shards:/app/.shards
  restart: on-failure

services:
  setup:
    <<: *default
    command: script/setup
    depends_on:
      - database

  web:
    <<: *default
    command: lucky watch --reload-browser
    ports:
      - 5000:5000
    depends_on:
      - database

  database:
    image: postgres:11-alpine
    environment:
      POSTGRES_PASSWORD: "postgres"
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  crystal_libs:
  crystal_cache:
  crystal_shards:
  postgres_data:
```

### Full projects

```yaml
version: "3.4"
x-defaults: &defaults
  image: erlend/lucky:full-0.18
  user: "${UID:-1000}:${GID:-1000}"
  environment:
    DB_HOST: database
  volumes:
    - .:/app
    - crystal_libs:/app/lib
    - crystal_cache:/app/.crystal
    - crystal_shards:/app/.shards
    - node_modules:/app/node_modules
  restart: on-failure

services:
  setup:
    <<: *default
    command: script/setup
    depends_on:
      - database

  web:
    <<: *default
    command: lucky watch --reload-browser
    ports:
      - 5000:5000
      - 3001:3001
    depends_on:
      - database

  assets:
    <<: *default
    command: yarn watch

  database:
    image: postgres:11-alpine
    environment:
      POSTGRES_PASSWORD: "postgres"
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  crystal_libs:
  crystal_cache:
  crystal_shards:
  node_modules:
  postgres_data:
```
