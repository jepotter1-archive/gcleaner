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

namespace GCleaner {
	public class App : Gtk.Application {
		
		//LOCAL VARIABLES
		public Gtk.ApplicationWindow main_window;//Main window
        public GLib.Settings settings;

		public App () {
			Object(application_id: "org.gcleaner",
				flags: ApplicationFlags.FLAGS_NONE);
		}

		public async int firefox_scan_proc (InfoClean db_items, bool chk_firefox, GCleaner.Tools.InventoryPaths inventory) throws ThreadError
        {
            SourceFunc firefox_callback = firefox_scan_proc.callback;

            ThreadFunc<void*> run = () => {
                string user_profile;
                // FIREFOX CHECK BUTTON *******************************************************
                if (chk_firefox)
                {
                    user_profile = get_firefox_profile ();
                    if (user_profile != "error")
                    {
                        db_items.firefox_scan (user_profile, inventory);
                    } else {
                        msg_firefox_profileNotFound (this.main_window);
                    }
                }

                Idle.add((owned) firefox_callback);
                Thread.exit (1.to_pointer ());
                return null;
            };
            Thread<void*> firefox_thread = new Thread<void*> ("firefox_thread", run);

            yield;
            return 1;
        }

        public async int chrome_scan_proc (InfoClean db_items, bool chk_chrome, GCleaner.Tools.InventoryPaths inventory) throws ThreadError
        {
            SourceFunc chrome_callback = chrome_scan_proc.callback;

            ThreadFunc<void*> run = () => {
                string user_profile;
                // CHROME CHECK BUTTON ******************************************************
                if (chk_chrome)
                {
                    user_profile = get_chrome_profile ();
                    if (user_profile != "error")
                    {
                        db_items.chrome_scan (user_profile, inventory);
                      } else {
                        msg_chrome_profileNotFound (this.main_window);
                    }
                }

                Idle.add((owned) chrome_callback);
                Thread.exit (1.to_pointer ());
                return null;
            };
            Thread<void*> chrome_thread = new Thread<void*> ("chrome_thread", run);

            yield;
            return 1;
        }

        public async int midori_scan_proc (InfoClean db_items, bool chk_midori, GCleaner.Tools.InventoryPaths inventory) throws ThreadError
        {
            SourceFunc midori_callback = midori_scan_proc.callback;

            ThreadFunc<void*> run = () => {
                string midori_path;
                // MIDORI CHECK BUTTON ******************************************************
                if (chk_midori)
                {
                    midori_path = get_midori_path ();
                    if (midori_path != "error")
                    {
                        db_items.midori_scan (midori_path, inventory);
                      } else {
                        msg_midori_pathNotFound (this.main_window);
                    }
                }

                Idle.add((owned) midori_callback);
                Thread.exit (1.to_pointer ());
                return null;
            };
            Thread<void*> midori_thread = new Thread<void*> ("midori_thread", run);

            yield;
            return 1;
        }

        public async int flash_scan_proc (InfoClean db_items, bool chk_flash, GCleaner.Tools.InventoryPaths inventory) throws ThreadError
        {
            SourceFunc flash_callback = flash_scan_proc.callback;

            ThreadFunc<void*> run = () => {
                 // FLASH CHECK BUTTON *******************************************************
                if (chk_flash)
                {
                    string[] existFlash;
                    existFlash = get_flash_params ();

                    if ((existFlash[0] != "null") || (existFlash[1] != "null"))
                    {
                        db_items.flash_scan (existFlash, inventory);
                    } else {
                        msg_flashNotFound (this.main_window);
                    }
                }

                Idle.add((owned) flash_callback);
                Thread.exit (1.to_pointer ());
                return null;
            };
            Thread<void*> flash_thread = new Thread<void*> ("flash_thread", run);

            yield;
            return 1;
        }

