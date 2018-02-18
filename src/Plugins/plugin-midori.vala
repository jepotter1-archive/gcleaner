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
public string path_midori_cache;

public string get_midori_path ()
{
    path_midori_cache = GLib.Environment.get_variable ("HOME") + "/.cache/midori";
    File file = File.new_for_path (path_midori_cache);

    if (file.query_exists ())
    {
        return path_midori_cache;
        } else {
            try
            {
                Process.spawn_command_line_sync ("mkdir -p " + path_midori_cache);
                return path_midori_cache;
                } catch (GLib.SpawnError e)
                {
                    stdout.printf ("COM.GCLEANER.PLUGIN-MIDORI-S: [COMMAND-ERROR: %s]", e.message);
                }
    }
    return "error";    
}

public void msg_midori_pathNotFound (Window win)
{   
    var midoriPathNotFound = new MessageDialog (win, DialogFlags.DESTROY_WITH_PARENT, MessageType.WARNING, ButtonsType.OK, "¡Error al buscar la cache de Midori! Abra nuevamente Midori para comprobar que todo este bien y pruebe nuevamente.");
    midoriPathNotFound.set_title("Advertencia... Cache de Midori");
    midoriPathNotFound.run ();
    midoriPathNotFound.destroy ();        
}

public void midori_clean ()
{
    string error;
    int status;

    try
    {
        Process.spawn_command_line_sync ("rm -rf " + path_midori_cache, null, out error, out status);
        } catch (GLib.SpawnError e)
        {
            stdout.printf ("COM.GCLEANER.PLUGIN-MIDORI-C: [COMMAND-ERROR: %s]", e.message);
            stdout.printf ("COM.GCLEANER.PLUGIN-MIDORI-C: [ERROR: %s]\n", error);
            stdout.printf ("COM.GCLEANER.PLUGIN-MIDORI-C: [STATUS: %s]\n", status.to_string ());
        }
}