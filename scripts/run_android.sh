#!/usr/bin/env bash
# Run flutter_training on the first available Android device/emulator.
# Mirrors little_dreamers' "Android — build & install" task, minus Maestro.
set -euo pipefail
cd "$(dirname "$0")/.."

echo "==> flutter pub get"
flutter pub get

echo "==> finding an Android device/emulator"
DEVICE_ID="$(flutter devices --machine 2>/dev/null \
  | python3 -c "import sys,json
try:
    d=json.load(sys.stdin)
except Exception:
    d=[]
a=[x['id'] for x in d if str(x.get('targetPlatform','')).startswith('android')]
print(a[0] if a else '')")"

if [ -z "$DEVICE_ID" ]; then
  echo "No Android device found. Booting the first emulator..."
  EMU="$(flutter emulators 2>/dev/null | awk -F' *• *' '/•/{print $1; exit}')"
  if [ -n "${EMU:-}" ]; then
    flutter emulators --launch "$EMU" || true
    echo "Waiting for the emulator to come online..."
    for i in $(seq 1 30); do
      DEVICE_ID="$(flutter devices --machine 2>/dev/null \
        | python3 -c "import sys,json
try:
    d=json.load(sys.stdin)
except Exception:
    d=[]
a=[x['id'] for x in d if str(x.get('targetPlatform','')).startswith('android')]
print(a[0] if a else '')")"
      [ -n "$DEVICE_ID" ] && break
      sleep 3
    done
  fi
fi

if [ -z "$DEVICE_ID" ]; then
  echo "Still no Android device. Start an emulator or plug in a phone, then re-run." >&2
  flutter devices || true
  exit 1
fi

echo "==> flutter run -d $DEVICE_ID"
exec flutter run -d "$DEVICE_ID"
