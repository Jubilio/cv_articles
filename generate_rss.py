import os
from feedgen.feed import FeedGenerator

def generate_feeds():
    print("Generating RSS and Atom feeds for the blog...")
    fg = FeedGenerator()
    fg.id('https://jubiliomausse.github.io/blog')
    fg.title('Jubílio Maússe - Blog')
    fg.author({'name': 'Jubílio Filiano Maússe', 'email': 'jubiliomausse5@gmail.com'})
    fg.link(href='https://jubiliomausse.github.io', rel='alternate')
    fg.description('Artigos, Dicas SIG e Reflexões sobre Ajuda Humanitária')

    # Example of adding one static entry to ensure the feed isn't empty. 
    # In a fully robust system, this would parse markdown frontmatter from the blog/ folder.
    fe = fg.add_entry()
    fe.id('https://jubiliomausse.github.io/blog/primeiro-post')
    fe.title('Primeiro Post do Blog: GIS e Acção Humanitária')
    fe.link(href='https://jubiliomausse.github.io/blog/primeiro-post.html')
    fe.description('A inaugurar o blog com notas sobre mapas e RRM.')
    
    # Write to files
    fg.rss_file('rss.xml')
    fg.atom_file('atom.xml')
    print("Successfully generated rss.xml and atom.xml")

if __name__ == "__main__":
    generate_feeds()
