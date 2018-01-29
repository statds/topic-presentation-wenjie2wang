## define the name of source files as below
rmd_source := index.Rmd
output_dir := docs

## corresponding output names
html_out := $(patsubst %.Rmd,$(output_dir)/%.html,$(rmd_source))

## CRAN mirror
repos := https://cloud.r-project.org
dep_pkg := revealjs


.PHONY: all
all: html

.PHONY: html
html: $(html_out)

$(html_out): $(rmd_source) _output.yaml
	@$(MAKE) -s check
	@echo "compiling to html slides..."
	@Rscript --vanilla -e \
	"rmarkdown::render('$(rmd_source)', output_dir = '$(output_dir)')"


.PHONY: check
check:
	@Rscript -e \
	"foo <- '$(dep_pkg)' %in% installed.packages()[, 'Package'];" \
	-e "if (! foo) install.packages('$(dep_pkg)', repos = '$(repos)')" \


.PHONY: clean
clean:
	rm -rf *.aux, *.out *.log *.fls *.fdb_latexmk .Rhistory *\#* .\#* *~

.PHONY: cleanCache
rmCache:
	rm -rf *_files *_cache
