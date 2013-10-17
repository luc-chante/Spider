/* -*- Mode: vala; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * spi-header.vala
 * Copyright (C) 2013 Luc Chante <luc.chante@gmail.com>
 *
 */

namespace Spi.Header {

	internal abstract class ValueCompletion : Gtk.EntryCompletion {
		public string? placeholder_text { get; construct; }
	}

	internal class AcceptCharsetCompletion : ValueCompletion {
		internal AcceptCharsetCompletion () {
			Object (placeholder_text: "Acceptable Characters Sets");
		}
	}
	
	internal class CacheControlCompletion : ValueCompletion {
		internal CacheControlCompletion () {
			Object (placeholder_text: "Cache Directive");
			
			Gtk.ListStore list_store = new Gtk.ListStore (1, typeof (string));
			this.set_model (list_store);
			this.set_text_column (0);
			Gtk.TreeIter iter;

			list_store.append (out iter);
			list_store.set (iter, 0, "no-cache");
			list_store.append (out iter);
			list_store.set (iter, 0, "no-store");
			list_store.append (out iter);
			list_store.set (iter, 0, "max-age=");
			list_store.append (out iter);
			list_store.set (iter, 0, "max-stale");
			list_store.append (out iter);
			list_store.set (iter, 0, "min-fresh");
			list_store.append (out iter);
			list_store.set (iter, 0, "no-transform");
			list_store.append (out iter);
			list_store.set (iter, 0, "only-if-cached");
		}
	}

