from __future__ import annotations
import re
from typing import Dict, Iterable, Iterator

COMMENT_RE = re.compile(r'^\s*(?:#|;)\s*')
ASSIGN_RE = re.compile(
    r'^\s*(?:export\s+)?([A-Za-z_][A-Za-z0-9_]*)\s*=\s*(.*)$', re.IGNORECASE
)


def _iter_lines(lines: Iterable[str]) -> Iterator[str]:
    """Yield cleaned lines (strip trailing newline only)."""
    for raw in lines:
        yield raw.rstrip('\n')


def parse_env_lines(lines: Iterable[str]) -> Dict[str, str]:
    """
    Parse iterable of lines from a .env file and return a dict of key->value.

    - Supports optional "export KEY=VAL"
    - Handles single or double quoted values, preserving inner content.
    - Strips inline comments when not inside quotes.
    - Silently ignores invalid/blank/comment lines.
    """
    env: Dict[str, str] = {}

    for line in _iter_lines(lines):
        if not line or COMMENT_RE.match(line):
            continue

        m = ASSIGN_RE.match(line)
        if not m:
            # ignore malformed lines
            continue

        key, raw_val = m.group(1), m.group(2).strip()

        # If quoted value (same quote char at start and end) — unquote and unescape simple escapes.
        if raw_val and len(raw_val) >= 2 and raw_val[0] == raw_val[-1] and raw_val[0] in ("'", '"'):
            inner = raw_val[1:-1]
            # simple unescaping for common patterns
            inner = inner.replace(r'\"', '"').replace(r"\'", "'").replace(r'\\', '\\')
            env[key] = inner
            continue

        # Unquoted — remove inline comment markers (# or ;) if they appear after a space
        # but treat '\#' as escaped hash.
        val = raw_val
        val = val.replace(r'\#', '\0HASH0')
        # split on first ' #' or ' ;' (space then marker) or simply '#' or ';' directly
        # keep it simple: split on first occurrence of # or ;, but we've protected escaped \#
        val = re.split(r'[#;]', val, maxsplit=1)[0].strip()
        val = val.replace('\0HASH0', '#')

        # Trim surrounding quotes if the user accidentally left them
        if (val.startswith('"') and val.endswith('"')) or (val.startswith("'") and val.endswith("'")):
            val = val[1:-1]

        env[key] = val

    return env


def load_from_file(path: str) -> Dict[str, str]:
    """Load .env from a file path."""
    with open(path, 'r', encoding='utf-8') as fh:
        return parse_env_lines(fh)
