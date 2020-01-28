#! /bin/bash

wget -q -O aprendeindex.html https://www.aprendemachinelearning.com/guia-de-aprendizaje/
tidy -i aprendeindex.html > aprendeindexpretty.html

for l in $(grep -o -e  'http://www.aprendemachinelearning.com/[0-9/a-z\-]*' aprendeindexpretty.html)
do
  echo $l

  pdfFileName="$(echo $l | cut -d'/' -f4).pdf"
  echo "$pdfFileName"

  wkhtmltopdf $l $pdfFileName
done

