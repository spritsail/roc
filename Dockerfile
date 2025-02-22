ARG ROC_VER=v0.4.0

FROM alpine:3.21 AS builder

ARG ROC_VER

RUN echo "@testing https://dl-cdn.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories \
    && apk add -U --no-cache alpine-sdk scons autoconf cmake ragel gengetopt libuv-dev libunwind-dev libsndfile-dev speexdsp-dev sox-dev \
    && git clone https://github.com/roc-streaming/roc-toolkit.git --depth 1 --branch ${ROC_VER} \
    && cd roc-toolkit \
    && scons -Q --build-3rdparty=openfec --disable-alsa --disable-pulseaudio --disable-openssl \
    && scons -Q --prefix=/output/usr --build-3rdparty=openfec --disable-alsa --disable-pulseaudio --disable-openssl install \
    && rm -r /output/usr/include /output/usr/share /output/usr/lib/pkgconfig


FROM spritsail/alpine:3.21

ARG ROC_VER

LABEL org.opencontainers.image.authors="Spritsail <roc@spritsail.io>" \
    org.opencontainers.image.title="ROC Streaming toolkit" \
    org.opencontainers.image.url="https://github.com/roc-streaming/roc-toolkit" \
    org.opencontainers.image.source="https://github.com/spritsail/roc" \
    org.opencontainers.image.description="ROC - the realtime audio streaming toolkit" \
    org.opencontainers.image.version=${ROC_VER}

RUN apk add -U --no-cache libstdc++ libuv libunwind libsndfile speexdsp sox

COPY --from=builder /output /

CMD ["/usr/bin/roc-recv", "--source", "rtp+rs8m://0.0.0.0:10001", "--repair", "rs8m://0.0.0.0:10002", "--output", "file:///audio", "--output-format", "s16"]