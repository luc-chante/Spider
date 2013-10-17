/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * spi-header-label-widget.vala
 * Copyright (C) 2013 Luc Chante <luc.chante@gmail.com>
 *
 */

internal class Spi.Header.LabelWidget : Gtk.ComboBox {

	internal signal void on_header_selected (ValueCompletion? completion);
	
	// Constructor
	public LabelWidget () {
		Object (has_entry: true, id_column: 0, entry_text_column: 0);

		var list_store = new Gtk.ListStore (2, typeof (string), typeof (ValueCompletion?));
		Gtk.TreeIter iter;

		foreach (HeaderStruct header in HEADERS) {
			string label = header.label;
			ValueCompletion? completion = header.completion;

			list_store.append(out iter);
			list_store.set(iter, 0, label, 1, completion);
		}
		this.model = list_store;
		this.changed.connect (() => {
			Value v;
			Gtk.TreeIter i;

			this.get_active_iter(out i);
			this.model.get_value (i, 1, out v);
			this.on_header_selected (v.get_object () as ValueCompletion?);
		});

		var entry = this.get_child () as Gtk.Entry;
		var completion = entry.completion = new Gtk.EntryCompletion ();
		completion.model = list_store;
		completion.text_column = 0;
		completion.match_selected.connect ((model, iter) => {
			Value v;
			model.get_value (iter, 0, out v);
			this.active_id = v.get_string ();
			model.get_value (iter, 1, out v);
			this.on_header_selected (v.get_object () as ValueCompletion?);
			return true;
		});
	}

	internal struct HeaderStruct {
		public string label;
		public ValueCompletion? completion;
	}
	
	private static HeaderStruct[] HEADERS = {
			HeaderStruct () { label = "Accept",              completion = null },
			HeaderStruct () { label = "Accept-Charset",      completion = new AcceptCharsetCompletion () },
			HeaderStruct () { label = "Accept-Encoding",     completion = null },
			HeaderStruct () { label = "Accept-Language",     completion = null },
			HeaderStruct () { label = "Allow",               completion = null },
			HeaderStruct () { label = "Authorization",       completion = null },
			HeaderStruct () { label = "Cache-Control",       completion = new CacheControlCompletion () },
			HeaderStruct () { label = "Connection",          completion = null },
			HeaderStruct () { label = "Content-Encoding",    completion = null },
			HeaderStruct () { label = "Content-Language",    completion = null },
			HeaderStruct () { label = "Content-Length",      completion = null },
			HeaderStruct () { label = "Content-Location",    completion = null },
			HeaderStruct () { label = "Content-MD5",         completion = null },
			HeaderStruct () { label = "Content-Range",       completion = null },
			HeaderStruct () { label = "Content-Type",        completion = null },
			HeaderStruct () { label = "Date",                completion = null },
			HeaderStruct () { label = "Expect",              completion = null },
			HeaderStruct () { label = "Expires",             completion = null },
			HeaderStruct () { label = "From",                completion = null },
			HeaderStruct () { label = "Host",                completion = null },
			HeaderStruct () { label = "If-Match",            completion = null },
			HeaderStruct () { label = "If-Modified-Since",   completion = null },
			HeaderStruct () { label = "If-None-Match",       completion = null },
			HeaderStruct () { label = "If-Range",            completion = null },
			HeaderStruct () { label = "If-Unmodified-Since", completion = null },
			HeaderStruct () { label = "Last-Modified",       completion = null },
			HeaderStruct () { label = "Max-Forwards",        completion = null },
			HeaderStruct () { label = "Pragma",              completion = null },
			HeaderStruct () { label = "Proxy-Authorization", completion = null },
			HeaderStruct () { label = "Range",               completion = null },
			HeaderStruct () { label = "Referer",             completion = null },
			HeaderStruct () { label = "TE",                  completion = null },
			HeaderStruct () { label = "Trailer",             completion = null },
			HeaderStruct () { label = "Transfer-Encoding",   completion = null },
			HeaderStruct () { label = "Upgrade",             completion = null },
			HeaderStruct () { label = "User-Agent",          completion = new UserAgentCompletion () },
			HeaderStruct () { label = "Via",                 completion = null },
			HeaderStruct () { label = "Warning",             completion = null }};
}

