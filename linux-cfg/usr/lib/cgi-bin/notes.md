#! /bin/bash
echo -e "Content-type: text/html\n\n"
pandoc -f markdown -t html /home/banshee/txt/telbotsavenote.md
