/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * spi-header-box.vala
 * Copyright (C) 2013 Luc Chante <luc.chante@gmail.com>
 *
 */

public class Spi.HeaderBox : Gtk.Box {

	public signal void header_added (string label, string value);
	public signal void header_removed (string label, string value);
	
	// Constructor
	public HeaderBox () {
		Object (orientation: Gtk.Orientation.VERTICAL, spacing: 4,
		        homogeneous: true, margin_left: 5, margin_right: 5);

		this.prepend_header (null);
	}

	internal void prepend_header (HeaderBox.Header? widget) {
		if (widget != null) {
			widget.label.set_sensitive (false);
			widget.value.set_sensitive (false);
		
			widget.actions.set_related_action (widget.del_action);
			widget.actions.set_label (null);
			widget.actions.set_state_flags (Gtk.StateFlags.NORMAL, true);

			this.header_added (widget.label.get_active_text (), widget.value.get_text ());
		}
		
		HeaderBox.Header header = new HeaderBox.Header (this);
		this.add (header);
		this.reorder_child (header, 0);
		this.show_all ();
	}

	internal void remove_header (HeaderBox.Header widget) {
		this.header_removed (widget.label.get_active_text (), widget.value.get_text ());
		this.remove (widget);
	}
	
	internal class Header : Gtk.Box {

		internal signal void append_header (string label, string value);
	
		private const string[] HEADERS = {
			"Accept", "Accept-Charset", "Accept-Encoding", "Accept-Language",
			"Allow", "Authorization", "Cache-Control", "Connection",
			"Content-Encoding", "Content-Language", "Content-Length",
			"Content-Location", "Content-MD5", "Content-Range", "Content-Type",
			"Date", "Expect", "Expires", "From", "Host", "If-Match",
			"If-Modified-Since", "If-None-Match", "If-Range",
			"If-Unmodified-Since", "Last-Modified", "Max-Forwards", "Pragma",
			"Proxy-Authorization", "Range", "Referer", "TE", "Trailer",
			"Transfer-Encoding", "Upgrade", "User-Agent", "Via", "Warning"
		};

		internal Gtk.ComboBoxText label;
		internal Gtk.Entry value;
		internal Gtk.Button actions;

		internal Gtk.Action add_action;
		internal Gtk.Action del_action;
	
		internal Header (Spi.HeaderBox parent) {
			Object (orientation: Gtk.Orientation.HORIZONTAL, spacing: 4);

			Gtk.SizeGroup size_group = new Gtk.SizeGroup (Gtk.SizeGroupMode.VERTICAL);
		
			// Header label combobox
			this.label = new Gtk.ComboBoxText.with_entry ();
			var entry = this.label.get_child () as Gtk.Entry;
			var completion = new Gtk.EntryCompletion ();
			entry.set_completion (completion);
			var list_store = new Gtk.ListStore (1, typeof (string));
			completion.set_model (list_store);
			completion.set_text_column (0);
			Gtk.TreeIter iter;
			foreach (string h in Header.HEADERS) {
				list_store.append (out iter);
				list_store.set (iter, 0, h);
				this.label.append_text (h);
			}
			this.add (this.label);

			// Header value entry
			this.value = new Gtk.Entry ();
			this.value.set_placeholder_text ("value");
			this.add (this.value);
			this.child_set_property (this.value, "expand", true);

			// Add/Del Actions
			this.add_action = new Gtk.Action ("AddAction", "Add",
					"Append a new header to the request", null);
			this.add_action.icon_name = "list-add-symbolic";
			this.del_action = new Gtk.Action ("DelAction", "Remove",
					"Remove the header from the request", null);
			this.del_action.icon_name = "edit-delete-symbolic";
			//this.del_action.activate.connect (this.del_current_header);

			// Header Add/Del button action
			this.actions = new Gtk.Button ();
			this.actions.set_image (new Gtk.Image ());
			this.actions.set_related_action (this.add_action);
			this.actions.set_label (null);
			this.actions.set_state_flags (Gtk.StateFlags.INSENSITIVE, true);
			this.add (this.actions);

			size_group.add_widget (this.label);
			size_group.add_widget (this.value);
			size_group.add_widget (this.actions);

			this.connect_signals (parent);
		}

		private void connect_signals (Spi.HeaderBox parent) {
			this.label.changed.connect (() => {
				this.actions.set_sensitive (this.label.active >= 0
						&& this.value.text_length > 0);
			});
			this.value.changed.connect (() => {
				this.actions.set_sensitive (this.label.active >= 0
						&& this.value.text_length > 0);
			});
			this.add_action.activate.connect (() => {
				parent.prepend_header (this);
			});
			this.del_action.activate.connect (() => {
				parent.remove_header (this);
			});
		}
	}
}
