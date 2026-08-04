from feedgen.feed import FeedGenerator


SITE_URL = "https://jubilio.github.io/cv_articles"
BLOG_URL = f"{SITE_URL}/pages/blog"
ARTICLE_URL = f"{SITE_URL}/blog/gee-banhine-lulc"


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

    fe = fg.add_entry()
    fe.id(ARTICLE_URL)
    fe.title("Classificação LULC com GEE: Parque Nacional do Banhine")
    fe.link(href=ARTICLE_URL)
    fe.description(
        "Guia prático sobre Google Earth Engine e classificação "
        "de uso e cobertura da terra no Parque Nacional do Banhine."
    )

    fg.rss_file("rss.xml")
    fg.atom_file("atom.xml")
    print("Successfully generated rss.xml and atom.xml")


if __name__ == "__main__":
    generate_feeds()
