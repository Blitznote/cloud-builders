FROM blitznote/golang:latest as gotools

RUN go get \
      github.com/gordonklaus/ineffassign \
      github.com/golang/lint/golint \
      github.com/golang/dep/cmd/dep \
 && go get -d github.com/Masterminds/glide \
 && (cd ${GOPATH%%:*}/src/github.com/Masterminds/glide/ && make build && mv glide ${GOPATH%%:*}/bin/) \
 && find ${GOPATH%%:*}/bin -type f -executable \
    | xargs --max-lines=1 --max-procs=$(nproc) --no-run-if-empty upx --best -q

FROM blitznote/gcc:latest

#import:../../git/Dockerfile
RUN apt-get -q update \
 && apt-get -y --no-install-recommends install \
      git \
      less \
      make \
      openssh-client \
      patch \
 && (cd /usr/share/doc/git/contrib/diff-highlight && make && chmod a+x diff-highlight) \
 && cp -a /usr/share/doc/git/contrib/diff-highlight/diff-highlight /usr/bin/ \
 && printf "[color]\n\tdiff = auto\n\tstatus = auto\n\tbranch = auto\n[gpg]\n\tprogram = gpg\n[diff]\n\tcompactionHeuristic = true\n[pager]\n\tlog = /usr/bin/diff-highlight | less -r\n\tshow = /usr/bin/diff-highlight | less -r\n\tdiff = /usr/bin/diff-highlight | less -r\n[interactive]\n\tdiffFilter = /usr/bin/diff-highlight\n" \
      >~/.gitconfig \
 && rm -rf /usr/share/{doc,man,info} &>/dev/null \
 && find /usr/share/locale/ -maxdepth 1 -mindepth 1 -type d -exec rm -r '{}' \; \
 && find /var -name '*-old' -type f -delete \
 && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
 && mkdir -p ~/.ssh \
 && chmod 0700 ~/.ssh \
 && ssh-keyscan -H \
      hub.blitznote.com \
      github.com \
      bitbucket.org \
      git.sv.gnu.org \
    |& grep -v -F '#' >>~/.ssh/known_hosts
#/import

COPY --from=gotools /go/bin/* /usr/local/bin/
COPY prepare-workspace.bash /usr/share/

ENTRYPOINT ["/usr/share/prepare-workspace.bash"]
WORKDIR /go

ENV GOLANG_VERSION="1.11.4" \
    GOPATH="/go:/usr/share/gocode" \
    GOROOT="/opt/go" \
    PATH="/go/bin:/opt/go/bin:$PATH"

LABEL org.label-schema.vendor="Blitznote" \
      org.label-schema.name="Golang" \
      org.label-schema.version="${GOLANG_VERSION}" \
      org.label-schema.vcs-ref="" \
      org.label-schema.vcs-type="git" \
      org.label-schema.vcs-url="https://github.com/Blitznote/golang"

# install the pre-compiled vanilla Golang to /opt/go
RUN mkdir -p "${GOPATH%%:*}" "${GOROOT}" \
 && chmod 1777 "${GOPATH%%:*}" \
 && curl --fail --location --silent --show-error -o - \
      "https://dl.google.com/go/go${GOLANG_VERSION}.linux-$(dpkg --print-architecture).tar.gz" \
    | tar --no-same-owner --strip-components=1 -xz -C "${GOROOT}"/ \
 && go version
