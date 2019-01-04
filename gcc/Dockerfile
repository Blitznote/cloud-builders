FROM blitznote/debase:16.04

ENTRYPOINT ["/bin/bash", "-c"]

RUN apt-get -q update \
 && apt-get -y --no-install-recommends install \
      binutils \
      g++ \
      gcc \
      libc6-dev \
      make \
      pkg-config \
 && rm -rf /usr/share/{doc,man,info} &>/dev/null \
 && find /usr/share/locale/ -maxdepth 1 -mindepth 1 -type d -exec rm -r '{}' \; \
 && find /var -name '*-old' -type f -delete \
 && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN cd /tmp \
 && curl --silent --show-error --fail --location --remote-name-all \
       $(curl --silent --show-error --fail --location --header 'Accept: application/json' --compressed \
         "https://api.github.com/repos/google/protobuf/releases" \
         | jq -r '.[].assets[] | select((.browser_download_url|endswith(".zip")) and (.browser_download_url|contains("/protoc-"))) | .browser_download_url' \
         | grep -m 1 -F linux-x86_64) \
 && unzip protoc-*.zip bin/protoc -d /usr/ \
 && chmod a+x /usr/bin/protoc \
 && /usr/bin/protoc --version \
 && rm protoc-*.zip \
 && curl --silent --show-error --fail --location --header "Accept: application/tar+xz, application/x-xz, application/octet-stream" \
      $(curl --silent --show-error --fail --location --header 'Accept: application/json' \
        "https://api.github.com/repos/upx/upx/releases/latest" \
        | jq -r '.assets[] | select(.name | contains("linux")) | select(.name | contains("'$(dpkg --print-architecture)'")) | select(.browser_download_url | contains(".tar.xz")) | .browser_download_url') \
    | tar --no-same-owner --strip-components=1 --wildcards -C /usr/bin/ -xJ "*/upx" \
 && /usr/bin/upx --version
