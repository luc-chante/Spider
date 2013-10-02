/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * spi-request-builder.vala
 * Copyright (C) 2013 Luc Chante <luc.chante@gmail.com>
 *
 */

public class Spi.RequestBuilder : Object {

	public string method { get; private set; }
	public string url { get; private set; }
	private Gee.HashSet<RequestBuilder.Header> headers;
	
	// Constructor
	public RequestBuilder () {
		this.headers = new Gee.HashSet<RequestBuilder.Header> (RequestBuilder.Header.hash, RequestBuilder.Header.equals);
	}

	public void update_method (string method) {
		this.method = method;
	}

	public void update_url (string url) {
		this.url = url;
	}

	public void add_header(string label, string value) {
		this.headers.add (new RequestBuilder.Header (label, value));
	}

	public void del_header(string label, string value) {
		this.headers.remove (new RequestBuilder.Header (label, value));
	}

	public void @foreach (Soup.MessageHeadersForeachFunc iterator) {
		foreach (Header h in this.headers) {
			iterator (h.label, h.value);
		}
	}

	internal class Header : Object {
		public string label { get; construct; }
		public string value { get; construct; }

		public Header (string label, string value) {
			Object (label: label, value: value);
		}

		public string to_string () {
			return string.join (": ", this.label, this.value);
		}

		public static int compare (Header h1, Header h2) {
			return strcmp (h1.to_string (), h2.to_string ());
		}

		public static bool equals (Header h1, Header h2) {
			return Header.compare (h1, h2) == 0;
		}

		public static uint hash (Header h) {
			if (h == null)
				return (uint)0xdeadbeef;
			else
				return str_hash (h.to_string ());
		}
	}
}

