#!/usr/bin/env bash
# Шифрует папку в encrypted/<имя>.tar.gz.enc (AES-256, ключ из переменной AGENTBIT_KEY).
# Пример: tools/pack.sh ~/work/praktika praktika
set -euo pipefail
[ -n "${AGENTBIT_KEY:-}" ] || { echo "Нет переменной AGENTBIT_KEY" >&2; exit 1; }
[ $# -eq 2 ] || { echo "Использование: tools/pack.sh <папка> <имя-архива>" >&2; exit 1; }
src="$1"; name="$2"
root="$(cd "$(dirname "$0")/.." && pwd)"
mkdir -p "$root/encrypted"
tar -C "$(dirname "$src")" -czf - "$(basename "$src")" \
  | openssl enc -aes-256-cbc -pbkdf2 -iter 200000 -salt -pass env:AGENTBIT_KEY -out "$root/encrypted/$name.tar.gz.enc"
echo "Готово: encrypted/$name.tar.gz.enc"
