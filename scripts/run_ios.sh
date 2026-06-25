#!/usr/bin/env bash
# Run flutter_training on the first available iOS simulator/device.
set -euo pipefail
cd "$(dirname "$0")/.."

echo "==> flutter pub get"
flutter pub get

echo "==> finding an iOS device/simulator"
DEVICE_ID="$(flutter devices --machine 2>/dev/null \
  | python3 -c "import sys,json
try:
    d=json.load(sys.stdin)
except Exception:
    d=[]
a=[x['id'] for x in d if str(x.get('targetPlatform','')).startswith('ios')]
print(a[0] if a else '')")"

if [ -z "$DEVICE_ID" ]; then
  echo "No iOS simulator running. Open one with: open -a Simulator" >&2
  flutter devices || true
  exit 1
fi

echo "==> flutter run -d $DEVICE_ID"
exec flutter run -d "$DEVICE_ID"