	internal class UserAgentCompletion : ValueCompletion {
		internal UserAgentCompletion () {
			Object (placeholder_text: "Auto-Completion with 'Android ...', 'Windows ...', ...");

			Gtk.ListStore list_store = new Gtk.ListStore (2, typeof (string), typeof (string));
			this.set_model (list_store);
			this.set_text_column (1);
			Gtk.TreeIter iter;

			list_store.append (out iter);
			list_store.set (iter, 0, "Mozilla/5.0 (Linux; Android 4.3; Nexus 4 Build/JWR66Y) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.111 Mobile Safari/537.36", 1, "Android - Google Nexus 4");
			list_store.append (out iter);
			list_store.set (iter, 0, "Mozilla/5.0 (Linux; Android 4.3; Nexus 4 Build/JWR66Y) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.111 Mobile Safari/537.36", 1, "Google Nexus 4");
			list_store.append (out iter);
			list_store.set (iter, 0, "Mozilla/5.0 (Linux; Android 4.1.1; Nexus 7 Build/JRO03D) AppleWebKit/535.19 (KHTML, like Gecko) Chrome/18.0.1025.166 Safari/535.19", 1, "Android - Google Nexus 7");
			list_store.append (out iter);
			list_store.set (iter, 0, "Mozilla/5.0 (Linux; Android 4.1.1; Nexus 7 Build/JRO03D) AppleWebKit/535.19 (KHTML, like Gecko) Chrome/18.0.1025.166 Safari/535.19", 1, "Google Nexus 7");
			list_store.append (out iter);
			list_store.set (iter, 0, "Mozilla/5.0 (Linux; U; Android 2.1-update1; de-de; HTC Desire 1.19.161.5 Build/ERE27) AppleWebKit/530.17 (KHTML, like Gecko) Version/4.0 Mobile Safari/530.17", 1, "Android - HTC Desire");
			list_store.append (out iter);
			list_store.set (iter, 0, "Mozilla/5.0 (Linux; U; Android 2.1-update1; de-de; HTC Desire 1.19.161.5 Build/ERE27) AppleWebKit/530.17 (KHTML, like Gecko) Version/4.0 Mobile Safari/530.17", 1, "HTC Desire");
			list_store.append (out iter);
			list_store.set (iter, 0, "Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Firefox/24.0", 1, "Linux - Firefox 24.0 x64");
			list_store.append (out iter);
			list_store.set (iter, 0, "Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Firefox/24.0", 1, "Firefox 24.0 (Linux x64)");
			list_store.append (out iter);
			list_store.set (iter, 0, "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.43 Safari/537.31", 1, "Linux - Google Chrome 26.0 x64");
			list_store.append (out iter);
			list_store.set (iter, 0, "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.43 Safari/537.31", 1, "Google Chrome 26.0 (Linux x64)");
			list_store.append (out iter);
			list_store.set (iter, 0, "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.32 (KHTML, like Gecko) Chromium/25.0.1349.2 Chrome/25.0.1349.2 Safari/537.32 Epiphany/3.8.2", 1, "Linux - Epiphany 3.8.2 x64");
			list_store.append (out iter);
			list_store.set (iter, 0, "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.32 (KHTML, like Gecko) Chromium/25.0.1349.2 Chrome/25.0.1349.2 Safari/537.32 Epiphany/3.8.2", 1, "Epiphany 3.8.2 (Linux x64)");
			list_store.append (out iter);
			list_store.set (iter, 0, "Lynx/2.8.6rel.5 libwww-FM/2.14 SSL-MM/1.4.1 OpenSSL/0.9.8g", 1, "Linux - Lynx 2.8.6");
			list_store.append (out iter);
			list_store.set (iter, 0, "Lynx/2.8.6rel.5 libwww-FM/2.14 SSL-MM/1.4.1 OpenSSL/0.9.8g", 1, "Lynx 2.8.6 (Linux)");
			list_store.append (out iter);
			list_store.set (iter, 0, "Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; WOW64; Trident/6.0)", 1, "Windows 7 - IE 10.0");
			list_store.append (out iter);
			list_store.set (iter, 0, "Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; WOW64; Trident/6.0)", 1, "IE 10.0 (Windows 7)");
			list_store.append (out iter);
			list_store.set (iter, 0, "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/5.0; SLCC2; Media Center PC 6.0; InfoPath.3; MS-RTC LM 8; Zune 4.7)", 1, "Windows 7 - IE 9.0");
			list_store.append (out iter);
			list_store.set (iter, 0, "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/5.0; SLCC2; Media Center PC 6.0; InfoPath.3; MS-RTC LM 8; Zune 4.7)", 1, "IE 9.0 (Windows 7)");
			list_store.append (out iter);
			list_store.set (iter, 0, "Mozilla/5.0 (compatible; MSIE 8.0; Windows NT 6.0; Trident/4.0; WOW64; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; .NET CLR 1.0.3705; .NET CLR 1.1.4322)", 1, "Windows Vista - IE 8.0");
			list_store.append (out iter);
			list_store.set (iter, 0, "Mozilla/5.0 (compatible; MSIE 8.0; Windows NT 6.0; Trident/4.0; WOW64; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; .NET CLR 1.0.3705; .NET CLR 1.1.4322)", 1, "IE 8.0 (Windows Vista)");
			list_store.append (out iter);
			list_store.set (iter, 0, "Mozilla/5.0 (compatible; MSIE 10.0; Windows Phone 8.0; Trident/6.0; IEMobile/10.0; ARM; Touch; NOKIA; Lumia 820)", 1, "Windows Phone 8 - IE Mobile 10.0");
			list_store.append (out iter);
			list_store.set (iter, 0, "Mozilla/5.0 (compatible; MSIE 10.0; Windows Phone 8.0; Trident/6.0; IEMobile/10.0; ARM; Touch; NOKIA; Lumia 820)", 1, "IE Mobile 10.0 (Windows Phone 8)");
			list_store.append (out iter);
			list_store.set (iter, 0, "Mozilla/5.0 (compatible; MSIE 9.0; Windows Phone OS 7.5; Trident/5.0; IEMobile/9.0)", 1, "Windows Phone 7.5 - IE Mobile 9.0");
			list_store.append (out iter);
			list_store.set (iter, 0, "Mozilla/5.0 (compatible; MSIE 9.0; Windows Phone OS 7.5; Trident/5.0; IEMobile/9.0)", 1, "IE Mobile 9.0 (Windows Phone 7.5)");
			list_store.append (out iter);
			list_store.set (iter, 0, "Mozilla/5.0 (iPad; CPU OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5355d Safari/8536.25", 1, "Apple - iPad");
			list_store.append (out iter);
			list_store.set (iter, 0, "Mozilla/5.0 (iPad; CPU OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5355d Safari/8536.25", 1, "iPad");
			list_store.append (out iter);
			list_store.set (iter, 0, "Mozilla/5.0 (iPad; CPU OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5355d Safari/8536.25", 1, "Safari - iPad");
			list_store.append (out iter);
			list_store.set (iter, 0, "Mozilla/5.0 (iPhone; CPU iPhone OS 5_0 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9A334 Safari/7534.48.3", 1, "Apple - iPhone 5");
			list_store.append (out iter);
			list_store.set (iter, 0, "Mozilla/5.0 (iPhone; CPU iPhone OS 5_0 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9A334 Safari/7534.48.3", 1, "iPhone 5");
			list_store.append (out iter);
			list_store.set (iter, 0, "Mozilla/5.0 (iPhone; CPU iPhone OS 5_0 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9A334 Safari/7534.48.3", 1, "Safari - iPhone 5");
			list_store.append (out iter);
			list_store.set (iter, 0, "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/537.13+ (KHTML, like Gecko) Version/5.1.7 Safari/534.57.2", 1, "Apple - Snow Leopard Safari 5.1.7");
			list_store.append (out iter);
			list_store.set (iter, 0, "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/537.13+ (KHTML, like Gecko) Version/5.1.7 Safari/534.57.2", 1, "Safari - Snow Leopard");
		}
	}
}