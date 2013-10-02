/* -*- Mode: C; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * main.c
 * Copyright (C) 2013 Luc Chante <luc.chante@gmail.com>
 * 
 */

using Gtk;

public class SpiderApp : Gtk.Application {

	public SpiderApp () {
		Object (application_id: "org.luc.spider", flags: GLib.ApplicationFlags.FLAGS_NONE);
	}

	protected override void activate () {
		var window = new Spi.Window (this);
		window.show_all();
	}

	static int main (string[] args) {
		Gtk.init (ref args);
		var app = new SpiderApp ();

		return app.run (args);
	}
}
