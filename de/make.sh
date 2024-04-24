#PATH=$PATH:/opt/homebrew/bin
echo Starting lernOS Guide Generation ...

# Variables
filename="lernOS-Template-Guide-de"
chapters="./src/index.md ./src/1-0-Basics.md ./src/1-1-Understanding_Your_Sewing_Machine.md ./src/1-2-Fabrics_and_Materials.md ./src/1-3-Basic_Sewing_Techniques.md ./src/1-4-Pattern_Reading.md ./src/1-5-Sewing_Safety.md ./src/2-0-Learning-Pathway.md ./src/3-0-Appendix.md"

# Delete Old Versions
echo Deleting old versions ...
rm -rf $filename.*
rm -rf ../docs/de/*
rm -ff ../docs/de-slides/index.html

# Create Web Version (mkdocs)
echo Creating Web Version ...
mkdocs build

# Create Microsoft Word Version (docx)
echo Creating Word version ...
pandoc metadata.yaml -s --resource-path="./src" -F mermaid-filter -N --toc -V lang=de-de -o $filename.docx $chapters

# Create HTML Version (html)
echo Creating HTML version ...
pandoc metadata.yaml -s --resource-path="./src" -F mermaid-filter -N --toc -V lang=de-de -o $filename.html $chapters

# Create PDF Version (pdf)
echo Creating PDF version ...
pandoc metadata.yaml -s --resource-path="./src" -F mermaid-filter --template lernos -N --toc -V lang=de-de -o $filename.pdf $chapters

# Create eBook Versions (epub, mobi)
echo Creating eBook versions ...
magick -density 300 $filename.pdf[0] ebook-cover.jpg
mogrify -size 2500x2500 -resize 2500x2500 ebook-cover.jpg
mogrify -crop 1563x2500+102+0 ebook-cover.jpg
pandoc metadata.yaml -s --resource-path="./src" -F mermaid-filter --epub-cover-image=ebook-cover.jpg -N --toc -V lang=de-de -o $filename.epub $chapters
ebook-convert $filename.epub $filename.mobi

# Create Slides (revealjs)
# echo Creating Presentation ...
# pandoc metadata.yaml --from markdown -s --resource-path="./src" -t revealjs -V theme=night -s ./slides/index.md -o ../docs/de-slides/index.html

# Remove Unnecessary Files
rm mermaid-filter.err
rm ebook-cover.jpg
