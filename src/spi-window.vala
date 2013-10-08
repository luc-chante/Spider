/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * spi-window.vala
 * Copyright (C) 2013 Luc Chante <luc.chante@gmail.com>
 *
 */

public class Spi.Window : Gtk.ApplicationWindow {

	private Spi.Toolbar toolbar = new Spi.Toolbar ();
	private Spi.HeaderBox headers = new Spi.HeaderBox ();
	private Gtk.TextView body = new Gtk.TextView ();
	private Gtk.SourceView response_header;
	private Gtk.SourceView response_body = new Gtk.SourceView ();

	private Spi.RequestBuilder builder = new Spi.RequestBuilder ();

	private Soup.Session session = new Soup.Session ();
	private Soup.Message message = null;

	private Mutex locker = Mutex ();
	
	// Constructor
	public Window (Gtk.Application application) {
		Object (application: application, title: "Spider HTTP Client",
		        hide_titlebar_when_maximized: true);
		this.set_default_size (750, 900);

		var about_action = new SimpleAction ("about", null);
		about_action.activate.connect (this.on_about);
		this.add_action (about_action);
		
		Gtk.Box container = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);

		var lm = Gtk.SourceLanguageManager.get_default ();
		var l = lm.get_language ("ini");
		var b = new Gtk.SourceBuffer.with_language (l);
		this.response_header = new Gtk.SourceView.with_buffer (b);
		this.response_header.set_editable (false);
		var sw1 = new Gtk.ScrolledWindow (null, null);
		sw1.add (this.response_header);
		sw1.vscrollbar_policy = Gtk.PolicyType.NEVER;

		this.response_body.set_editable (false);
		var sw2 = new Gtk.ScrolledWindow (null, null);
		sw2.add (this.response_body);

		container.add (this.toolbar);
		container.add (new Gtk.Label ("Request"));
		container.add (this.headers);
		container.add (this.body);
		container.add (new Gtk.Label ("Response"));
		container.add (sw1);
		container.add (sw2);
		container.child_set_property (sw2, "expand", true);
		
		this.add(container);
		this.connect_signals ();

		this.session.add_feature_by_type (typeof (Soup.ProxyResolverDefault));

		this.toolbar.init ();
	}

	private void connect_signals () {
		this.toolbar.method_changed.connect (this.builder.update_method);
		this.toolbar.method_changed.connect ((method) => {
			if (method == "GET") {
				this.body.set_visible (false);
			}
			else {
				this.body.set_visible (true);
			}
		});
		this.toolbar.location_changed.connect (this.builder.update_url);
		this.headers.header_added.connect (this.builder.add_header);
		this.headers.header_removed.connect (this.builder.del_header);
		this.toolbar.activate.connect (this.send);
		this.toolbar.cancel.connect (this.cancel);
	}

	private bool send () {
		if (this.locker.trylock () && this.message == null) {
			this.toolbar.set_cancel_enable (true);
			this.message = new Soup.Message (this.builder.method, this.builder.url);
			this.builder.foreach ((k, v) => {
				unowned string key = (string) k;
				unowned string val = (string) v;
				this.message.request_headers.append (key, val);
			});
			this.session.queue_message (this.message, this.receive);
			this.locker.unlock ();
			return true;
		}
		return false;
	}

	private bool cancel () {
		if (this.locker.trylock () && this.message != null) {
			this.toolbar.set_cancel_enable (false);
			this.session.cancel_message (this.message, (uint)Soup.KnownStatusCode.CANCELLED);
			this.message = null;
			this.locker.unlock ();
			return true;
		}
		
		return false;
	}

	private void receive (Soup.Session session, Soup.Message msg) {
		this.toolbar.set_cancel_enable (false);
		var iter = Gtk.TextIter ();
		string type = null;
		StringBuilder sb = new StringBuilder.sized (1024);
		
		sb.assign ("HTTP/1.").append_printf ("%d %u %s", msg.http_version, msg.status_code, msg.reason_phrase);		
		this.response_header.buffer.text = sb.str;

		msg.response_headers.foreach ((k, v) => {
			if (k.ascii_casecmp ("content-type") == 0) {
				if (v.index_of_char (';') > -1) {
					type = v.substring (0, v.index_of_char (';'));
				}
				else {
					type = v;
				}
			}
			sb.assign ("\n").append_printf ("%s: %s", k, v);
			this.response_header.buffer.get_end_iter (out iter);
			this.response_header.buffer.insert (ref iter, sb.str, (int)sb.len);
		});

		var b = this.response_body.buffer as Gtk.SourceBuffer;
		
		if (type == null) {
			b.set_language (null);
		}
		else {
			var lm = Gtk.SourceLanguageManager.get_default ();
			var l = lm.guess_language (null, type);
			b.set_language (l);
			b.set_highlight_syntax (l != null);
		}

		this.response_body.buffer.text = (string)msg.response_body.data;
		this.message = null;
	}

	private void on_about (SimpleAction simple, Variant? parameter) {
        Gtk.show_about_dialog(this,
            "program-name", "Spider",
            "authors", SpiderApp.AUTHORS,
            "copyright", SpiderApp.COPYRIGHT,
            "license", SpiderApp.LICENSE,
            "version", SpiderApp.VERSION,
            "website", SpiderApp.WEBSITE,
            "website-label", SpiderApp.WEBSITE_LABEL,
            "comments", SpiderApp.COMMENTS,
            "title", "About Spider"
        );
	}
}
