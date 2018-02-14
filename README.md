Vanilla Golang for Docker
=========================

A one-stop Golang in **Ubuntu** for Docker.  
With a *openssh-client*—so `go get …@<server>` works, which uses *SSH+GIT*—
and popular tools such as `dep`, `glide`, `golint`, `ineffassign`.

 * Offers more utility
 * at a smaller size
 * with up-to-date packages
 * than a glibc-based `docker.io/golang`.

On top of that this images ships with [upx](https://upx.github.io/), a compressor for executables,
as well as the most recent release of [protoc](https://github.com/google/protobuf/releases).

This image branches from [blitznote/debase](https://github.com/Blitznote/debase).  
Please see its README file for details and requirements.
It won't run on old cpu micro-architectures, and needs Linux 4.4.100 or the like or later.
