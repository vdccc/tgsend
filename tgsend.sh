#!/usr/bin/env bash

RECEPIENT_ID=
TOKEN=

send() {
  curl \
    -F chat_id="$RECEPIENT_ID" \
    -F parse_mode=MarkdownV2 \
    -F text="$1" \
    "https://api.telegram.org/bot$TOKEN/sendMessage"
}

upload() {
  curl \
    -F chat_id="$RECEPIENT_ID" \
    -F document="@$1" \
    "https://api.telegram.org/bot$TOKEN/sendDocument"
}

hostname() {
  cat /etc/hostname
}

send_msg() {
  MSG="*From*: \`$(whoami)@$(hostname)\`
  \`\`\`
  $1
  \`\`\`"
  send "$MSG"
}

escape() {
  echo "$1" | sed "s/\./\\\./g"
}

offline() {
  MSG="\`$(hostname)\` going offline"
  send "$MSG"
}

pub_ip() {
  dig +short @ns1-1.akamaitech.net whoami.akamai.net
}

online() {
  PUB=$(printf '`%10s``%20s`' pub "$(pub_ip)")
  TABLE=$(ip -br a show up | grep 'UP' | grep -v 'lo' | awk '{printf "`%10s``%20s`\n", $1, $3}')
  MSG="\`$(hostname)\` going online
$PUB
$TABLE"
  send "$(escape "$MSG")"
}

help() {
  echo "$0 - send notification to telegram account

Usage: $0 <Command>

Commands:
  msg <text>      send text
  online          send going online message
  offline         send going offline message"
}

case "$1" in
  ""|-) send_msg "$(cat /dev/stdin)";;
  msg) send_msg "${2:?empty arg}";;
  online) online;;
  offline) offline;;
  upload) upload "${2:?empty filename}";;
  -h) help;;
  *) help;;
esac

