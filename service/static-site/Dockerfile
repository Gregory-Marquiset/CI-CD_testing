FROM alpine:3.21

RUN addgroup -S static \
 && adduser  -S -D -H -h /nonexistent -s /sbin/nologin -G static static \
 && apk add --no-cache darkhttpd

COPY site/ /site
RUN chown -R static:static /site \
 && chmod -R a+rX /site

USER static
EXPOSE 8080

ENTRYPOINT ["darkhttpd","/site","--port","8080","--addr","0.0.0.0","--log","/dev/stdout","--no-listing"]
