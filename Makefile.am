## Process this file with automake to produce Makefile.in
## Created by Anjuta

SUBDIRS = src 

spiderdocdir = ${prefix}/doc/spider
spiderdoc_DATA = \
	README.md\
	LICENSE\
	AUTHORS\
	ChangeLog\
	INSTALL\
	NEWS


EXTRA_DIST = $(spiderdoc_DATA)


# Remove doc directory on uninstall
uninstall-local:
	-rm -r $(spiderdocdir)
