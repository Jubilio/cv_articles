import subprocess
import sys
import os
import shutil
from pathlib import Path


def resolve_command(cmd):
    resolved = shutil.which(cmd)
    if resolved:
        return resolved

    for candidate in [f"{cmd}.cmd", f"{cmd}.exe", f"{cmd}.bat"]:
        resolved = shutil.which(candidate)
        if resolved:
            return resolved

    return None


def check_command(cmd, name):
    if resolve_command(cmd) is None:
        print(f"Error: {name} ('{cmd}') is not installed or not on PATH.")
        sys.exit(1)


def build_pdf():
    myst_cmd = resolve_command("myst")
    typst_cmd = resolve_command("typst")
    check_command("myst", "MyST")
    check_command("typst", "Typst")

    target_md = Path("pages") / "artigos" / "groundwater_mueda.md"

    if not target_md.exists():
        print(f"File {target_md} not found.")
        sys.exit(1)

    print("Building Article PDF via MyST + Typst...")
    result = subprocess.run(
        [myst_cmd, "build", "--typst", str(target_md)],
        capture_output=False,
    )

    if result.returncode != 0:
        print("Error: myst build --typst failed.")
        sys.exit(result.returncode)

    typst_candidates = [
        Path("pages") / "artigos" / "groundwater_mueda.typ",
        Path("pages") / "artigos" / "groundwater-mueda.typ",
    ]
    typst_source = next((p for p in typst_candidates if p.exists()), None)

    if typst_source is None:
        print("Error: generated Typst file was not found.")
        sys.exit(1)

    exports_dir = Path("_build") / "exports"
    exports_dir.mkdir(parents=True, exist_ok=True)
    dest_pdf = exports_dir / "groundwater_mueda.pdf"

    compile_cmd = [typst_cmd, "compile", str(typst_source), str(dest_pdf)]
    if Path("fonts").exists():
        compile_cmd.extend(["--font-path", "./fonts"])

    compile_result = subprocess.run(compile_cmd, capture_output=False)
    if compile_result.returncode != 0:
        print("Error: typst compile failed.")
        sys.exit(compile_result.returncode)

    if not dest_pdf.exists():
        print("Error: expected PDF was not created.")
        sys.exit(1)

    print(f"PDF build successful: {dest_pdf}")


if __name__ == "__main__":
    build_pdf()
