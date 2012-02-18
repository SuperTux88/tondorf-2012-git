#!/bin/bash

BEAMER_TEX=praesentation

DEFAULT_THEME=Darmstadt

TARGET=target

PDFLATEX="pdflatex --halt-on-error -interaction=nonstopmode"

# cleanup
rm $TARGET -rf

if [ "$1" != "clean" ]; then
	mkdir $TARGET

	# copy images
	if [ -d src/img ]; then
		cp -R src/img $TARGET/img
	fi

	# copy includes
	if [ -d src/inc ]; then
		cp -R src/inc $TARGET/inc
	fi

	if [ -f src/$BEAMER_TEX.tex ]; then
		# generate presentations
		for theme in AnnArbor Antibes Bergen Berkeley Berlin Boadilla CambridgeUS Copenhagen Darmstadt Dresden Frankfurt Goettingen Hannover Ilmenau JuanLesPins Luebeck Madrid Malmoe Marburg Montpellier PaloAlto Pittsburgh Rochester Singapore Szeged Warsaw ; do 
			sed "s/%%%%%THEME_PLACEHOLDER_JENKINSBUILD%%%%%/\\\usetheme{$theme}/g" "src/$BEAMER_TEX.tex" > "$TARGET/$BEAMER_TEX-$theme.tex"
			sed "s/%%%%%HANDOUT_PLACEHOLDER_JENKINSBUILD%%%%%/\\\pgfpagesuselayout{4 on 1}[a4paper,border shrink=5mm,landscape]/g" "$TARGET/$BEAMER_TEX-$theme.tex" > "$TARGET/$BEAMER_TEX-$theme-handout.tex"

			cd $TARGET
			$PDFLATEX "$BEAMER_TEX-$theme.tex"
			$PDFLATEX "$BEAMER_TEX-$theme.tex"
			$PDFLATEX "$BEAMER_TEX-$theme-handout.tex"
			$PDFLATEX "$BEAMER_TEX-$theme-handout.tex"
			cd ..
		done;
	fi

	# copy pdf
	mkdir $TARGET/pdf
	if [ -f src/$BEAMER_TEX.tex ]; then
		cp "$TARGET/$BEAMER_TEX-$DEFAULT_THEME.pdf" "$TARGET/pdf/$BEAMER_TEX.pdf"
		cp "$TARGET/$BEAMER_TEX-$DEFAULT_THEME-handout.pdf" "$TARGET/pdf/$BEAMER_TEX-handout.pdf"
	fi
fi
exit 0
