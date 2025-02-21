FROM alpine:latest
RUN apk add --no-cache curl jq
COPY check-internet.sh /check-internet.sh
RUN chmod +x /check-internet.sh
CMD ["sh", "-c", "/check-internet.sh"]