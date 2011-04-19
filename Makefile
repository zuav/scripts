# -*- Makefile -*-

INSTALL = install
RM      = rm

script_list = ff emacs.sh

bin_dir = /usr/local/bin

.PHONY: install uninstall

install:
	$(INSTALL) $(script_list) $(bin_dir)/

uninstall:
	-for i in $(script_list) ; do $(RM) $(bin_dir)/$$i ; done
