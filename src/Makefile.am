## Process this file with automake to produce Makefile.in

## Created by Anjuta


uidir = $(pkgdatadir)/ui
ui_DATA = spider.ui


AM_CPPFLAGS = \
	-DPACKAGE_LOCALE_DIR=\""$(localedir)"\" \
	-DPACKAGE_SRC_DIR=\""$(srcdir)"\" \
	-DPACKAGE_DATA_DIR=\""$(pkgdatadir)"\" \
	$(SPIDER_CFLAGS)

AM_CFLAGS =\
	 -Wall\
	 -g

bin_PROGRAMS = spider

spider_SOURCES = \
	spider.vala config.vapi spi-toolbar.vala spi-header-box.vala spi-window.vala spi-request-builder.vala

spider_VALAFLAGS =  --pkg gtksourceview-3.0 --pkg sqlite3 --pkg libsoup-2.4 --pkg gee-0.8  \
	--pkg gtk+-3.0 --target-glib=2.32

spider_LDFLAGS = \
	-Wl,--export-dynamic

spider_LDADD = $(SPIDER_LIBS)


EXTRA_DIST = $(ui_DATA)

# Remove ui directory on uninstall
uninstall-local:
	-rm -r $(uidir)
	-rm -r $(pkgdatadir)