        public async int packages_scan_proc (InfoClean db_items, bool chk_paquetes, GCleaner.Tools.InventoryPaths inventory) throws ThreadError
        {
            SourceFunc packages_callback = packages_scan_proc.callback;

            ThreadFunc<void*> run = () => {
                string profile;
                // PACKAGES CHECK BUTTON ****************************************************
                if (chk_paquetes)
                {
                    profile = get_packages_params ();
                    if (profile != "error")
                    {
                        db_items.packages_scan (profile, inventory);
                    } else {
                        msg_cacheAptPackages (this.main_window);
                    }

                    int flag_pkgconfig;
                    flag_pkgconfig = packageconfig_scan ();

                    if (flag_pkgconfig == 0)//0 -> Exito / 1 -> Error
                    {
                        int result_armarLista;
                        int64 pkgconfig_size;
                        result_armarLista = armar_lista_paquetes ();
                        pkgconfig_size = result_armarLista * 160;

                        db_items.set_pkgconfig_files (result_armarLista);
                        db_items.set_pkgconfig_size (pkgconfig_size);

                        db_items.store_file_size_pkgconfig ();
                    } else {
                        msg_dpkgBusy (this.main_window);
                    }
                }

                Idle.add((owned) packages_callback);
                Thread.exit (1.to_pointer ());
                return null;
            };
            Thread<void*> packages_thread = new Thread<void*> ("packages_thread", run);

            yield;
            return 1;
        }

        public async int docsrecent_scan_proc (InfoClean db_items, bool chk_docsrecent) throws ThreadError
        {
            SourceFunc docsrecent_callback = docsrecent_scan_proc.callback;

            ThreadFunc<void*> run = () => {
                string profile;
                // DOCUMENTOS RECIENTES CHECK BUTTON ****************************************
                if (chk_docsrecent)
                {
                    profile = get_docrecent_params ();
                    if (profile != "error")
                    {
                        db_items.docsrecent_scan (profile);
                    } else
                    {
                        msg_docsrecent_pathNotFound (this.main_window);
                    }
                }

                Idle.add((owned) docsrecent_callback);
                Thread.exit (1.to_pointer ());
                return null;
            };
            Thread<void*> docsrecent_thread = new Thread<void*> ("docsrecent_thread", run);

            yield;
            return 1;
        }

        public async int trash_scan_proc (InfoClean db_items, bool chk_trash, GCleaner.Tools.InventoryPaths inventory) throws ThreadError
        {
            SourceFunc trash_callback = trash_scan_proc.callback;

            ThreadFunc<void*> run = () => {
                string profile;
                // PAPELERA CHECK BUTTON ****************************************************
                if (chk_trash)
                {
                    profile = get_trash_params ();
                    if (profile != "error")
                    {
                        db_items.trash_scan (profile, inventory);
                      } else {
                        msg_trash_pathNotFound (this.main_window);
                    }
                }

                Idle.add((owned) trash_callback);
                Thread.exit (1.to_pointer ());
                return null;
            };
            Thread<void*> trash_thread = new Thread<void*> ("trash_thread", run);

            yield;
            return 1;
        }

        public async int print_results (InfoClean db_items) throws ThreadError
        {
            SourceFunc print_callback = print_results.callback;

            ThreadFunc<void*> run = () => {

                while (db_items.get_print_result() < 7) {}

                Idle.add((owned) print_callback);
                Thread.exit (1.to_pointer ());
                return null;
            };
            Thread<void*> print_thread = new Thread<void*> ("print_thread", run);

            yield;
            return 1;
        }

