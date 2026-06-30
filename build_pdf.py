import subprocess
import sys
import os
import shutil

def check_command(cmd, name):
    if shutil.which(cmd) is None:
        print(f"Error: {name} ('{cmd}') is not installed or not on PATH.")
        sys.exit(1)

def build_pdf():
    check_command("myst", "MyST")
    check_command("typst", "Typst")

    print("Building PDFs...")
    # Add files that need PDF generation here. 
    # For now, we just build the groundwater article.
    target_md = os.path.join("pages", "artigos", "groundwater_mueda.md")
    
    if not os.path.exists(target_md):
        print(f"File {target_md} not found.")
        sys.exit(1)

    result = subprocess.run(["myst", "build", "--pdf", target_md], capture_output=False)
    
    if result.returncode != 0:
        print("Error building PDF.")
        sys.exit(result.returncode)

    print("PDF build successful.")

if __name__ == "__main__":
    build_pdf()
