SUBDIRS := $(wildcard doc-*)

help:
	@echo "Usages: make <target>"
	@echo "  all       : build all documentations"
	@echo "  new-doc   : create a new documentation from a template"
	@echo "  clean     : clean all documentations"

all: $(SUBDIRS)

$(SUBDIRS):
	make -C $@ all

clean:
	@for i in $(SUBDIRS); do make -C "$$i" clean || exit 1; done

new-doc: template
	@echo "Enter the name of your documentation (no space, special chars, etc.): "
	@echo -n "name> " ; read name ; echo "Creating doc-$$name..." ; cp -r template "doc-$$name"

.PHONY: $(SUBDIRS) new-doc all help clean

