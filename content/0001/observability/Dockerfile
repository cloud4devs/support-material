ARG BUILDER_IMAGE="hexpm/elixir:1.12.0-erlang-24.0.1-debian-bullseye-20210902-slim"
ARG RUNNER_IMAGE="debian:bullseye-slim"

FROM ${BUILDER_IMAGE} as builder

RUN apt-get update -y && apt-get install -y build-essential git \
    && apt-get clean && rm -f /var/lib/apt/lists/*_*

WORKDIR /app

RUN mix do local.hex --force, local.rebar --force


ENV MIX_ENV="prod"

COPY mix.exs mix.lock ./
RUN mix deps.get 
RUN mkdir config

COPY config/config.exs config/${MIX_ENV}.exs config/
RUN mix deps.compile

COPY priv priv
COPY lib lib

RUN mix compile

COPY config/runtime.exs config/

RUN mix release

FROM ${RUNNER_IMAGE} AS app

RUN apt-get update -y && apt-get install -y libstdc++6 openssl libncurses5 locales \
    && apt-get clean && rm -f /var/lib/apt/lists/*_*

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

WORKDIR /app

RUN chown -R nobody:nogroup /app
USER nobody

COPY --from=builder --chown=nobody:nogroup /app/_build/prod/rel/observability .
COPY --chown=nobody:nogroup start.sh ./

CMD ["sh", "./start.sh"]