/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * spi-window.vala
 * Copyright (C) 2013 Luc Chante <luc.chante@gmail.com>
 *
 */

public class Spi.Window : Gtk.ApplicationWindow {

	private Spi.Toolbar toolbar;
	private Spi.HeaderBox headers;
	private Gtk.TextView body;
	private Gtk.TextView response_header;
	private Gtk.SourceView response_body;

	private Spi.RequestBuilder builder;

	private Soup.Session session;
	private Soup.Message message;

	private Mutex locker;
	
	// Constructor
	public Window (Gtk.Application application) {
		Object (application: application, title: "Spider HTTP Client",
		        hide_titlebar_when_maximized: true);
		this.set_default_size (750, 900);

		this.locker = Mutex ();
			
		this.builder = new Spi.RequestBuilder ();
		
		Gtk.Box container = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);

		this.toolbar = new Spi.Toolbar ();
		container.add (this.toolbar);

		container.add (new Gtk.Label ("Request"));
		
		this.headers = new Spi.HeaderBox ();
		container.add (this.headers);

		this.body = new Gtk.TextView ();
		container.add (this.body);

		container.add (new Gtk.Label ("Response"));

		this.response_header = new Gtk.TextView ();
		this.response_header.set_editable (false);
		var sw = new Gtk.ScrolledWindow (null, null);
		sw.add (this.response_header);
		sw.vscrollbar_policy = Gtk.PolicyType.NEVER;
		container.add (sw);

		var lm = Gtk.SourceLanguageManager.get_default ();
		var l = lm.get_language ("html");
		var b = new Gtk.SourceBuffer.with_language (l);
		this.response_body = new Gtk.SourceView.with_buffer (b);
		this.response_body.set_editable (false);
		sw = new Gtk.ScrolledWindow (null, null);
		sw.add (this.response_body);
		container.add (sw);
		container.child_set_property (sw, "expand", true);
		
		this.add(container);
		this.connect_signals ();

		this.session = new Soup.Session ();
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
			this.session.cancel_message (this.message, (uint)Soup.KnownStatusCode.CANCELLED);
			this.message = null;
			this.locker.unlock ();
			return true;
		}
		
		return false;
	}

	private void receive (Soup.Session session, Soup.Message msg) {
		var iter = Gtk.TextIter ();
		string type = "html";
		StringBuilder sb = new StringBuilder.sized (1024);
		
		sb.assign ("HTTP/1.").append_printf ("%d %u %s", msg.http_version, msg.status_code, msg.reason_phrase);		
		this.response_header.buffer.text = sb.str;

		msg.response_headers.foreach ((k, v) => {
			if (k.ascii_casecmp ("content-type") == 0) {
				type = v;
			}
			sb.assign ("\n").append_printf ("%s: %s", k, v);
			this.response_header.buffer.get_end_iter (out iter);
			this.response_header.buffer.insert (ref iter, sb.str, (int)sb.len);
		});

		var b = this.response_body.buffer as Gtk.SourceBuffer;
		if (type.has_prefix ("text/")) {
			var lm = Gtk.SourceLanguageManager.get_default ();
			var l = lm.get_language (type.substring (5));
			b.set_language (l);
			b.set_highlight_syntax (l != null);
		}
		else {
			b.set_language (null);
		}

		this.response_body.buffer.text = (string)msg.response_body.data;
		this.message = null;
	}
}
