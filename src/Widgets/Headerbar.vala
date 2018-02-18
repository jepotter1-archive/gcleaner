/* Copyright 2017 Juan Pablo Lozano
*
* This file is part of GCleaner.
*
* GCleaner is free software: you can redistribute it
* and/or modify it under the terms of the GNU General Public License as
* published by the Free Software Foundation, either version 3 of the
* License, or (at your option) any later version.
*
* GCleaner is distributed in the hope that it will be
* useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
* Public License for more details.
*
* You should have received a copy of the GNU General Public License along
* with GCleaner. If not, see http://www.gnu.org/licenses/.
*/

//Importing libraries GTK+ and GLib
using Gtk;
using GLib;

namespace GCleaner.Widgets
{
	public class Header : HeaderBar
	{

		public GCleaner.App app;

		//ACTIONS CALLBACKS HERE
		void about_cb (SimpleAction simple, Variant? parameter) {
			var about = new GCleaner.Widgets.About ();
			about.run ();
		}

		public Header (GCleaner.App app)
		{
			this.app = app;

			//Variables
			string complete_system_specs;

			//GCleaner icon
			Image icon = new Image ();
			try
			{
				var icon_pixbuf = new Gdk.Pixbuf.from_file_at_scale ("/usr/share/pixmaps/gcleanerhb.svg", 32, 32, false);
				icon.set_from_pixbuf (icon_pixbuf);
			  } catch (GLib.Error e) {
				stderr.printf ("COM.GCLEANER.APP.HEADERBAR: [GLIB::ERROR CREATING PIXBUF ICON]\n");
				stderr.printf (">>> Check path: /usr/share/pixmaps/gcleanerhb.svg\n");
			}

			complete_system_specs = getProcessor () + "  •  " + getMemory () + " RAM  •  " + getGraphics ();

			//LABELS WITH PANGO MARKUP
			Label title = new Label ("");
			title.set_markup ("<b>GCleaner</b>");
			
			Label version = new Label ("");
			version.set_markup ("<small>v" + Constants.VERSION + "</small>");

			Label os_information = new Label ("");
			os_information.set_markup ("<span>" + getOS () + "</span>");//font_size='small' by default

			Label system_specs = new Label ("");
			system_specs.set_markup ("<span font_size='small'>" + complete_system_specs + "</span>");


			/*
			 * Here, first we create an Image and then add
			 * this image to MenuButton and resize it.
			 */
			var appmenu_button = new Gtk.MenuButton();
			Gtk.Image gear_icon = new Gtk.Image ();
			gear_icon.set_from_icon_name ("open-menu", Gtk.IconSize.LARGE_TOOLBAR);
			appmenu_button.set_image (gear_icon);
			appmenu_button.get_style_context ().add_class("about_btn");

			/*
			 * Here define an Menu Model and
			 * add it to appmenu Button.
			 */
			var menumodel = new GLib.Menu ();
			menumodel.append ("About...", "win.about");
			appmenu_button.set_menu_model (menumodel);

			/*
			 * Here we define the Actions.
			 */
			var about_action = new SimpleAction ("about", null);
			about_action.activate.connect (this.about_cb);
			this.app.main_window.add_action (about_action);

			//BOXES
			/* to assemble the header */
			Box container_box 	= new Box (Orientation.HORIZONTAL, 4);
			Box nameVersion_box = new Box (Orientation.VERTICAL, 0);
			Box specsOS_box 	= new Box (Orientation.VERTICAL, 0);

			//Cajas por elementos
			Box icon_box 	= new Box (Orientation.HORIZONTAL, 0);
			Box app_box 	= new Box (Orientation.HORIZONTAL, 0);
			Box version_box = new Box (Orientation.HORIZONTAL, 0);
			Box os_box 		= new Box (Orientation.HORIZONTAL, 0);
			Box specs_box 	= new Box (Orientation.HORIZONTAL, 0);

			//PACKAGING
			/* Packaging widgets */
			icon_box.pack_start (icon, false, true, 0);
			app_box.pack_start (title, false, true, 0);
			version_box.pack_start (version, false, true, 0);
			os_box.pack_start (os_information, false, true, 0);
			specs_box.pack_start (system_specs, false, true, 0);

			/* Packaging boxes */
			nameVersion_box.pack_start (app_box, false, true, 0);
			nameVersion_box.pack_start (version_box, false, true, 0);
			specsOS_box.pack_start (os_box, false, true, 0);
			specsOS_box.pack_start (specs_box, false, true, 0);
			container_box.pack_start (icon_box, false, true, 6);
			container_box.pack_start (nameVersion_box, false, true, 6);
			container_box.pack_start (specsOS_box, false, true, 6);


			ToolItem item = new ToolItem ();
			item.add (container_box);


			/* HeaderBar properties */
			this.pack_start (item);
			this.pack_end (appmenu_button);
			this.set_show_close_button (true);

			this.show_all ();
		}	
	}
}
