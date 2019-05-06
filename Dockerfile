FROM debian:stretch


RUN apt-get update \
    && apt-get install openssl -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/lib/apt/lists/partial/*


ARG APP_HOME=/home/hexbot


COPY _build/prod/rel/hexbot $APP_HOME


WORKDIR $APP_HOME


ENV LANG=C.UTF-8
ENV PATH="$APP_HOME/bin:$PATH"

ENTRYPOINT [ "hexbot", "console" ]