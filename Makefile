default:
	lualatex cookbook.tex

SECTIONS = appetizer.tex soups.tex sides.tex main.tex sweets.tex other.tex

cookbook.pdf: cookbook.tex cookbook.cls $(SECTIONS) */*.tex cookbooks.bib Makefile
	lualatex cookbook.tex
	biber cookbook
	lualatex cookbook.tex
	xindy -C utf8 -L german-duden -M texindy cookbook.idx
	xindy -C utf8 -L german-duden -M texindy cookbook.region.idx
	xindy -C utf8 -L german-duden -M texindy cookbook.ingredient.idx
	xindy -C utf8 -L german-duden -M texindy cookbook.vegetarian.idx
	xindy -C utf8 -L german-duden -M texindy cookbook.vegan.idx
	lualatex cookbook.tex

$(SECTIONS): %.tex: */*.tex Makefile
	ls $*/*.tex | sed 's/.tex$$//g' | sort -f | awk '{printf "\\input{%s}\n", $$0}' > $@
