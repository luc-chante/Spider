/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * spi-toolbar.vala
 * Copyright (C) 2013 Luc Chante <luc.chante@gmail.com>
 *
 */

public class Spi.Toolbar : Gtk.Toolbar {

	// Raised when the combobox value has changed.
	public signal void method_changed (string method);
	// Raised when the entry location content has changed.
	public signal void location_changed (string url);
	// Raised on send button click
	public new signal bool activate ();
	// Raised when cancel button pressed;
	public signal bool cancel ();

	private Gtk.ComboBoxText method_combo = new Gtk.ComboBoxText ();
	private Gtk.Entry location_entry = new Gtk.Entry ();
	private Gtk.Button cancel_button = new Gtk.Button ();
	private Gtk.Action cancel_action;

	private bool notify_location_changed = true;
	
	// Constructor
	public Toolbar () {
		Object (orientation: Gtk.Orientation.HORIZONTAL);
		this.get_style_context ().add_class (Gtk.STYLE_CLASS_MENUBAR);

		Gtk.ToolItem item;
		Gtk.SizeGroup size_group = new Gtk.SizeGroup (Gtk.SizeGroupMode.VERTICAL);

		// ComboBox
		this.method_combo.append_text ("GET");
		this.method_combo.append_text ("POST");
		item = new Gtk.ToolItem ();
		item.add (this.method_combo);
		this.add (item);

		// Separation
		item = new Gtk.SeparatorToolItem ();
		(item as Gtk.SeparatorToolItem).draw = false;
		this.add (item);
		
		// Location
		this.location_entry.set_placeholder_text ("http://localhost/");

		this.cancel_action = new Gtk.Action ("StopAction", "Stop", "Stop current data transfert", null);
		this.cancel_action.set_icon_name ("process-stop-symbolic");

		this.cancel_button.set_image (new Gtk.Image ());
		this.cancel_button.set_related_action (this.cancel_action);
		this.cancel_button.set_label (null);
		this.cancel_button.set_state_flags (Gtk.StateFlags.INSENSITIVE, true);

		var box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
		box.add (this.location_entry);
		box.add (this.cancel_button);
		box.child_set_property (this.location_entry, "expand", true);
		box.get_style_context ().add_class (Gtk.STYLE_CLASS_RAISED);
		box.get_style_context ().add_class (Gtk.STYLE_CLASS_LINKED);

		item = new Gtk.ToolItem ();
		item.add (box);
		this.add (item);
		this.child_set_property (item, "expand", true);

		size_group.add_widget (this.method_combo);
		size_group.add_widget (this.location_entry);
		size_group.add_widget (this.cancel_button);

		this.connect_signals ();
	}

	public void init () {
		this.method_combo.active = 0;
	}

	public void set_cancel_enable (bool enable) {
		this.cancel_button.set_state_flags (
				enable ? Gtk.StateFlags.NORMAL : Gtk.StateFlags.INSENSITIVE,
		        true);
	}
	
	private void connect_signals () {
		this.method_combo.changed.connect (() => {
			this.method_changed (this.method_combo.get_active_text ());
		});

		this.location_entry.changed.connect (() => {
			this.notify_location_changed = true;
		});
		this.location_entry.focus_out_event.connect ((event) => {
			this.location_changed (this.location_entry.get_text ());
			this.notify_location_changed = false;
			return false;
		});
		
		this.location_entry.activate.connect (() => {
			if (this.notify_location_changed) {
				if (this.location_entry.text.index_of ("://", 1) == -1) {
					this.location_entry.text = "http://" + this.location_entry.text;
				}
				this.location_changed (this.location_entry.get_text ());
			}
			this.notify_location_changed = false;
			this.activate ();
		});

		this.cancel_action.activate.connect (() => {
			this.cancel ();
		});
	}
}