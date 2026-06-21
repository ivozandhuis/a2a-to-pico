#!/usr/bin/env bash
#
# format-xml-files.sh — pretty-print the A2A→PiCo XSLT stylesheets and XML map
# files with tab indentation.
#
# XSLT whitespace can be significant, so this is not a blind reformat: before
# touching anything it snapshots the RDF produced from examples/input/*.xml, and
# after formatting it re-runs the transform and diffs. If the output changed, the
# originals are restored and the script exits non-zero.
#
# Safe to re-run (xmllint --format is idempotent). Both the repo path and the
# www symlink (includes/pico -> this dir) are updated, since they are one tree.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
XSL_DIR="$SCRIPT_DIR/xsl"
INPUT_DIR="$SCRIPT_DIR/examples/input"
MAIN_XSL="$XSL_DIR/a2a-to-pico.xsl"

export XMLLINT_INDENT=$'\t'   # tab indentation

command -v xmllint >/dev/null || { echo "error: xmllint not found" >&2; exit 1; }

# Target files: every .xsl plus the maps/*.xml data files.
mapfile -t FILES < <(find "$XSL_DIR" -maxdepth 2 \( -name '*.xsl' -o -path '*/maps/*.xml' \) | sort)
[ "${#FILES[@]}" -gt 0 ] || { echo "error: no .xsl or maps/*.xml files found under $XSL_DIR" >&2; exit 1; }

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
mkdir -p "$WORK/orig"

# --- golden-master snapshot (before) ---------------------------------------
have_examples=0
if command -v xsltproc >/dev/null && compgen -G "$INPUT_DIR/*.xml" >/dev/null; then
	have_examples=1
	for in in "$INPUT_DIR"/*.xml; do
		xsltproc "$MAIN_XSL" "$in" > "$WORK/$(basename "$in").before" 2>/dev/null || true
	done
else
	echo "note: examples or xsltproc unavailable — skipping output verification" >&2
fi

# --- format each file in place (back up first) -----------------------------
for f in "${FILES[@]}"; do
	cp -p "$f" "$WORK/orig/$(echo "${f#$XSL_DIR/}" | tr '/' '_')"
	xmllint --format "$f" -o "$f.fmt"
	xmllint --noout "$f.fmt"            # well-formed?
	mv "$f.fmt" "$f"
	echo "formatted: ${f#$SCRIPT_DIR/}"
done

# --- golden-master verify (after) ------------------------------------------
if [ "$have_examples" -eq 1 ]; then
	fail=0
	for in in "$INPUT_DIR"/*.xml; do
		if ! xsltproc "$MAIN_XSL" "$in" 2>/dev/null \
		     | diff -q "$WORK/$(basename "$in").before" - >/dev/null; then
			echo "ERROR: transform output changed for $(basename "$in")" >&2
			fail=1
		fi
	done
	if [ "$fail" -ne 0 ]; then
		echo "restoring originals — formatting altered transform output" >&2
		for f in "${FILES[@]}"; do
			cp -p "$WORK/orig/$(echo "${f#$XSL_DIR/}" | tr '/' '_')" "$f"
		done
		exit 1
	fi
	echo "verified: transform output unchanged for all $(ls "$INPUT_DIR"/*.xml | wc -l | tr -d ' ') example(s)"
fi

echo "done: ${#FILES[@]} file(s) formatted with tab indentation."
