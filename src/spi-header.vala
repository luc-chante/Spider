/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * spi-header.vala
 * Copyright (C) 2013 Luc Chante <luc.chante@gmail.com>
 *
 */

namespace Spi.Header {

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
			get { return this.labelWidget.active_id; }
			private set {}
		}
		public string value {
			get { return this.valueWidget.text; }
			private set {}
		}
		private bool _sensitive = true;
		public new bool sensitive {
			get { return this._sensitive; }
			set { this.internal_set_sensitive (value); }
		}
		
		private Spi.Header.LabelWidget labelWidget = new Spi.Header.LabelWidget ();
		private Gtk.Entry valueWidget = new Gtk.Entry ();
		private Gtk.Button actions = new Gtk.Button ();
		private ulong click_handler = 0;
		private ulong completion_handler = 0;
		
		internal Widget () {
			Object (orientation: Gtk.Orientation.HORIZONTAL, spacing: 4);

			this.labelWidget.changed.connect (() => {
				if (this.labelWidget.active_id != null
						&& this.labelWidget.active_id.length > 0
						&& this.valueWidget.text.length > 0) {
					this.actions.sensitive = true;
				}
				else {
					this.actions.sensitive = false;
				}
			});
			this.labelWidget.on_header_selected.connect ((completion) => {
				if (this.completion_handler > 0) {
					this.valueWidget.completion.disconnect (this.completion_handler);
					this.completion_handler = 0;
				}
				if (completion == null) {
					this.valueWidget.completion = null;
					this.valueWidget.placeholder_text = "Header Value";
				}
				else {
					this.valueWidget.completion = completion;
					this.completion_handler = completion.match_selected.connect ((model, iter) => {
						Value v;
						model.get_value (iter, 0, out v);
						this.valueWidget.text = v.get_string ();
						return true;
					});
					this.valueWidget.placeholder_text = completion.placeholder_text;
				}
			});

			this.valueWidget.changed.connect ((v) => {
				if (this.labelWidget.active_id != null
						&& this.labelWidget.active_id.length > 0
						&& this.valueWidget.text.length > 0) {
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
			this.child_set_property (this.valueWidget, "expand", true);
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
			else if (this.labelWidget.active_id != null
						&& this.labelWidget.active_id.length > 0
					&& this.valueWidget.text.length > 0) {
				this.actions.sensitive = true;
			}
			else {
				this.actions.sensitive = false;
			}
		}
	}
}