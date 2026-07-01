import shutil
from pathlib import Path


def build_pdf():
    src_pdf = Path("public") / "articles" / "Mausse_2026_Groundwater_Potential_Mueda.pdf"

    if not src_pdf.exists():
        raise FileNotFoundError(f"Static PDF not found: {src_pdf}")

    exports_dir = Path("_build") / "exports"
    exports_dir.mkdir(parents=True, exist_ok=True)
    dest_pdf = exports_dir / "groundwater_mueda.pdf"
    shutil.copy2(src_pdf, dest_pdf)

    site_articles_dir = Path("_build") / "html" / "articles"
    site_articles_dir.mkdir(parents=True, exist_ok=True)
    site_pdf = site_articles_dir / "Mausse_2026_Groundwater_Potential_Mueda.pdf"
    shutil.copy2(src_pdf, site_pdf)

    print(f"Published static PDF: {src_pdf} -> {dest_pdf}")
    print(f"Published static PDF to site output: {site_pdf}")


if __name__ == "__main__":
    build_pdf()
