# Environment variables
export PATH := $(HOME)/bin/fop:$(PATH)
export CLASSPATH := xsl/xsl-stylesheets/extensions/xalan25.jar

# Do you need a proxy ?
#export FOP_OPTS := -Dhttp.proxyHost=193.100.252.20 -Dhttp.proxyPort=8080

# Or any setting
export FOP_OPTS := -Xmx1G -Djava.awt.headless=true

# Target filenames
PDF_FILE := book.pdf
RTF_FILE := book.rtf
TXT_FILE := book.txt
PS_FILE := book.ps
XHTML_DIR := book-xhtml
XHTML1_DIR := onepage-xhtml
HTML_DIR := book-html
HTML1_DIR := onepage-html
XHTML_ARCH := book-xhtml.tar.bz2
HTML_ARCH := book-html.tar.bz2
XHTML1_ARCH := onepage-xhtml.tar.bz2
HTML1_ARCH := onepage-html.tar.bz2
VALIDITY_FILE := validity



# Source filenames
XSL_FO_FILE := xsl/fo.xsl
XSL_XHTML_FILE := xsl/xhtml-chunked.xsl
XSL_HTML_FILE := xsl/html-chunked.xsl
XSL_XHTML1_FILE := xsl/xhtml-onepage.xsl
XSL_HTML1_FILE := xsl/html-onepage.xsl
DB_FILE := main.xml

# Titlepage customization
TP_SPEC_FILE := xsl/titlepage.spec.xml
TP_XSL_FILE := xsl/titlepage.xsl
TP_TEMPLATE_FILE := ../globals/xsl-stylesheets/template/titlepage.xsl

# Do you have a custom titlepage ?
TP_XSL_REAL := $(shell if test -f $(TP_SPEC_FILE); then echo $(TP_XSL_FILE); fi)

# FOP configuration
FOP := fop
FOP_CONF := fop.xconf

# XSLT configuration
XSLTPROC := xsltproc

# Validity check
VALIDATOR := xmllint --noout --valid

# Extract external entities
XML_FILES := $(wildcard include/*.xml)
DEPENDENCIES := $(TP_XSL_REAL) $(VALIDITY_FILE)

# Default target
all: $(PDF_FILE) $(RTF_FILE) $(TXT_FILE) $(PS_FILE) $(XHTML_ARCH) $(HTML_ARCH) $(XHTML1_ARCH) $(HTML1_ARCH)

$(VALIDITY_FILE): $(DB_FILE) $(XML_FILES)
	$(VALIDATOR) $<
	touch $(VALIDITY_FILE)

$(PDF_FILE): $(DB_FILE) $(XSL_FO_FILE) $(DEPENDENCIES)
	$(FOP) -c $(FOP_CONF) -xsl $(XSL_FO_FILE) -xml $< -pdf $@

$(RTF_FILE): $(DB_FILE) $(XSL_FO_FILE) $(DEPENDENCIES)
	$(FOP) -c $(FOP_CONF) -xsl $(XSL_FO_FILE) -xml $< -rtf $@

$(TXT_FILE): $(DB_FILE) $(XSL_FO_FILE) $(DEPENDENCIES)
	$(FOP) -c $(FOP_CONF) -xsl $(XSL_FO_FILE) -xml $< -txt $@

$(PS_FILE): $(DB_FILE) $(XSL_FO_FILE) $(DEPENDENCIES)
	$(FOP) -c $(FOP_CONF) -xsl $(XSL_FO_FILE) -xml $< -ps $@

$(XHTML_DIR): $(DB_FILE) $(XSL_XHTML_FILE) $(DEPENDENCIES)
	if [ ! -e $(XHTML_DIR) ]; then mkdir $(XHTML_DIR); ln -s ../img $(XHTML_DIR)/img; \
	ln -s ../../globals/xsl-stylesheets/images $(XHTML_DIR)/std-img; fi
	$(XSLTPROC) $(XSL_XHTML_FILE) $<
	touch $(XHTML_DIR)

$(HTML_DIR): $(DB_FILE) $(XSL_HTML_FILE) $(DEPENDENCIES)
	if [ ! -e $(HTML_DIR) ]; then mkdir $(HTML_DIR); ln -s ../img $(HTML_DIR)/img; \
	ln -s ../../globals/xsl-stylesheets/images $(HTML_DIR)/std-img; fi
	$(XSLTPROC) $(XSL_HTML_FILE) $<
	touch $(HTML_DIR)

$(XHTML1_DIR): $(DB_FILE) $(XSL_XHTML1_FILE) $(DEPENDENCIES)
	if [ ! -e $(XHTML_DIR) ]; then mkdir $(XHTML1_DIR); ln -s ../img $(XHTML1_DIR)/img; \
	ln -s ../../globals/xsl-stylesheets/images $(XHTML1_DIR)/std-img; fi
	$(XSLTPROC) -output $@/index.xhtml $(XSL_XHTML1_FILE) $<
	touch $(XHTML1_DIR)

$(HTML1_DIR): $(DB_FILE) $(XSL_HTML1_FILE) $(DEPENDENCIES)
	if [ ! -e $(HTML1_DIR) ]; then mkdir $(HTML1_DIR); ln -s ../img $(HTML1_DIR)/img; \
	ln -s ../../globals/xsl-stylesheets/images $(HTML1_DIR)/std-img; fi
	$(XSLTPROC) -output $@/index.html $(XSL_HTML1_FILE) $<
	touch $(HTML1_DIR)

$(HTML_ARCH): $(HTML_DIR)
	tar -jcv -h --exclude '.svn' --exclude '*.svg' -f $@ $<

$(XHTML_ARCH): $(XHTML_DIR)
	tar -jcv -h --exclude '.svn' --exclude '*.svg' -f $@ $<

$(HTML1_ARCH): $(HTML1_DIR)
	tar -jcv -h --exclude '.svn' --exclude '*.svg' -f $@ $<

$(XHTML1_ARCH): $(XHTML1_DIR)
	tar -jcv -h --exclude '.svn' --exclude '*.svg' -f $@ $<

$(TP_XSL_FILE): $(TP_SPEC_FILE)
	$(XSLTPROC) -output $@ $(TP_TEMPLATE_FILE) $<

clean:
	rm -f $(PDF_FILE) $(TP_XSL_FILE) $(VALIDITY_FILE) $(HTML_ARCH) $(XHTML_ARCH) $(RTF_FILE) $(TXT_FILE) $(PS_FILE)
	rm -rf $(XHTML_DIR) $(HTML_DIR) $(HTML1_DIR) $(XHTML1_DIR)

test: 
	@echo '$(XML_FILES)'

.PHONY: all clean test

