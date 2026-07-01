import subprocess
import sys
import os
import shutil
from pathlib import Path


def check_command(cmd, name):
    if shutil.which(cmd) is None:
        print(f"Error: {name} ('{cmd}') is not installed or not on PATH.")
        sys.exit(1)


def build_pdf():
    check_command("myst", "MyST")

    target_md = Path("pages") / "artigos" / "groundwater_mueda.md"

    if not target_md.exists():
        print(f"File {target_md} not found.")
        sys.exit(1)

    print("Building Article PDF via MyST + Typst...")
    # myst build --typst handles both export AND compilation internally
    result = subprocess.run(
        ["myst", "build", "--typst", str(target_md)],
        capture_output=False,
    )

    if result.returncode != 0:
        print("Error: myst build --typst failed.")
        sys.exit(result.returncode)

    # MyST outputs the PDF to a hashed temp path; find it under _build/exports/
    exports_dir = Path("_build") / "exports"
    pdf_candidates = list(exports_dir.rglob("groundwater-mueda.pdf"))

    if not pdf_candidates:
        print("Warning: groundwater-mueda.pdf not found under _build/exports/ — skipping copy.")
        return

    # Use the most recently modified one (in case of multiple builds)
    src_pdf = max(pdf_candidates, key=lambda p: p.stat().st_mtime)

    # Copy to a stable, well-known path used by deploy.yml
    dest_pdf = exports_dir / "groundwater_mueda.pdf"
    shutil.copy2(src_pdf, dest_pdf)
    print(f"PDF build successful: {src_pdf} -> {dest_pdf}")


if __name__ == "__main__":
    build_pdf()
