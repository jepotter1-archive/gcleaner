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

public class InfoClean
{
    //Variables by search criteria *************************************************************
    //COUNTER and ACCUMULATOR
    private int64 counter;
    private int64 accumulator;

    //MOZILLA FIREFOX
    private int64 firefox_files;
    private int64 firefox_size;

    //GOOGLE CHROME
    private int64 chrome_files;
    private int64 chrome_size;

    //MIDORI BROWSER
    private int64 midori_files;
    private int64 midori_size;

    //FLASH PLAYER
    private int64 flash_files;
    private int64 flash_size;

    //PACKAGES
    private int64 packages_files;
    private int64 packages_size;
    private int64 pkgconfig_files;
    private int64 pkgconfig_size;

    //RECENT DOCUMENTS
    private int64 docsrecent_files;
    private int64 docsrecent_size;

    //TRASH
    private int64 trash_files;
    private int64 trash_size;

    //RESULTS
    private int result_state;

    //CONSTRUCTOR ************************************************************************************
    public void InfoClean ()
    {
        counter = 0;
        accumulator = 0;

        firefox_files = 0;
        firefox_size = 0;
     
        chrome_files = 0;
        chrome_size = 0;
     
        flash_files = 0;
        flash_size = 0;
            
        packages_files = 0;
        packages_size = 0;
        pkgconfig_files = 0;
        pkgconfig_size = 0;
     
        docsrecent_files = 0;
        docsrecent_size = 0;
     
        trash_files = 0;
        trash_size = 0;

        result_state = 0;
    }

    public int64 get_counter () { return counter; }
    public void set_counter (int64 val) { counter = val; }
    public void set_accumulator (int64 val) { accumulator = val; }
    public int64 get_accumulator () { return accumulator; }
    public void set_print_result (int val) { result_state += val; }
    public int get_print_result () { return result_state; }

    //MOZILLA FIREFOX ****************************************************************
    public void firefox_scan (string path, GCleaner.Tools.InventoryPaths inventory)
    {
        int64[] information = {};
        var sc = new GCleaner.Tools.Scanner ();
        
        information = sc.get_file_folderSize (path, inventory);

        if (information[0] == 2)
        {
            firefox_files = 0;
            firefox_size = 0;
          } else {
            firefox_files = information[0];
            firefox_size = information[1];
        }

        counter = counter + firefox_files;
        accumulator = accumulator + firefox_size;
    }

    public int64 get_firefox_files () { return firefox_files; }
    public int64 get_firefox_size () { return firefox_size; }

    //GOOGLE CHROME ******************************************************************
    public void chrome_scan (string path, GCleaner.Tools.InventoryPaths inventory)
    {
        int64[] information = {};
        var sc = new GCleaner.Tools.Scanner ();

        information = sc.get_file_folderSize (path, inventory);

        chrome_files = information[0];
        chrome_size = information[1];

        counter = counter + chrome_files;
        accumulator = accumulator + chrome_size;
    }

    public int64 get_chrome_files () { return chrome_files; }
    public int64 get_chrome_size () { return chrome_size; }

    //MIDORI CHROME ******************************************************************
    public void midori_scan (string path, GCleaner.Tools.InventoryPaths inventory)
    {
        int64[] information = {};
        var sc = new GCleaner.Tools.Scanner ();

        information = sc.get_file_folderSize (path, inventory);

        midori_files = information[0];
        midori_size = information[1];

        counter = counter + midori_files;
        accumulator = accumulator + midori_size;
    }

    public int64 get_midori_files () { return midori_files; }
    public int64 get_midori_size () { return midori_size; }

    //FLASH PLAYER ********************************************************************
    public void flash_scan (string[] paths, GCleaner.Tools.InventoryPaths inventory)
    {
        int64[] information_ubuntu = {};
        int64[] information_adobe = {};

        var sc = new GCleaner.Tools.Scanner ();

        flash_files = 0;
        flash_size = 0;

        if (paths[0] != "null")
        {
          information_ubuntu = sc.get_file_folderSize (paths[0], inventory);
          flash_files = flash_files + information_ubuntu[0];
          flash_size = flash_size + information_ubuntu[1];
        } else {
          stdout.printf ("COM.GCLEANER.FN-INFOCLEAN (PLUGIN-FLASH-S): [ERROR: No existe Path para Flash Plugin]");
        }

        if (paths[1] != "null")
        {
          information_adobe = sc.get_file_folderSize (paths[1], inventory);
          flash_files = flash_files + information_adobe[0];
          flash_size = flash_size + information_adobe[1];
        } else {
          stdout.printf ("COM.GCLEANER.FN-INFOCLEAN (PLUGIN-FLASH-S): [ERROR: No existe Path para Adobe Flash Plugin]");
        }

        counter = counter + flash_files;
        accumulator = accumulator + flash_size;
    }

    public int64 get_flash_files () { return flash_files; }
    public int64 get_flash_size () { return flash_size; }

    //PACKAGES ************************************************************************
    public void packages_scan (string path, GCleaner.Tools.InventoryPaths inventory)
    {
        int64[] information = {};//sub (0) -> Archivos / sub (1) -> Peso de Carpeta en Bytes
        var sc = new GCleaner.Tools.Scanner ();

        information = sc.get_file_folderSize (path, inventory);

        if (information[0] == 1)
        {
            packages_files = 0;
            packages_size = 0;
            } else {
                packages_files = information[0];
                packages_size = information[1];
        }

        counter = counter + packages_files;
        accumulator = accumulator + packages_size;
    }

    public int64 get_packages_files () { return packages_files; }
    public int64 get_packages_size () { return packages_size; }

    public void store_file_size_pkgconfig ()
    {
        counter = counter + pkgconfig_files;
        accumulator = accumulator + pkgconfig_size;
    }

    public void set_pkgconfig_files (int64 val) { pkgconfig_files = val; }
    public int64 get_pkgconfig_files () { return pkgconfig_files; }

    public void set_pkgconfig_size (int64 val) { pkgconfig_size = val; }
    public int64 get_pkgconfig_size () { return pkgconfig_size; }

    //DOCUMENTOS RECIENTES ***********************************************************
    public void docsrecent_scan (string path)
    {
      string error, salida;
      int status;
        try
        {    
            Process.spawn_command_line_sync ("grep -c 'file:' " + path, out salida, out error, out status);
            docsrecent_files = int.parse (salida);
            docsrecent_size = (docsrecent_files * 512) + 256;

            counter = counter + docsrecent_files;
            accumulator = accumulator + docsrecent_size;
          } catch (GLib.SpawnError e)
          {
            stdout.printf ("COM.GCLEANER.FN-INFOCLEAN-DOCSRECENT: [ERROR: %s]", e.message);
            docsrecent_files = 0;
            docsrecent_size = 0;
        }
    }

    public int64 get_docsrecent_files () { return docsrecent_files; }
    public int64 get_docsrecent_size () { return docsrecent_size; }

    //PAPELERA DE RECICLAJE **********************************************************
    public void trash_scan (string path, GCleaner.Tools.InventoryPaths inventory)
    {
        int64[] information = {};
        var sc = new GCleaner.Tools.Scanner ();

        information = sc.get_file_folderSize (path, inventory);
        
        trash_files = information[0];
        trash_size = information[1];

        counter = counter + trash_files;
        accumulator = accumulator + trash_size;
    }

    public int64 get_trash_files () { return trash_files; }
    public int64 get_trash_size () { return trash_size; }
}