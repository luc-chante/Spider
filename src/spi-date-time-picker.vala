/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * spi-date-time-picker.vala
 * Copyright (C) 2013 Luc Chante <luc.chante@gmail.com>
 *
 */

public class Spi.DateTimePicker : Gtk.Dialog {

	private Gtk.Grid container = new Gtk.Grid ();
	
	// Constructor
	public DateTimePicker () {
		this.child = this.container;

		this.attach(new Gtk.Label ("L"), 0, 0, 1, 1);
		this.attach(new Gtk.Label ("M"), 1, 0, 1, 1);
		this.attach(new Gtk.Label ("M"), 2, 0, 1, 1);
		this.attach(new Gtk.Label ("J"), 3, 0, 1, 1);
		this.attach(new Gtk.Label ("W"), 4, 0, 1, 1);
		this.attach(new Gtk.Label ("S"), 5, 0, 1, 1);
		this.attach(new Gtk.Label ("D"), 6, 0, 1, 1);
	}

	private void attach (Gtk.Widget child, int left, int top, int width, int height) {
		this.container.attach(child, left, top, width, height);
	}
}
