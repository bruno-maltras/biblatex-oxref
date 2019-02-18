NAME  = oxref
PFX   = biblatex-
STY1  = oxnotes
STY2  = oxyear
STY3  = oxnum
STY4  = oxalph
SHELL = bash
PWD   = $(shell pwd)
TEMP := $(shell mktemp -d -t tmp.XXXXXXXXXX)
TDIR  = $(TEMP)/$(NAME)
VERS  = $(shell ltxfileinfo -v $(NAME).dtx)
LOCAL = $(shell kpsewhich --var-value TEXMFLOCAL)
UTREE = $(shell kpsewhich --var-value TEXMFHOME)

.PHONY: source clean distclean inst uninst install uninstall zip ctan

all:	$(NAME).pdf $(STY1)-doc.pdf $(STY2)-doc.pdf $(STY3)-doc.pdf $(STY4)-doc.pdf clean
	@exit 0

source $(NAME).bbx american-$(NAME).lbx british-$(NAME).lbx english-$(NAME).lbx $(STY1)-doc.tex $(STY1).bbx $(STY1).cbx $(STY1).dbx $(STY2)-doc.tex $(STY2).bbx $(STY2).cbx $(STY2).dbx $(STY3)-doc.tex $(STY3).bbx $(STY3).cbx $(STY3).dbx $(STY4)-doc.tex $(STY4).bbx $(STY4).cbx $(STY4).dbx: $(NAME).dtx
	luatex -interaction=nonstopmode $(NAME).dtx >/dev/null

$(NAME).pdf: $(NAME).dtx $(NAME).bbx $(STY1).bbx $(STY1).cbx american-$(NAME).lbx british-$(NAME).lbx english-$(NAME).lbx
	latexmk -silent -lualatex -shell-escape -interaction=nonstopmode $(NAME).dtx >/dev/null
$(STY1)-doc.pdf: $(STY1)-doc.tex $(NAME).bbx $(STY1).bbx $(STY1).cbx american-$(NAME).lbx british-$(NAME).lbx english-$(NAME).lbx
	latexmk -silent -lualatex -shell-escape -interaction=nonstopmode $(STY1)-doc.tex >/dev/null
$(STY2)-doc.pdf: $(STY2)-doc.tex $(NAME).bbx $(STY2).bbx $(STY2).cbx american-$(NAME).lbx british-$(NAME).lbx english-$(NAME).lbx
	latexmk -silent -lualatex -shell-escape -interaction=nonstopmode $(STY2)-doc.tex >/dev/null
$(STY3)-doc.pdf: $(STY3)-doc.tex $(NAME).bbx $(STY3).bbx $(STY3).cbx american-$(NAME).lbx british-$(NAME).lbx english-$(NAME).lbx
	latexmk -silent -lualatex -shell-escape -interaction=nonstopmode $(STY3)-doc.tex >/dev/null
$(STY4)-doc.pdf: $(STY4)-doc.tex $(NAME).bbx $(STY4).bbx $(STY4).cbx american-$(NAME).lbx british-$(NAME).lbx english-$(NAME).lbx
	latexmk -silent -lualatex -shell-escape -interaction=nonstopmode $(STY4)-doc.tex >/dev/null

clean:
	for log in *.log; do [ -e "$$log" ] || continue; grep "WARNING: biblatex-oxref" $$log; test $$? -eq 1; done
	rm -f {$(NAME),$(STY1)-doc,$(STY2)-doc,$(STY3)-doc,$(STY4)-doc}.{aux,bbl,bcf,blg,doc,fdb_latexmk,fls,glo,gls,hd,idx,ilg,ind,listing,log,nav,out,run.xml,snm,synctex.gz,toc,vrb}
	rm -f {$(STY1),$(STY2),$(STY3),$(STY4),american-$(NAME),british-$(NAME),english-$(NAME)}.doc
	rm -rf _minted-*
	rm -f $(NAME).markdown.in
	rm -rf _markdown_*
distclean: clean
	rm -f $(NAME).{bbx,bib,ins,pdf} {$(STY1),$(STY2),$(STY3),$(STY4)}.{b,c,d}bx {american,british,english}-$(NAME).lbx {$(STY1),$(STY2),$(STY3),$(STY4)}-doc.{tex,pdf}

inst: all
	mkdir -p $(UTREE)/{tex,source,doc}/latex/$(PFX)$(NAME)
	cp $(NAME).{dtx,ins} $(UTREE)/source/latex/$(PFX)$(NAME)
	cp $(NAME).bbx {$(STY1),$(STY2),$(STY3),$(STY4)}.{b,c,d}bx {american,british,english}-$(NAME).lbx $(UTREE)/tex/latex/$(PFX)$(NAME)
	cp $(NAME).{bib,pdf} {$(STY1),$(STY2),$(STY3),$(STY4)}-doc.{tex,pdf} $(UTREE)/doc/latex/$(PFX)$(NAME)
	mktexlsr
uninst:
	rm -r $(UTREE)/{tex,source,doc}/latex/$(PFX)$(NAME)
	mktexlsr

install: all
	sudo mkdir -p $(LOCAL)/{tex,source,doc}/latex/$(PFX)$(NAME)
	sudo cp $(NAME).{dtx,ins} $(LOCAL)/source/latex/$(PFX)$(NAME)
	sudo cp $(NAME).bbx {$(STY1),$(STY2),$(STY3),$(STY4)}.{b,c,d}bx {american,british,english}-$(NAME).lbx $(LOCAL)/tex/latex/$(PFX)$(NAME)
	sudo cp $(NAME).{bib,pdf} {$(STY1),$(STY2),$(STY3),$(STY4)}-doc.{tex,pdf} $(LOCAL)/doc/latex/$(PFX)$(NAME)
	sudo mktexlsr
uninstall:
	sudo rm -r $(LOCAL)/{tex,source,doc}/latex/$(PFX)$(NAME)
	sudo mktexlsr

zip: all
	mkdir $(TDIR)
	cp $(NAME).{dtx,pdf} {$(STY1),$(STY2),$(STY3),$(STY4)}-doc.pdf README.md Makefile $(NAME).bbx {$(STY1),$(STY2),$(STY3),$(STY4)}.{b,c,d}bx {american,british,english}-$(NAME).lbx $(TDIR)
	cd $(TEMP); zip -Drq $(PWD)/$(PFX)$(NAME)-$(VERS).zip $(NAME)
ctan: all
	mkdir $(TDIR)
	cp $(NAME).{dtx,pdf} {$(STY1),$(STY2),$(STY3),$(STY4)}-doc.pdf README.md Makefile $(TDIR)
	cd $(TEMP); zip -Drq $(PWD)/$(PFX)$(NAME)-$(VERS).zip $(NAME)
