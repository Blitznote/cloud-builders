FROM blitznote/debase:16.04

ENTRYPOINT ['/usr/bin/git']

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
