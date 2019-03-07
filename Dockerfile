FROM golang as builder
RUN go get -d -v github.com/M3philis/junos_exporter
WORKDIR /go/src/github.com/M3philis/junos_exporter
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app .

FROM alpine
ENV SSH_KEYFILE "/ssh-keyfile"
ENV SSH_USER "junos_exporter"
ENV CONFIG_FILE "/config.yml"
ENV ALARM_FILTER ""
RUN apk --no-cache add ca-certificates
WORKDIR /app
COPY --from=builder /go/src/github.com/M3philis/junos_exporter/app junos_exporter
CMD ./junos_exporter -ssh.user=$SSH_USER -ssh.keyfile=$SSH_KEYFILE -config.file=$CONFIG_FILE -alarms.filter=$ALARM_FILTER
EXPOSE 9326
