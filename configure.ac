dnl Process this file with autoconf to produce a configure script.
dnl Created by Anjuta application wizard.

AC_INIT(org.luc.spider, 1.0.0, https://github.com/luc-chante/Spider/issues, spider, https://github.com/luc-chante/Spider)

AC_CONFIG_HEADERS([config.h])

AM_INIT_AUTOMAKE([1.11])

AM_SILENT_RULES([yes])

AC_PROG_CC


LT_INIT


dnl Check for vala
AM_PROG_VALAC([0.10.0])


PKG_CHECK_MODULES(SPIDER, [gtk+-3.0 gtksourceview-3.0 libsoup-2.4 >= 2.42 glib-2.0 gee-0.8])


AC_OUTPUT([
Makefile
src/Makefile

])
