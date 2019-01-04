FROM blitznote/gcc:latest

ENTRYPOINT ['/usr/bin/cmake']

RUN apt-get -q update \
 && apt-get -y --no-install-recommends install \
      cmake \
      make \
      ninja-build \
      pkg-config \
 && rm -rf /usr/share/{doc,man,info} &>/dev/null \
 && find /usr/share/locale/ -maxdepth 1 -mindepth 1 -type d -exec rm -r '{}' \; \
 && find /var -name '*-old' -type f -delete \
 && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
