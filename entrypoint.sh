#!/bin/sh
set -e
: "${UUID:?UUID env var required}"
: "${WS_PATH:=/ws}"
PORT="${PORT:-10000}"
cat > /tmp/config.json <<JSON
{
  "log": { "loglevel": "warning" },
  "inbounds": [
    {
      "listen": "0.0.0.0",
      "port": ${PORT},
      "protocol": "vless",
      "settings": {
        "clients": [ { "id": "${UUID}", "flow": "" } ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "security": "none",
        "wsSettings": { "path": "${WS_PATH}" }
      }
    }
  ],
  "outbounds": [
    { "protocol": "freedom", "tag": "direct", "settings": { "domainStrategy": "UseIPv4" } }
  ]
}
JSON
exec /usr/local/bin/xray run -c /tmp/config.json
