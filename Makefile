RMD := $(wildcard *.Rmd)

# this does the same thing but is less readable IMO
# MD  := $(RMD:.Rmd=.md)
MD := $(patsubst %.Rmd,%.md,$(RMD))

all: $(MD)

%.md: %.Rmd
	@echo "Rendering $< to $@"
	./rmd_to_md.sh $< $@
