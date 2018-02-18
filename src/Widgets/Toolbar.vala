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
	public class ToolBar : Toolbar//Class to build Toolbar
	{

		public GCleaner.App app;

		//ACTIONS CALLBACKS HERE
		void about_cb (SimpleAction simple, Variant? parameter) {
			var about = new GCleaner.Widgets.About ();
			about.run ();
		}

		public ToolBar (GCleaner.App app)
		{
			this.app = app;

			//Variables
			string complete_system_specs;//string where we keep the chain with all the information of the system specifications

			this.get_style_context ().add_class (STYLE_CLASS_PRIMARY_TOOLBAR);//Class property to give ToolBar aspect of Ubuntu (consecutive to the edge of the window)

			//LABELS
			/* NAME APP & VERSION */
			//PANGO MARKUP FONT SIZEs: xx-small - x-small - small - medium - large - x-large - xx-large //
			//More information in: https://developer.gnome.org/pango/stable/PangoMarkupFormat.html 
			Label title = new Label ("");
			title.set_markup ("<span font_size='large'><b>GCleaner</b></span>");//Big letters 'large'

			Label version = new Label ("");
			version.set_markup ("<span font_size='small'> v" + Constants.VERSION + "</span>");//Take the version of GCleaner from the constant

			/*Information of Operating System, RAM and Video*/
			Label os_information = new Label ("");
			os_information.set_markup ("<span font_size='small'>" + getOS () + "</span>");//Returns the distribution, codename and architecture

			complete_system_specs = getProcessor () + "  •  " + getMemory () + " RAM  •  " + getGraphics ();//•▪ Arma la cadena de las especificaciones del Sistema

			Label system_specs = new Label ("");
			system_specs.set_markup ("<span font_size='small'>" + complete_system_specs + "</span>");//Usa las especificaciones en el formato markup establecido
		
			/*Fillings*/
			Label helpFill_1 		  = new Label ("");
			Label helpFill_2 		  = new Label (" ");
			Label iconFill 		  = new Label ("");
			Label systemSpecs_fill = new Label ("");
			Label nameApp_fill 	  = new Label ("");//Generate a empty label to format with Pango Markup
			helpFill_1.set_markup ("<span font_size='large'>  </span>");
			iconFill.set_markup ("<span font_size='xx-small'>  </span>");
			nameApp_fill.set_markup ("<span font_size='large'>  </span>");//Small letter 'small'
			systemSpecs_fill.set_markup ("<span font_size='x-large'>  </span>");

			/*
			 * Here, first we create an Image and then add
			 * this image to MenuButton and resize it.
			 */
			var appmenu_button = new Gtk.MenuButton();
			Gtk.Image gear_icon = new Gtk.Image ();
			gear_icon.set_from_icon_name ("open-menu", Gtk.IconSize.LARGE_TOOLBAR);
			appmenu_button.set_image (gear_icon);
			appmenu_button.set_size_request (32, 32);
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
			/*Icon*/
			Box icon_box 	= new Box (Orientation.VERTICAL, 0);
			Box subIcon_box = new Box (Orientation.HORIZONTAL, 0);//Engloba para separar con pixels los ToolItem

			/*Name and Version*/
			Box nameApp_box 	= new Box (Orientation.VERTICAL, 0);
			Box title_box 		= new Box (Orientation.HORIZONTAL, 0);
			Box version_box 	= new Box (Orientation.HORIZONTAL, 0);
			Box subNameApp_box	= new Box (Orientation.HORIZONTAL, 0);//Engloba para separar con pixels los ToolItem

			/*Operating System and System specs*/
			Box os_box 			  = new Box (Orientation.HORIZONTAL, 0);
			Box sysProperties_box = new Box (Orientation.HORIZONTAL, 0);
			Box specs_box 		  = new Box (Orientation.VERTICAL, 0);
			Box subSpecs_box	  = new Box (Orientation.HORIZONTAL, 0);//Engloba para separar con pixels los ToolItem

			/*Help*/
			Box help_box = new Box (Orientation.VERTICAL, 0);
			Box about_box = new Box (Orientation.HORIZONTAL, 0);


			//TOOLITEMS
			ToolItem item_icon = new ToolItem ();
			ToolItem item_name = new ToolItem ();
			ToolItem item_spec = new ToolItem ();
			ToolItem item_help = new ToolItem ();


			//OTHERS TOOLITEMS
			SeparatorToolItem expander = new SeparatorToolItem ();//Separator (Expander), to go expanding the blank space
			expander.set_draw (false);//not draw
			expander.set_expand (true);//and YES expand


			//GCleaner icon for Toolbar
			Image icon = new Image ();
			try
			{
				var icon_pixbuf = new Gdk.Pixbuf.from_file_at_scale ("/usr/share/pixmaps/gcleanertb.svg", 56, 56, false);//Crea una imagen pixbuf
				icon.set_from_pixbuf (icon_pixbuf);
			  } catch (GLib.Error e) {
				stderr.printf ("COM.GCLEANER.APP.TOOLBAR: [GLIB::ERROR CREANDO ICONO PIXBUF]\n");
				stderr.printf (">>> Comprobar ruta: /usr/share/pixmaps/gcleanertb.svg\n");
			}

			//PACKAGING
			/*boxName.pack_start (widget, expand, fill, padding);*/
			/*Icon*/
			icon_box.pack_start (iconFill, false, true, 0);
			icon_box.pack_start (icon, false, true, 2);
			subIcon_box.pack_start (icon_box, false, true, 6);

			/*Name and Version*/
			title_box.pack_start (title, false, true, 0);
			version_box.pack_start (version, false, true, 0);
			nameApp_box.pack_start (nameApp_fill, false, true, 0);
			nameApp_box.pack_start (title_box, false, true, 0);
			nameApp_box.pack_start (version_box, false, true, 0);
			subNameApp_box.pack_start (nameApp_box, false, true, 6);

			/*Operating System and System Specs*/
			os_box.pack_start (os_information, false, true, 0);
			sysProperties_box.pack_start (system_specs, false, true, 0);
			specs_box.pack_start (systemSpecs_fill, false, true, 0);
			specs_box.pack_start (os_box, false, true, 0);
			specs_box.pack_start (sysProperties_box, false, true, 0);
			subSpecs_box.pack_start (specs_box, false, true, 6);

			/*Help ToolButton*/
			about_box.pack_start (appmenu_button, false, true, 6);
			help_box.pack_start (helpFill_1, false, true, 1);
			help_box.pack_start (about_box, false, true, 0);
			help_box.pack_start (helpFill_2, false, true, 0);

			/*ToolItems*/
			item_icon.add (subIcon_box);
			item_name.add (subNameApp_box);
			item_spec.add (subSpecs_box);
			item_help.add (help_box);

			/*ToolBar*/
			this.add (item_icon);
			this.add (item_name);
			this.add (item_spec);
			this.add (expander);
			this.add (item_help);
		}
	}
}
