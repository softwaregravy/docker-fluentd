#!/bin/bash
mkdir /etc/fluent
cat > /etc/fluent/fluent.conf <<EOF
<source>
  type tail
  format none
  time_key time
  path /var/lib/docker/containers/*/*-json.log
  pos_file /var/lib/docker/containers/containers.log.pos
  time_format %Y-%m-%dT%H:%M:%S
  tag docker.log.*
</source>

<match docker.log.**>
  type docker_tag_resolver
</match>

<match docker.container.**>
  type forward
  heartbeat_type tcp
  <server>
    host $FLUENTD_HOST
  </server>
</match>
EOF
exec fluentd -c /etc/fluent/fluent.conf