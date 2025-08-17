#!/usr/bin/env python3
import os
import sys
import unicodedata
from pathlib import Path

ROOT = Path(sys.argv[1])

def nfc(name: str) -> str:
    return unicodedata.normalize("NFC", name)

def unique_target(path: Path, target_name: str) -> Path:
    """Return a unique target path in path.parent, appending ' (nfc)' if needed."""
    parent = path.parent
    base = target_name
    stem = Path(base).stem
    suffix = Path(base).suffix
    candidate = parent / base
    i = 1
    while candidate.exists():
        candidate = parent / f"{stem} (nfc{'' if i==1 else f'-{i}'}){suffix}"
        i += 1
    return candidate

def rename_path(src: Path, dst: Path, apply: bool):
    if src == dst:
        return False
    if apply:
        # Ensure parent exists (it should) and rename
        dst.parent.mkdir(parents=True, exist_ok=True)
        # If the only difference is normalization, dst may compare equal on some FS; handle carefully
        if dst.exists():
            dst = unique_target(src, dst.name)
        src.rename(dst)
    print(f"{'RENAME' if apply else 'DRYRUN'}: {src}  ->  {dst}")
    return True

def main():
    apply = "--apply" in sys.argv[1:]
    if not ROOT.exists():
        print(f"Error: {ROOT} does not exist", file=sys.stderr)
        sys.exit(1)

    # Walk deepest-first so children are renamed before their parents
    renamed_any = False
    for dirpath, dirnames, filenames in os.walk(ROOT, topdown=False, followlinks=False):
        # Files first
        for name in filenames:
            src = Path(dirpath) / name
            dst = src.with_name(nfc(name))
            renamed_any |= rename_path(src, dst, apply)

        # Then directories
        for name in dirnames:
            src = Path(dirpath) / name
            dst = src.with_name(nfc(name))
            renamed_any |= rename_path(src, dst, apply)

    if not renamed_any:
        print("No changes needed; everything appears to be NFC-normalized.")

    if not apply:
        print("\nThis was a dry run. Re-run with --apply to make changes.")

if __name__ == "__main__":
    main()
