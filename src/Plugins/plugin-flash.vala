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

//Local Variables
public string path_flash_ubuntu;
public string path_flash_adobe;

public void msg_flashNotFound (Window win)
{   
    var profileChromeNotFound = new MessageDialog (win, DialogFlags.DESTROY_WITH_PARENT, MessageType.WARNING, ButtonsType.OK, "¡Ocurrio un Error al tratar de escanear Flash Player! Compruebe la instalacion del mismo e intentelo nuevamente.");
    profileChromeNotFound.set_title("Advertencia... Flash Player");
    profileChromeNotFound.run ();
    profileChromeNotFound.destroy ();        
}

public string[] get_flash_params ()
{
    string[] paths = new string[2];
    string home = GLib.Environment.get_variable ("HOME");
    path_flash_ubuntu = home + "/.macromedia/Flash_Player";
    path_flash_adobe = home + "/.adobe/Flash_Player";

    File file_ubuntu = File.new_for_path (path_flash_ubuntu);
    File file_adobe = File.new_for_path (path_flash_adobe);

    if (file_ubuntu.query_exists ())
    {
        paths[0] = path_flash_ubuntu;
    } else {
        try
        {
            Process.spawn_command_line_sync ("mkdir -p " + path_flash_ubuntu);
            paths[0] = path_flash_ubuntu;
          } catch (GLib.SpawnError e)
          {
            stdout.printf ("COM.GCLEANER.PLUGIN-FLASH-S: [ERROR: No existe Path para Flash Plugin]");
            paths[0] = "null";
        }
    }

    if (file_adobe.query_exists ())
    {
        paths[1] = path_flash_adobe;
    } else {
        try
        {
            Process.spawn_command_line_sync ("mkdir -p " + path_flash_adobe);
            paths[1] = path_flash_adobe;
          } catch (GLib.SpawnError e)
          {
            stdout.printf ("COM.GCLEANER.PLUGIN-FLASH-S: [ERROR: No existe Path para Adobe Flash Plugin]");
            paths[1] = "null";
        }
    }

    return paths;    
}

public void flash_clean ()
{
    string error;
    int status;

    try
    {
        Process.spawn_command_line_sync ("rm -rf " + path_flash_ubuntu, null, out error, out status);
        Process.spawn_command_line_sync ("rm -rf " + path_flash_adobe, null, out error, out status);
        } catch (GLib.SpawnError e)
        {
            stdout.printf ("COM.GCLEANER.PLUGIN-CHROME-C: [COMMAND-ERROR: %s]", e.message);
            stdout.printf ("COM.GCLEANER.PLUGIN-TRASH-C: [ERROR: %s]\n", error);
            stdout.printf ("COM.GCLEANER.PLUGIN-TRASH-C: [STATUS: %s]\n", status.to_string ());
        }
}
