/* -*- Mode: C; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * main.c
 * Copyright (C) 2013 Luc Chante <luc.chante@gmail.com>
 * 
 */

using Gtk;

public class SpiderApp : Gtk.Application {

	public const string COPYRIGHT = "Copyright (c) 2013 Luc Chante";
	public const string WEBSITE = Config.PACKAGE_URL;
	public const string WEBSITE_LABEL = "GitHub";
	public const string VERSION = Config.VERSION;

	public const string COMMENTS = """
Spider is a gnome developer tool for debugging HTTP services
building graphically complex requests and displaying raw result
""";
	
	public const string[] AUTHORS = {
		"Luc Chante <luc.chante@gmail.com>"
	};
	
	public const string LICENSE = """
This Agreement is a Free Software license agreement that is the result
of discussions between its authors in order to ensure compliance with
the two main principles guiding its drafting:

  * firstly, compliance with the principles governing the distribution
    of Free Software: access to source code, broad rights granted to users,
  * secondly, the election of a governing law, French law, with which it
    is conformant, both as regards the law of torts and intellectual
    property law, and the protection that it offers to both authors and
    holders of the economic rights over software.

The authors of the CeCILL (for Ce[a] C[nrs] I[nria] L[ogiciel] L[ibre]) 
license are: 

Commissariat à l'énergie atomique et aux énergies alternatives - CEA, a
public scientific, technical and industrial research establishment,
having its principal place of business at 25 rue Leblanc, immeuble Le
Ponant D, 75015 Paris, France.

Centre National de la Recherche Scientifique - CNRS, a public scientific
and technological establishment, having its principal place of business
at 3 rue Michel-Ange, 75794 Paris cedex 16, France.

Institut National de Recherche en Informatique et en Automatique -
Inria, a public scientific and technological establishment, having its
principal place of business at Domaine de Voluceau, Rocquencourt, BP
105, 78153 Le Chesnay cedex, France.
""";
	
	public SpiderApp () {
		Object (application_id: Config.PACKAGE_NAME, flags: GLib.ApplicationFlags.FLAGS_NONE);
	}

	protected override void activate () {
		var window = new Spi.Window (this);
		window.show_all();
	}

	protected override void startup () {
		base.startup ();
		
		var menu = new GLib.Menu ();
		menu.append ("About", "win.about");
		menu.append ("Quit", "app.quit");

		this.app_menu = menu;

		var quit_action = new SimpleAction ("quit", null);
		quit_action.activate.connect (quit);
		this.add_action (quit_action);
	}

	static int main (string[] args) {
		Gtk.init (ref args);
		var app = new SpiderApp ();

		return app.run (args);
	}
}