		protected override void activate () {
			/*
			 * Settings for save the GCleaner state
			 */
			settings = new GLib.Settings ("org.gcleaner");

			/*
             * Boolean value that determines if use 
             * or not use HeaderBar according to the desktop environment
             */
            bool use_headerbar;

			int successIcon = 0;

            //MAIN WINDOW PROPERTIES
    		this.main_window = new Gtk.ApplicationWindow (this);
    		this.main_window.move (settings.get_int ("opening-x"), settings.get_int ("opening-y"));
        	this.main_window.set_default_size (settings.get_int ("window-width"), settings.get_int ("window-height"));
        	this.main_window.set_title (Constants.PROGRAM_NAME);
        	this.main_window.set_application (this);
			this.main_window.icon_name = "gcleaner";//Application icon

			//BOXES
            Box main_window_box = new Box (Orientation.VERTICAL, 0);//Box that will contain the rest of the boxes (this is adjusted to the window)
            Box content_box     = new Box (Orientation.HORIZONTAL, 0);//Box containing the Sidebar, the separator and the remaining box infoAction_box
            Box progress_box    = new Box (Orientation.HORIZONTAL, 0);//Box containing the spinner, the progress bar and the % of the advance
            Box result_box      = new Box (Orientation.HORIZONTAL, 0);//Box containing the ScrolledWindow of Results
            Box buttons_box     = new Box (Orientation.HORIZONTAL, 0);//Box that will hold the buttons to scan and clean
            Box infoAction_box  = new Box (Orientation.VERTICAL, 0);//Box containing progress bar, actions and results
            Box workIcon_box    = new Box (Orientation.HORIZONTAL, 0);//Box containing the spinner, and images of notification

			//BUTTONS
            Button scan_button  = new Button.with_label (" Escanear ");
            Button clean_button = new Button.with_label (" Limpiar ");
            /*
			 * Initial state of the buttons 
             * (Scan painted blue and clear disabled)
			 */
            scan_button.get_style_context ().add_class("suggested-action");//Paint the button of blue
            clean_button.set_sensitive (false);//Disable clean button

			//LABELS
            Label porcentajeProgreso = new Label ("");
            porcentajeProgreso.set_markup ("<b>0%</b>");

			//SEPARATORS
            Separator separadorVertContenido = new Separator (Gtk.Orientation.VERTICAL);
            Separator separadorResultLeft	 = new Separator (Gtk.Orientation.VERTICAL);
            Separator separadorResultRight	 = new Separator (Gtk.Orientation.VERTICAL);
            Separator separadorResultTop	 = new Separator (Gtk.Orientation.HORIZONTAL);
            Separator separadorResultBottom	 = new Separator (Gtk.Orientation.HORIZONTAL);

			//IMAGES
            Image info_img = new Image ();
            info_img.set_from_icon_name ("dialog-information", Gtk.IconSize.MENU);

            Image success_img = new Image ();
            success_img.set_from_icon_name ("dialog-ok", Gtk.IconSize.MENU);

            //OWN WIDGETS
            var sidebar = new GCleaner.Widgets.Sidebar (this);
            sidebar.get_style_context ().add_class("Sidebar");

			/*
             * This EventBox is created to color the
             * background of the Box (Sidebar) in GTK+ <= 3.10
             */
            var eventSidebar = new EventBox ();
            eventSidebar.add (sidebar);
            eventSidebar.get_style_context ().add_class("SidebarEv");
            var colour = Gdk.RGBA ();//the color is created in RGBA
            colour.red = 103.0;
            colour.green = 103.0;
            colour.blue = 103.0;
            colour.alpha = 1.0;//transparency
            eventSidebar.override_background_color(Gtk.StateFlags.NORMAL, colour);

			/*
             * The InfoClean is a class to store in memory the scan results and
             * the InventoryPaths class store in memory the URIs of files scanned.
             */
            InfoClean db_items = new InfoClean ();
            var inventory = new GCleaner.Tools.InventoryPaths ();

			//OTHES WIDGETS
            //Widgets for workIcon Box
            Spinner spinWorking = new Spinner ();
            ProgressBar progress_bar = new ProgressBar ();

			//LIST STORE - SCAN/CLEANING INFORMATION
            Gtk.ListStore result_list = new Gtk.ListStore (3, typeof(string), typeof(string), typeof(string));
            TreeView result_view = new TreeView.with_model (result_list);
            ScrolledWindow result_window = new ScrolledWindow (null, null);
            result_window.add (result_view);
            //Results Columns -------------------------------------------------------------------
            CellRenderer concept_cell = new CellRendererText ();
            result_view.insert_column_with_attributes (-1, "Concepto", concept_cell, "text", 0);

            CellRenderer size_cell = new CellRendererText ();
            result_view.insert_column_with_attributes (-1, "Tamaño", size_cell, "text", 1);

            CellRenderer quantity_cell = new CellRendererText ();
            result_view.insert_column_with_attributes (-1, "Cantidad", quantity_cell, "text", 2);

			//PACKAGING
            /*
             * TOOLBAR and HEADERBAR
             * 
             * Here the magic of the dynamic
             * -- Checking Desktop Environment to use Header Bars
             */

            //Create string variable to store the desktop environment
            string desktopEnvironment;
            
            desktopEnvironment = GLib.Environment.get_variable ("XDG_CURRENT_DESKTOP");//We keep the value of the CURRENT_DESKTOP variable
            desktopEnvironment = desktopEnvironment.up();//We pass from "Example" To -> "EXAMPLE" (uppercase) to easily check the value
            stdout.printf ("COM.GCLEANER.APP: [DESKTOP: %s]\n", desktopEnvironment);//Print on screen for easy reading
			
            /*
             * If Pantheon Desktop (elementary OS) or 
             * GNOME Desktop, use HeaderBar.
             */
            if ((desktopEnvironment == "PANTHEON") || (desktopEnvironment == "GNOME"))
            {
                use_headerbar = true;
              } else {//Any other Desktop like Unity, XFCE, Mate, etc... use ToolBar
                use_headerbar = false;
            }

			/*
             * Use HeaderBar or ToolBar?
             */
            if (use_headerbar)
            {
                /*
                 * HeaderBar
                 * Create an instance of the HeaderBar (customized)
                 */
                var header_bar = new GCleaner.Widgets.Header (this);
                header_bar.get_style_context ().add_class("csd");
                this.main_window.set_titlebar (header_bar);
                header_bar.set_name ("header_bar");
              } else {
                /*
                 * ToolBar
                 * Creates an instance of the Toolbar (customized)
                 */
                var toolbar = new GCleaner.Widgets.ToolBar (this);
                toolbar.get_style_context ().add_class("Toolbar");
                toolbar.set_name ("Toolbar");

                //Add the Toolbar to the main window box
                main_window_box.pack_start (toolbar, false, true, 0);
            }

			/*PROGRESS and SPINNER*/
            workIcon_box.pack_start (spinWorking, true, true, 0);
            progress_box.pack_start (workIcon_box, false, true, 8);
            progress_box.pack_start (progress_bar, true, true, 8);
            progress_box.pack_start (porcentajeProgreso, false, true, 8);

            /*Scanning and Cleaning RESULTS*/
            result_box.pack_start (separadorResultLeft, false, true, 0);
            result_box.pack_start (result_window, true, true, 0);
            result_box.pack_start (separadorResultRight, false, true, 0);

            /*Buttons*/
            buttons_box.pack_start (scan_button, false, false, 0);
            buttons_box.pack_end (clean_button, false, false, 0);

            /*Information, Results and Actions*/
            infoAction_box.pack_start (progress_box, false, true, 8);
            infoAction_box.pack_start (separadorResultTop, false, true, 0);
            infoAction_box.pack_start (result_box, true, true, 0);
            infoAction_box.pack_start (separadorResultBottom, false, true, 0); //Separador entre la botonera y los resultados
            infoAction_box.pack_start (buttons_box, false, true, 8);

            /*Content Box*/
            content_box.pack_start (eventSidebar, false, true, 0);//Empaqueta la sidebar al contendor de contenidos de la APP
            content_box.pack_start (separadorVertContenido, false, true, 0);//Separador visible entre la Sidebar y los Resultados
            content_box.pack_start (infoAction_box, true, true, 8);//Empaqueta la caja con el contenido de informacion, resultado y acciones

            /*Final assembly*/
            main_window_box.pack_start (content_box, true, true, 0);

			/************* TEMPORARY, then erase *******************/
            string homeUSER = GLib.Environment.get_variable ("HOME");
            stdout.printf ("COM.GCLEANER.APP: [USUARIO: %s]\n", homeUSER);

            var loop = new MainLoop();
            double progress_fraction = 0;
            double progress_number = 0;

			/*
             * Scan button actions and Logic
             */
            scan_button.clicked.connect(()=> {

                result_list.clear ();//Clean the results list
                scan_button.get_style_context ().remove_class ("suggested-action");//remove the color blue of the button
                scan_button.set_sensitive (false);//Disable the scan button
                workIcon_box.remove (success_img);
            
                if (successIcon == 1)
                {
                    workIcon_box.add (spinWorking);
                    successIcon = 0;
                }
            
                spinWorking.active = true;
                progress_bar.set_fraction (0);//-------------->>> 0%
                progress_fraction = 0;
                progress_number = 0;
                result_list.clear ();//Clean the results grid

                /*Set to 0 before scanning*/
                db_items.set_counter (0);
                db_items.set_accumulator (0);

                firefox_scan_proc.begin (db_items, sidebar.check_firefox.get_active (), inventory, (obj, res) => {
                    try {
                        int result = firefox_scan_proc.end(res);
                        db_items.set_print_result (result);
                        progress_fraction += 0.1428571;
                        progress_number += 14.28571;
                        progress_bar.set_fraction (progress_fraction);
                        porcentajeProgreso.set_markup ("<b>" + Math.round (progress_number).to_string() + "%</b>");

                        if (db_items.get_firefox_files () != 0)
                        {
                            TreeIter iter;
                            result_list.append (out iter);
                            result_list.set (iter, 0, "• Temporales y Cache de Mozilla Firefox", 1, to_file_size_format (db_items.get_firefox_size ()), 2, db_items.get_firefox_files ().to_string () + " Archivos");
                        }
                      } catch (ThreadError e) {
                        stderr.printf("Firefox-Thread error: %s\n", e.message);
                    }
                });

                chrome_scan_proc.begin (db_items, sidebar.check_chrome.get_active (), inventory, (obj, res) => {
                    try {
                        int result = chrome_scan_proc.end(res);
                        db_items.set_print_result (result);
                        progress_fraction += 0.1428571;
                        progress_number += 14.28571;
                        progress_bar.set_fraction (progress_fraction);
                        porcentajeProgreso.set_markup ("<b>" + Math.round (progress_number).to_string() + "%</b>");

                        if (db_items.get_chrome_files () != 0)
                        {
                            TreeIter iter;
                            result_list.append (out iter);
                            result_list.set (iter, 0, "• Temporales y Cache de Google Chrome", 1, to_file_size_format (db_items.get_chrome_size ()), 2, db_items.get_chrome_files ().to_string () + " Archivos");
                        }
                      } catch (ThreadError e) {
                        stderr.printf("Chrome-Thread error: %s\n", e.message);
                    }
                });

                midori_scan_proc.begin (db_items, sidebar.check_midori.get_active (), inventory, (obj, res) => {
                    try {
                        int result = midori_scan_proc.end(res);
                        db_items.set_print_result (result);
                        progress_fraction += 0.1428571;
                        progress_number += 14.28571;
                        progress_bar.set_fraction (progress_fraction);
                        porcentajeProgreso.set_markup ("<b>" + Math.round (progress_number).to_string() + "%</b>");

                        if (db_items.get_midori_files () != 0)
                        {
                            TreeIter iter;
                            result_list.append (out iter);
                            result_list.set (iter, 0, "• Temporales y Cache de Midori", 1, to_file_size_format (db_items.get_midori_size ()), 2, db_items.get_midori_files ().to_string () + " Archivos");
                        }
                      } catch (ThreadError e) {
                        stderr.printf("Midori-Thread error: %s\n", e.message);
                    }
                });

                flash_scan_proc.begin (db_items, sidebar.check_flash.get_active (), inventory, (obj, res) => {
                    try {
                        int result = flash_scan_proc.end(res);
                        db_items.set_print_result (result);
                        progress_fraction += 0.1428571;
                        progress_number += 14.28571;
                        progress_bar.set_fraction (progress_fraction);
                        porcentajeProgreso.set_markup ("<b>" + Math.round (progress_number).to_string() + "%</b>");

                        if (db_items.get_flash_files () != 0)
                        {
                            TreeIter iter;
                            result_list.append (out iter);
                            result_list.set (iter, 0, "• Cache y Cookies de Flash Player", 1, to_file_size_format (db_items.get_flash_size ()), 2, db_items.get_flash_files ().to_string () + " Archivos");
                        }
                      } catch (ThreadError e) {
                        stderr.printf("Flash-Thread error: %s\n", e.message);
                    }
                });

                packages_scan_proc.begin (db_items, sidebar.check_packages.get_active (), inventory, (obj, res) => {
                    try {
                        int result = packages_scan_proc.end(res);
                        db_items.set_print_result (result);
                        progress_fraction += 0.1428571;
                        progress_number += 14.28571;
                        progress_bar.set_fraction (progress_fraction);
                        porcentajeProgreso.set_markup ("<b>" + Math.round (progress_number).to_string() + "%</b>");


                        if (db_items.get_packages_files () != 0)
                        {
                            TreeIter iter;
                            result_list.append (out iter);
                            result_list.set (iter, 0, "• Cache de Paquetes de APT", 1, to_file_size_format (db_items.get_packages_size ()), 2, db_items.get_packages_files ().to_string () + " Archivos");
                        }

                        if (db_items.get_pkgconfig_files () > 0)
                        {
                            TreeIter iter;
                            result_list.append (out iter);
                            result_list.set (iter, 0, "• Configuracion de Paquetes", 1, to_file_size_format (db_items.get_pkgconfig_size ()), 2, db_items.get_pkgconfig_files ().to_string () + " Paquetes");
                        }
                      } catch (ThreadError e) {
                        stderr.printf("Packages-Thread error: %s\n", e.message);
                    }
                });

                docsrecent_scan_proc.begin (db_items, sidebar.check_docsRecent.get_active (), (obj, res) => {
                    try {
                        int result = docsrecent_scan_proc.end(res);
                        db_items.set_print_result (result);
                        progress_fraction += 0.1428571;
                        progress_number += 14.28571;
                        progress_bar.set_fraction (progress_fraction);
                        porcentajeProgreso.set_markup ("<b>" + Math.round (progress_number).to_string() + "%</b>");

                        if (db_items.get_docsrecent_files () != 0)
                        {
                            TreeIter iter;
                            result_list.append (out iter);
                            result_list.set (iter, 0, "• Documentos Recientes", 1, to_file_size_format (db_items.get_docsrecent_size ()), 2, db_items.get_docsrecent_files ().to_string () + " Entradas");
                        }
                      } catch (ThreadError e) {
                        stderr.printf("Docsrecent-Thread error: %s\n", e.message);
                    }
                });

                trash_scan_proc.begin (db_items, sidebar.check_trash.get_active (), inventory, (obj, res) => {
                    try {
                        int result = trash_scan_proc.end(res);
                        db_items.set_print_result (result);
                        progress_fraction += 0.1428571;
                        progress_number += 14.28571;
                        progress_bar.set_fraction (progress_fraction);
                        porcentajeProgreso.set_markup ("<b>" + Math.round (progress_number).to_string() + "%</b>");

                        if (db_items.get_trash_files () != 0)
                        {
                            TreeIter iter;
                            result_list.append (out iter);
                            result_list.set (iter, 0, "• Papelera de Reciclaje", 1, to_file_size_format (db_items.get_trash_size ()), 2, db_items.get_trash_files ().to_string () + " Archivos");
                        }
                      } catch (ThreadError e) {
                        stderr.printf("Trash-Thread error: %s\n", e.message);
                    }
                });

                print_results.begin (db_items, (obj, res) => {
                    try {
                        int result = print_results.end(res);
                        
                        progress_bar.set_fraction (1.0);
                        porcentajeProgreso.set_markup ("<b>100%</b>");

                        if (db_items.get_counter () > 0)
                        {

                            if (1 == 1)
                            {
                                TreeIter iter;
                                result_list.append (out iter);
                                result_list.set (iter, 0, "———————————————————————", 1, "—————————", 2, "—————————");
                            }

                            if (1 == 1)
                            {
                                TreeIter iter;
                                result_list.append (out iter);
                                result_list.set (iter, 0, "☰ Resultados del Analisis:", 1, to_file_size_format (db_items.get_accumulator ()), 2, "se liberaran");
                            }
                    
                            //Change the Spinner by the notification (image)
                            spinWorking.active = false;
                            workIcon_box.remove (spinWorking);
                            info_img.show ();
                            workIcon_box.add (info_img);
                            workIcon_box.reorder_child (info_img, -1);
                            clean_button.set_sensitive (true);//Enable Clean Button
                            clean_button.get_style_context ().add_class ("destructive-action");//Paint the button of red
                        } else {
                            spinWorking.active = false;
                            workIcon_box.remove (spinWorking);
                            success_img.show ();
                            workIcon_box.add (success_img);
                            clean_button.set_sensitive (false);//Disable Clean Button
                            clean_button.get_style_context ().remove_class ("destructive-action");//remove the red color of button
                            TreeIter iter;
                            result_list.append (out iter);
                            result_list.set (iter, 0, "☺ Felicitaciones! El Sistema se encuentra limpio!", 1, "", 2, "");
                            scan_button.set_sensitive (true);//Enable the scan button
                            scan_button.get_style_context ().add_class ("suggested-action");//Paint the button of blue
                        }

                      } catch (ThreadError e) {
                        stderr.printf("Print-Thread error: %s\n", e.message);
                    }
                });

                loop.quit();
            });//Scan button End


            clean_button.clicked.connect(()=> {
                clean_button.get_style_context ().remove_class ("destructive-action");
                clean_button.set_sensitive (false);
                workIcon_box.remove (info_img);
                //workIcon_box.remove (spinWorking);
                workIcon_box.add (spinWorking);
                spinWorking.active = true;
                result_list.clear ();//Clean the results grid
                int existError;
                int64 clean_files, clean_size;
                clean_files = db_items.get_counter ();
                clean_size = 0;

                //CLEANING OF MOZILLA FIREFOX
                if (db_items.get_firefox_files () > 0)
                {
                    firefox_clean ();
                    clean_files = clean_files - db_items.get_firefox_files ();
                    clean_size = clean_size + db_items.get_firefox_size ();
                }

                //CLEANING OF GOOGLE CHROME
                if (db_items.get_chrome_files () > 0)
                {
                    chrome_clean ();
                    clean_files = clean_files - db_items.get_chrome_files ();
                    clean_size = clean_size + db_items.get_chrome_size ();
                }

                //CLEANING OF MIDORI
                if (db_items.get_midori_files () > 0)
                {
                    midori_clean ();
                    clean_files = clean_files - db_items.get_midori_files ();
                    clean_size = clean_size + db_items.get_midori_size ();
                }

                //CLEANING OF FLASH PLAYER
                if (db_items.get_flash_files () > 0)
                {
                    flash_clean ();
                    clean_files = clean_files - db_items.get_flash_files ();
                    clean_size = clean_size + db_items.get_flash_size ();
                }

                //CLEANING OF PACKAGES
                if (db_items.get_packages_files () > 0)
                {
                    existError = packages_clean (this.main_window);

                    if (existError == 0)
                    {
                        clean_files = clean_files - db_items.get_packages_files ();
                        clean_size = clean_size + db_items.get_packages_size ();
                    } else {
                        stderr.printf ("COM.GCLEANER.APP.CLEAN-PROCESS: [NO SE PUDO LIMPIAR LOS PAQUETES DE APT]\n");
                    }
                }
                
                //CLEANING OF PACKAGES CONFIGS
                if (db_items.get_pkgconfig_files () > 0)
                {
                    if (get_packageconfig_list () != "")
                    {
                        packageconfig_clean ();
                        clean_files = clean_files - db_items.get_pkgconfig_files ();
                        clean_size = clean_size + db_items.get_pkgconfig_size ();
                    } else {
                        stderr.printf ("COM.GCLEANER.APP.CLEAN-PROCESS: [NO HAY CONFIGURACION DE PAQUETES]\n");
                    }
                }

                //CLEANING OF RECENT DOCUMENTS
                if (db_items.get_docsrecent_files () > 0)
                {
                    docsrecent_clean ();
                    clean_files = clean_files - db_items.get_docsrecent_files ();
                    clean_size = clean_size + db_items.get_docsrecent_size ();
                }

                //CLEANING OF TRASH
                if (db_items.get_trash_files () > 0)
                {
                    existError = trash_clean (this.main_window);

                    if (existError == 0)
                    {
                        clean_files = clean_files - db_items.get_trash_files ();
                        clean_size = clean_size + db_items.get_trash_size ();
                    } else {
                        stderr.printf ("COM.GCLEANER.APP.CLEAN-PROCESS: [NO SE PUDO LIMPIAR LA PAPELERA DE RECICLAJE]\n");
                    }
                }


                spinWorking.active = false;//Stop spinner
            
                if (clean_files == 0)
                {
                    TreeIter iter;
                    result_list.append (out iter);
                    result_list.set (iter, 0, "✔ Limpieza realizada con Exito", 1, "se liberaron " + to_file_size_format (db_items.get_accumulator ()), 2, "en " + db_items.get_counter ().to_string () + " Archivos");
                } else {
                    TreeIter iter;
                    result_list.append (out iter);
                    result_list.set (iter, 0, "❌ Limpieza incompleta", 1, "se liberaron " + to_file_size_format (clean_size), 2, "faltaron " + db_items.get_counter ().to_string () + " Archivos");
                }

                /*Set to 0 once cleaned*/
                db_items.set_counter (0);
                db_items.set_accumulator (0);


                //Change the Spinner by the notification (image)
                //workIcon_box.remove (info_img);
                workIcon_box.remove (spinWorking);
                success_img.show ();
                workIcon_box.add (success_img);
                successIcon = 1;

                scan_button.set_sensitive (true);//Enable the scan button
                scan_button.get_style_context ().add_class ("suggested-action");//Paint the button of blue
            });
            //...// END PROCESS //...// **************************************************************************************************

			this.main_window.delete_event.connect (() => {
    			int x, y, w, h;

    			this.main_window.get_position (out x, out y);
    			this.main_window.get_size (out w, out h);

    			//Guardar Valores en GSCHEMA
				settings.set_int ("opening-x", x);
    			settings.set_int ("opening-y", y);
    			settings.set_int ("window-width", w);
    			settings.set_int ("window-height", h);

                settings.set_boolean ("analyzefirefox", sidebar.check_firefox.get_active ());
                settings.set_boolean ("analyzechrome", sidebar.check_chrome.get_active ());
				settings.set_boolean ("analyzemidori", sidebar.check_midori.get_active ());
                settings.set_boolean ("analyzeflash", sidebar.check_flash.get_active ());
                settings.set_boolean ("analyzepackages", sidebar.check_packages.get_active ());
                settings.set_boolean ("analyzedocsrecent", sidebar.check_docsRecent.get_active ());
                settings.set_boolean ("analyzepapelera", sidebar.check_trash.get_active ());
                settings.set_boolean ("analyzeterminal", sidebar.check_terminal.get_active ());
                settings.set_boolean ("analyzekernels", sidebar.check_kernel.get_active ());
    
    			return false;
			});

        	this.main_window.add (main_window_box);
        	this.main_window.show_all ();
		}

		public static int main (string[] args) {
			Gtk.init (ref args);//Starts GTK+

			string css_file = "/usr/share/gcleaner/gtk-widgets-gcleaner.css";//Path where takes the CSS file
			var css_provider = new Gtk.CssProvider ();//Create a new CSS provider

			try
			{
				css_provider.load_from_path (css_file);//Loads the CSS of the previous path (string)
				Gtk.StyleContext.add_provider_for_screen (Gdk.Screen.get_default(), css_provider, Gtk.STYLE_PROVIDER_PRIORITY_USER);
	  		} catch (Error e) {//Handling the Error
	  			stderr.printf ("COM.GCLEANER.APP: [ERROR CARGANDO ESTILOS CSS [%s]]\n", e.message);
	  			stderr.printf (">>> Check path: /usr/share/gcleaner/gtk-widgets-gcleaner.css\n");
			}
			
			var app = new GCleaner.App ();
			
			if ((args[1] == "--version") || (args[1] == "-version")) {
				var about = new GCleaner.Widgets.About ();
				about.run ();
				about.destroy.connect (Gtk.main_quit);
			}

			return app.run (args);
		}
	}
}