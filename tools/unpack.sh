#!/usr/bin/env bash
# Расшифровывает архив из encrypted/ в указанную папку (вне репозитория!).
# Пример: tools/unpack.sh encrypted/guide-src.tar.gz.enc ~/work
set -euo pipefail
[ -n "${AGENTBIT_KEY:-}" ] || { echo "Нет переменной AGENTBIT_KEY" >&2; exit 1; }
[ $# -eq 2 ] || { echo "Использование: tools/unpack.sh <архив.enc> <папка>" >&2; exit 1; }
mkdir -p "$2"
openssl enc -d -aes-256-cbc -pbkdf2 -iter 200000 -pass env:AGENTBIT_KEY -in "$1" | tar -C "$2" -xzf -
echo "Распаковано в $2"
