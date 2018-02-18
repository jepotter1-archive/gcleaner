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
public string path_docrecent;

public void msg_docsrecent_pathNotFound (Window win)
{   
    string home = GLib.Environment.get_variable ("HOME");
    var docsrecentNotFound = new MessageDialog (win, DialogFlags.DESTROY_WITH_PARENT, MessageType.WARNING, ButtonsType.OK, "¡No se pudo analizar los Documentos Recientes! Verifique el acceso al archivo\n %s/.local/share/recently-used.xbel", home);
    docsrecentNotFound.set_title("Advertencia... Documentos Recientes");
    docsrecentNotFound.run ();
    docsrecentNotFound.destroy ();        
}

public string get_docrecent_params ()
{
    string home = GLib.Environment.get_variable ("HOME");
    path_docrecent = home + "/.local/share/recently-used.xbel";
    File file = File.new_for_path (path_docrecent);

    if (file.query_exists ())
    {
        return path_docrecent;
        } else {
            try
            {
                Process.spawn_command_line_sync ("bash -c \"echo > " + path_docrecent + "\"");
                return path_docrecent;
                } catch (GLib.SpawnError e)
                {
                    stdout.printf ("COM.GCLEANER.PLUGIN-DOCSRECENT-S: [COMMAND-ERROR: %s]", e.message);
                    return "error";
                }
    }    
}

public void docsrecent_clean ()
{
    string error;
    int status;

    try
    {
        Process.spawn_command_line_sync ("bash -c \"echo > " + path_docrecent + "\"", null, out error, out status);
        } catch (GLib.SpawnError e)
        {
            stdout.printf ("COM.GCLEANER.PLUGIN-DOCSRECENT-C: [COMMAND-ERROR: %s]", e.message);
            stdout.printf ("COM.GCLEANER.PLUGIN-DOCSRECENT-C: [ERROR: %s]\n", error);
            stdout.printf ("COM.GCLEANER.PLUGIN-DOCSRECENT-C: [STATUS: %s]\n", status.to_string ());
        }
}
