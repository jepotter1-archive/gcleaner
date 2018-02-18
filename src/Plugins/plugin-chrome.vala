/* Copyright 2016 Juan Pablo Lozano
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
public string path_chrome;

public void msg_chrome_profileNotFound (Window win)
{   
    var profileChromeNotFound = new MessageDialog (win, DialogFlags.DESTROY_WITH_PARENT, MessageType.WARNING, ButtonsType.OK, "¡Error al buscar el Perfil de Usuario en Google Chrome! Abra nuevamente Google Chrome para comprobar que todo este bien y pruebe nuevamente.");
    profileChromeNotFound.set_title("Advertencia... Perfil de Google Chrome");
    profileChromeNotFound.run ();
    profileChromeNotFound.destroy ();        
}

public string get_chrome_profile ()
{
    string home = GLib.Environment.get_variable ("HOME");
    path_chrome = home + "/.cache/google-chrome/Default";
    File file = File.new_for_path (path_chrome);

    if (file.query_exists ())
    {
        return path_chrome;
        } else {
            try
            {
                Process.spawn_command_line_sync ("mkdir -p " + path_chrome);
                return path_chrome;
                } catch (GLib.SpawnError e)
                {
                    stdout.printf ("COM.GCLEANER.PLUGIN-CHROME-S: [COMMAND-ERROR: %s]", e.message);
                }
    }
    return "error";    
}

public void chrome_clean ()
{
    string error;
    int status;

    try
    {
        Process.spawn_command_line_sync ("rm -rf " + path_chrome, null, out error, out status);
        } catch (GLib.SpawnError e)
        {
            stdout.printf ("COM.GCLEANER.PLUGIN-CHROME-C: [COMMAND-ERROR: %s]", e.message);
            stdout.printf ("COM.GCLEANER.PLUGIN-CHROME-C: [ERROR: %s]\n", error);
            stdout.printf ("COM.GCLEANER.PLUGIN-CHROME-C: [STATUS: %s]\n", status.to_string ());
        }
}
