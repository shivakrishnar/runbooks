# You're probably wondering why I didn't just use klakegg/hugo:0.71.0-ext-alpine
# Well that "Truly minimal" image is 552 MB. This one is 70.6 MB
FROM alpine:3.20@sha256:1e42bbe2508154c9126d48c2b8a75420c3544343bf86fd041fb7527e017a4b4a

# config
ENV HUGO_VERSION=0.84.1
ENV HUGO_TYPE=_extended
ENV HUGO_DOWNLOAD="https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo${HUGO_TYPE}_${HUGO_VERSION}_Linux-64bit.tar.gz"

# Add requiremnts for Hugo
RUN apk add --no-cache \
  # ca-certificates are required to fetch outside resources (like Twitter oEmbeds)
  ca-certificates \
  # libc6-compat & libstdc++ are required for extended SASS libraries
  # see: https://github.com/gohugoio/hugo/blob/master/Dockerfile#L33
  libc6-compat \
  libstdc++ \
  # Needed for getting post update dates out of git commits
  git && git config --global --add safe.directory /src

# Install Hugo
RUN mkdir -p /tmp/hugo \
    && wget "${HUGO_DOWNLOAD}" -O /tmp/hugo/hugo.tar.gz \
    && tar xvf /tmp/hugo/hugo.tar.gz -C /usr/sbin/ hugo \
    && rm -rf /tmp/hugo

WORKDIR /src

CMD ["/usr/sbin/hugo", "server", "--buildDrafts", "--bind=0.0.0.0"]
