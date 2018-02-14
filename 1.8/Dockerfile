FROM       blitznote/debase:16.04

# prereqs used by and with some Golang packages
RUN apt-get -q update \
 && apt-get -y --no-install-recommends install \
      g++ \
      gcc \
      binutils \
      libc6-dev \
      make \
      pkg-config \
      git \
 && (cd /usr/share/doc/git/contrib/diff-highlight && make) \
 && cp -a /usr/share/doc/git/contrib/diff-highlight/diff-highlight /usr/bin/ \
 && printf "[color]\n\tdiff = auto\n\tstatus = auto\n\tbranch = auto\n[gpg]\n\tprogram = gpg2\n[diff]\n\tcompactionHeuristic = true\n[pager]\n\tlog = /usr/bin/diff-highlight | less -r\n\tshow = /usr/bin/diff-highlight | less -r\n\tdiff = /usr/bin/diff-highlight | less -r\n[interactive]\n\tdiffFilter = /usr/bin/diff-highlight\n" >/root/.gitconfig \
 && rm -rf /usr/share/{doc,man,info} &>/dev/null \
 && find /usr/share/locale/ -maxdepth 1 -mindepth 1 -type d -exec rm -r '{}' \; \
 && find /var -name '*-old' -type f -delete \
 && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV GOLANG_VERSION="1.8.7" \
    GOPATH="/go" \
    GOROOT="/opt/go" \
    PATH="$GOPATH/bin:/opt/go/bin:$PATH"

LABEL org.label-schema.vendor="Blitznote" \
      org.label-schema.name="Golang" \
      org.label-schema.version="${GOLANG_VERSION}" \
      org.label-schema.vcs-ref="" \
      org.label-schema.vcs-type="git" \
      org.label-schema.vcs-url="https://github.com/Blitznote/golang"

# install the pre-compiled vanilla Golang to /opt/go
RUN mkdir -p "${GOPATH}" "${GOROOT}" \
 && chmod 1777 "${GOPATH}" \
 && curl --fail --location --silent --show-error -o - \
      "https://dl.google.com/go/go${GOLANG_VERSION}.linux-$(dpkg --print-architecture).tar.gz" \
    | tar --no-same-owner --strip-components=1 -xz -C "${GOROOT}"/ \
 && go version

WORKDIR $GOPATH
