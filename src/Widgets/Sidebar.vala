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
	public class Sidebar : Box
	{
		public GCleaner.App app;

		//CHECKBUTTONS
		public CheckButton check_firefox	= new CheckButton ();//Creamos un CheckBox simple   [ ] Opcion del Check
		public CheckButton check_chrome		= new CheckButton ();
		public CheckButton check_midori		= new CheckButton ();
		public CheckButton check_flash		= new CheckButton ();
		public CheckButton check_packages	= new CheckButton ();
		public CheckButton check_trash		= new CheckButton ();
		public CheckButton check_docsRecent	= new CheckButton ();
		public CheckButton check_terminal	= new CheckButton ();
		public CheckButton check_kernel		= new CheckButton ();

		public Sidebar (GCleaner.App app)
		{
			this.app = app;

			//BOXES
			Box sidebar_box = new Box (Orientation.VERTICAL, 0);//Caja que contendra los CheckBox de las diferentes areas a limpiar
			Box usual_box	= new Box (Orientation.HORIZONTAL, 0);
			Box others_box	= new Box (Orientation.HORIZONTAL, 0);

			/*
			 * Fixed is a container (a kind of BOX) which can place other
			 * Widgets children in fixed positions and size in pixels.
			 */
			Fixed fix = new Fixed ();
			fix.add (sidebar_box);

			sidebar_box.border_width = 12;//Value specified in the HIG (Human Interface Guidelines) of Elementary OS
			this.add (fix);//Only the Box is added where the Fixed (fix) is adapted to the Box


			//LABELS
			Label category_systems_label = new Label ("");
			category_systems_label.set_markup ("<b>USUALES</b>");

			Label category_others_label = new Label ("");
			category_others_label.set_markup ("<b>OTROS</b>");

			//SEPARATORS
			Label category_separator = new Label ("  ");


			//APPLICATIONS CHECKBOX
			//Checkbox Firefox  **************************************
			Image firefox_icon = new Image ();//We create an Image
			try
			{
				var firefox_pixbuf = new Gdk.Pixbuf.from_file_at_scale ("/usr/share/gcleaner/media/firefox16.png", 16, 16, false);//Put the icon on a Pixbuf
				firefox_icon.set_from_pixbuf (firefox_pixbuf);//Set the icon with the previous Pixbuf
			  } catch (GLib.Error e) {
				stderr.printf ("COM.GCLEANER.APP.SIDEBAR: [GLIB::ERROR CREATING PIXBUF ICON]\n");
				stderr.printf (">>> Check path: /usr/share/gcleaner/media/firefox16.png\n");
			}
			//----- Checkbox packaging
			Box firefox_box = new Box (Orientation.HORIZONTAL, 0);//We create a box to put both the icon and the Label
			Label firefox_label = new Label ("Mozilla Firefox");
			firefox_box.pack_start (firefox_icon, false, false, 4);//We package the Icon
			firefox_box.pack_start (firefox_label, false, false, 0);//We package the Label
			check_firefox.add (firefox_box);//Finally we add the box with Icon and Label to a Checkbox

			//Checkbox Chrome  ***************************************
			Image chrome_icon = new Image ();
			try
			{
				var chrome_pixbuf = new Gdk.Pixbuf.from_file_at_scale ("/usr/share/gcleaner/media/chrome16.png", 16, 16, false);
				chrome_icon.set_from_pixbuf (chrome_pixbuf);
			  } catch (GLib.Error e) {
				stderr.printf ("COM.GCLEANER.APP.SIDEBAR: [GLIB::ERROR CREATING PIXBUF ICON]\n");
				stderr.printf (">>> Check path: /usr/share/gcleaner/media/chrome16.png\n");
			}
			Box chrome_box = new Box (Orientation.HORIZONTAL, 0);
			Label chrome_label = new Label ("Google Chrome");
			chrome_box.pack_start (chrome_icon, false, false, 4);
			chrome_box.pack_start (chrome_label, false, false, 0);
			check_chrome.add (chrome_box);

			//Checkbox Midori  ***************************************
			Image midori_icon = new Image ();
			midori_icon.set_from_icon_name ("midori", Gtk.IconSize.MENU);
			Box midori_box = new Box (Orientation.HORIZONTAL, 0);
			Label midori_label = new Label ("Midori");
			midori_box.pack_start (midori_icon, false, false, 4);
			midori_box.pack_start (midori_label, false, false, 0);
			check_midori.add (midori_box);

			//Checkbox Flash Player  *********************************
			Image flash_icon = new Image ();
			try
			{
				var flash_pixbuf = new Gdk.Pixbuf.from_file_at_scale ("/usr/share/gcleaner/media/flash16.png", 16, 16, false);
				flash_icon.set_from_pixbuf (flash_pixbuf);
			  } catch (GLib.Error e) {
				stderr.printf ("COM.GCLEANER.APP.SIDEBAR: [GLIB::ERROR CREATING PIXBUF ICON]\n");
				stderr.printf (">>> Check path: /usr/share/gcleaner/media/flash16.png\n");
			}
			Box flash_box = new Box (Orientation.HORIZONTAL, 0);
			Label flash_label = new Label ("Flash Player");
			flash_box.pack_start (flash_icon, false, false, 4);
			flash_box.pack_start (flash_label, false, false, 0);
			check_flash.add (flash_box);

			//Checkbox Packages  *************************************
			Image package_icon = new Image ();
			package_icon.set_from_icon_name ("application-x-deb", Gtk.IconSize.MENU);
			Box package_box = new Box (Orientation.HORIZONTAL, 0);
			Label package_label = new Label ("Paquetes");
			package_box.pack_start (package_icon, false, false, 4);
			package_box.pack_start (package_label, false, false, 0);
			check_packages.add (package_box);

			//Checkbox Trash  *************************************
			Image trash_icon = new Image ();
			trash_icon.set_from_icon_name ("user-trash", Gtk.IconSize.MENU);
			Box trash_box = new Box (Orientation.HORIZONTAL, 0);
			Label trash_label = new Label ("Papelera");
			trash_box.pack_start (trash_icon, false, false, 4);
			trash_box.pack_start (trash_label, false, false, 0);
			check_trash.add (trash_box);

			//Checkbox Recent Documents *************************
			Image docsRecent_icon = new Image ();
			docsRecent_icon.set_from_icon_name ("document-open-recent", Gtk.IconSize.MENU);
			Box docsRecent_box = new Box (Orientation.HORIZONTAL, 0);
			Label docsRecent_label = new Label ("Documentos Recientes");
			docsRecent_box.pack_start (docsRecent_icon, false, false, 4);
			docsRecent_box.pack_start (docsRecent_label, false, false, 0);
			check_docsRecent.add (docsRecent_box);

			//Checkbox Terminal  *************************
			Image terminal_icon = new Image ();
			terminal_icon.set_from_icon_name ("utilities-terminal", Gtk.IconSize.MENU);
			Box terminal_box = new Box (Orientation.HORIZONTAL, 0);
			Label terminal_label = new Label ("Terminal");
			terminal_box.pack_start (terminal_icon, false, false, 4);
			terminal_box.pack_start (terminal_label, false, false, 0);
			check_terminal.add (terminal_box);

			//Checkbox Kernel *************************
			Image kernel_icon = new Image ();
			kernel_icon.set_from_icon_name ("document-properties", Gtk.IconSize.MENU);
			Box kernel_box = new Box (Orientation.HORIZONTAL, 0);
			Label kernel_label = new Label ("Kernels Antiguos");
			kernel_box.pack_start (kernel_icon, false, false, 4);
			kernel_box.pack_start (kernel_label, false, false, 0);
			check_kernel.add (kernel_box);

			//PACKAGING CHECKBOX
			usual_box.pack_start (category_systems_label, false, true, 0);
			others_box.pack_start (category_others_label, false, true, 0);

			sidebar_box.pack_start (usual_box, false, true, 2);

			//FIREFOX CHECKBOX - CHECK IF EXISTS AND ADD IT
			File firefox_file = File.new_for_path ("/usr/bin/firefox");
			if (firefox_file.query_exists ())
			{
				sidebar_box.pack_start (check_firefox, true, true, 2);
				check_firefox.set_active (this.app.settings.get_boolean ("analyzefirefox"));
				} else {
					check_firefox.set_active (false);
				}

			//GOOGLE CHROME CHECKBOX - CHECK IF EXISTS AND ADD IT
			File chrome_file = File.new_for_path ("/usr/bin/google-chrome-stable");
			File chrome_file_alt = File.new_for_path ("/usr/bin/google-chrome");
			if (chrome_file.query_exists () || chrome_file_alt.query_exists ())
			{
				sidebar_box.pack_start (check_chrome, true, true, 2);
				check_chrome.set_active (this.app.settings.get_boolean ("analyzechrome"));
				} else {
					check_chrome.set_active (false);
				}

			//MIDORI CHECKBOX - CHECK IF EXISTS AND ADD IT
			File midori_file = File.new_for_path ("/usr/bin/midori");
			if (midori_file.query_exists ())
			{
				sidebar_box.pack_start (check_midori, true, true, 2);
				check_midori.set_active (this.app.settings.get_boolean ("analyzemidori"));
				} else {
					check_midori.set_active (false);
				}
			
			//FLASH PLAYER CHECKBOX - CHECK IF EXISTS AND ADD IT
			File flash_ubuntu_file = File.new_for_path ("/usr/lib/flashplugin-installer/libflashplayer.so");
			File flash_adobe_file = File.new_for_path ("/usr/lib/adobe-flashplugin/libflashplayer.so");
			if (flash_ubuntu_file.query_exists () || flash_adobe_file.query_exists ())
			{
				sidebar_box.pack_start (check_flash, true, true, 2);
				check_flash.set_active (this.app.settings.get_boolean ("analyzeflash"));
				} else {
					check_flash.set_active (false);
				}

			//PAQUETES CHECKBOX - CHECK IF EXISTS AND ADD IT
			File packages_file = File.new_for_path ("/usr/bin/apt-get");
			if (packages_file.query_exists ())
			{
				sidebar_box.pack_start (check_packages, true, true, 2);
				check_packages.set_active (this.app.settings.get_boolean ("analyzepackages"));
				} else {
					check_packages.set_active (false);
				}
				
			sidebar_box.pack_start (check_docsRecent, true, true, 2);
			sidebar_box.pack_start (check_trash, true, true, 2);

			sidebar_box.pack_start (category_separator, true, true, 2);

			sidebar_box.pack_start (others_box, false, true, 2);
			sidebar_box.pack_start (check_terminal, true, true, 2);
			sidebar_box.pack_start (check_kernel, true, true, 2);

			//ACTIVATE REMAINING CHECKBOX ********************************
			check_docsRecent.set_active (this.app.settings.get_boolean ("analyzedocsrecent"));
			check_trash.set_active (this.app.settings.get_boolean ("analyzepapelera"));
			check_terminal.set_active (this.app.settings.get_boolean ("analyzeterminal"));
			check_kernel.set_active (this.app.settings.get_boolean ("analyzekernels"));

			sidebar_box.show_all();
		}	
	}
}