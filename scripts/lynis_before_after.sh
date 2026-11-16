#!/usr/bin/env bash
# Usage: sudo ./lynis_before_after.sh before|after
set -euo pipefail
TAG="${1:?usage: $0 before|after}"
command -v lynis >/dev/null || apt-get install -y lynis
REPORT="/var/log/lynis-report-${TAG}.dat"
lynis audit system --quiet --no-colors --report-file "$REPORT" > "/root/lynis-${TAG}.txt" || true
echo "Report: $REPORT"
grep -E '^hardening_index=' "$REPORT" || true
echo "Warnings:    $(grep -c '^warning\[\]' "$REPORT" || true)"
echo "Suggestions: $(grep -c '^suggestion\[\]' "$REPORT" || true)"
