import os
import re
import yaml
from datetime import datetime, timezone
from feedgen.feed import FeedGenerator


SITE_URL = "https://jubilio.github.io/cv_articles"
BLOG_URL = f"{SITE_URL}/pages/blog"
BLOG_DIR = "blog"


def parse_frontmatter(content):
    match = re.match(r"^---\n(.*?)\n---", content, re.DOTALL)
    if match:
        try:
            return yaml.safe_load(match.group(1))
        except yaml.YAMLError:
            pass
    return {}


def get_excerpt(content):
    content = re.sub(r"^---\n.*?\n---", "", content, flags=re.DOTALL)
    content = re.sub(r"^#+ .*", "", content, flags=re.MULTILINE)
    lines = [
        line.strip()
        for line in content.splitlines()
        if line.strip() and not line.strip().startswith("---")
    ]
    if lines:
        excerpt = lines[0]
        # Clean up some common markdown formatting
        excerpt = re.sub(r"\*\*|\*|_", "", excerpt)
        if len(excerpt) > 150:
            excerpt = excerpt[:147] + "..."
        return excerpt
    return "Artigo no blog de Jubílio Maússe."


def generate_feeds():
    print("Generating RSS and Atom feeds for the blog...")

    fg = FeedGenerator()
    fg.id(BLOG_URL)
    fg.title("Jubílio Maússe - Blog")
    fg.author(
        {
            "name": "Jubílio Filiano Maússe",
            "email": "jubiliomausse5@gmail.com",
        }
    )
    fg.link(href=BLOG_URL, rel="alternate")
    fg.description(
        "Artigos, dicas SIG e reflexões sobre análise geoespacial "
        "e acção humanitária"
    )
    fg.language("pt")

    if not os.path.exists(BLOG_DIR):
        print(f"Blog directory '{BLOG_DIR}' not found.")
        return

    articles = []
    for filename in os.listdir(BLOG_DIR):
        if not filename.endswith(".md"):
            continue

        filepath = os.path.join(BLOG_DIR, filename)
        with open(filepath, "r", encoding="utf-8") as f:
            content = f.read()

        meta = parse_frontmatter(content)
        if not meta:
            continue

        title = meta.get("title", filename.replace(".md", ""))
        date_raw = meta.get("date")

        pub_date = None
        if date_raw:
            try:
                if isinstance(date_raw, str):
                    pub_date = datetime.strptime(date_raw, "%Y-%m-%d").replace(
                        tzinfo=timezone.utc
                    )
                elif isinstance(date_raw, datetime):
                    pub_date = date_raw.replace(tzinfo=timezone.utc)
                elif hasattr(date_raw, "timetuple"):
                    pub_date = datetime(
                        date_raw.year, date_raw.month, date_raw.day, tzinfo=timezone.utc
                    )
            except ValueError:
                pass

        if not pub_date:
            pub_date = datetime.now(timezone.utc)

        description = meta.get("description")
        if not description:
            description = get_excerpt(content)

        slug = filename.replace(".md", "")
        article_url = f"{SITE_URL}/blog/{slug}"

        articles.append(
            {
                "title": title,
                "url": article_url,
                "description": description,
                "pub_date": pub_date,
            }
        )

    articles.sort(key=lambda x: x["pub_date"], reverse=True)

    for article in articles:
        fe = fg.add_entry()
        fe.id(article["url"])
        fe.title(article["title"])
        fe.link(href=article["url"])
        fe.description(article["description"])
        fe.pubDate(article["pub_date"])

    fg.rss_file("rss.xml")
    fg.atom_file("atom.xml")
    print("Successfully generated rss.xml and atom.xml")


if __name__ == "__main__":
    generate_feeds()
