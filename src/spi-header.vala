/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * spi-header.vala
 * Copyright (C) 2013 Luc Chante <luc.chante@gmail.com>
 *
 */

namespace Spi.Header {
	
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

	internal class HeaderCompletion : Gtk.EntryCompletion {
		internal HeaderCompletion () {
			Gtk.ListStore list_store = new Gtk.ListStore (1, typeof (string));
			this.set_model (list_store);
			this.set_text_column (0);
			Gtk.TreeIter iter;
			
			foreach (string h in HEADERS) {
				list_store.append (out iter);
				list_store.set (iter, 0, h);
			}
		}
	}

	public class HeaderList : Gtk.Box {

		// Emitted when a new header is added
		public signal void header_added (string label, string value);
		// Emitted when an header is removed
		public signal void header_removed (string label, string value);
		
		public HeaderList () {
			Object (orientation: Gtk.Orientation.VERTICAL, spacing: 4,
		    		homogeneous: true, margin_left: 5, margin_right: 5);

			this.prepend_header (null);
		}

		public void reset () {
			this.foreach ((child) => {
				this.remove (child);
				this.prepend_header (null);
			});
		}

		internal void prepend_header (Spi.Header.Widget? widget) {
			if (widget != null) {
				widget.sensitive = false;
				this.header_added (widget.label, widget.value);
			}
		
			Spi.Header.Widget header = new Spi.Header.Widget ();
			header.add_header.connect ((h) => {
				this.prepend_header (h);
			});
			header.del_header.connect ((h) => {
				this.remove_header (h);
			});
			this.add (header);
			this.reorder_child (header, 0);
			this.show_all ();
		}

		internal void remove_header (Spi.Header.Widget widget) {
			this.header_removed (widget.label, widget.value);
			this.remove (widget);
		}
	}
	
	internal class Widget : Gtk.Box {

		internal signal void add_header (Spi.Header.Widget widget);
		internal signal void del_header (Spi.Header.Widget widget);

		public string label {
			get { return this.labelWidget.get_active_text (); }
			private set {}
		}
		public string value {
			get { return this.valueWidget.get_value (); }
			private set {}
		}
		private bool _sensitive = true;
		public new bool sensitive {
			get { return this._sensitive; }
			set { this.internal_set_sensitive (value); }
		}
		
		private Gtk.ComboBoxText labelWidget = new Gtk.ComboBoxText.with_entry ();
		private Spi.Header.Value valueWidget;
		private Gtk.Button actions = new Gtk.Button ();
		private ulong click_handler = 0;
		
		internal Widget () {
			Object (orientation: Gtk.Orientation.HORIZONTAL, spacing: 4);

			var completion = new HeaderCompletion ();
			completion.match_selected.connect ((model, iter) => {
				GLib.Value v;
				model.get_value (iter, 0, out v);
				this.labelWidget.active_id = v.get_string ();
				return true;
			});
			(this.labelWidget.get_child () as Gtk.Entry).completion = completion;
			foreach (string h in HEADERS) {
				this.labelWidget.append (h, h);
			}
			this.labelWidget.changed.connect (() => {
				if (this.labelWidget.get_active_text ().length > 0
						&& this.valueWidget.get_value ().length > 0) {
					this.actions.sensitive = true;
				}
				else {
					this.actions.sensitive = false;
				}
			});

			this.valueWidget = new SimpleValue ();
			this.valueWidget.on_changed.connect ((v) => {
				if (this.labelWidget.get_active_text ().length > 0
						&& this.valueWidget.get_value ().length > 0) {
					this.actions.sensitive = true;
				}
				else {
					this.actions.sensitive = false;
				}
			});

			this.click_handler = this.actions.clicked.connect (this.add_header_event);
			this.actions.image = new Gtk.Image.from_icon_name (
						"list-add-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
			this.actions.sensitive = false;

			this.add (this.labelWidget);
			this.add (this.valueWidget);
			this.add (this.actions);
		}

		private void add_header_event () {
			this.add_header (this);
			this.actions.disconnect (this.click_handler);
			this.click_handler = 0;
			this.actions.image = new Gtk.Image.from_icon_name (
					"edit-delete-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
			this.actions.clicked.connect (this.del_header_event);
		}

		private void del_header_event () {
			this.del_header (this);
		}

		private void internal_set_sensitive (bool sensitive) {
			if (!sensitive) {
				this.labelWidget.sensitive = false;
				this.valueWidget.sensitive = false;
				this.actions.sensitive = true;
			}
			else if (this.labelWidget.get_active_text ().length > 0
					&& this.valueWidget.get_value ().length > 0) {
				this.actions.sensitive = true;
			}
			else {
				this.actions.sensitive = false;
			}
		}
	}
	
	internal interface Value : Gtk.Widget {
		internal signal void on_changed (string value);
		internal abstract unowned string get_value ();
	}
	
	internal class SimpleValue : Gtk.Entry, Value {
		
		internal SimpleValue () {
			Object (placeholder_text: "Value", hexpand: true);

			this.changed.connect (() => {
				this.on_changed (this.text);
			});
		}

		internal unowned string get_value () {
			return this.text;
		}
	}
	
}