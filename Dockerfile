FROM jerson/node:9.5-debian AS builder

ENV WORKDIR /www
WORKDIR /www

COPY package.json yarn.lock Makefile ./
RUN make deps

COPY . .

RUN make build

FROM jerson/nginx:1.13

LABEL maintainer="jeral17@gmail.com"

ENV WORKDIR /www
WORKDIR ${WORKDIR}

COPY --from=builder ${WORKDIR}/dist .
COPY conf/nginx/default.conf /etc/nginx/conf.d/default.conf

VOLUME ["/var/log/nginx"]

ENTRYPOINT ["nginx"]
CMD ["-g","daemon off;"]
