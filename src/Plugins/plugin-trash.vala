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
public string path_trash_files;
public string path_trash;

public void msg_trash_pathNotFound (Window win)
{   
    Gtk.MessageDialog pathTrashNotFound = new Gtk.MessageDialog (win, DialogFlags.DESTROY_WITH_PARENT, MessageType.WARNING, ButtonsType.OK, "¡No se pudo analizar la papelera de reciclaje! Pruebe manualmente eliminar un archivo y vaciar la Papelera de Reciclaje.");
    pathTrashNotFound.set_title("Advertencia... Papelera de Reciclaje");
    pathTrashNotFound.show ();
	pathTrashNotFound.response.connect (() => {
		pathTrashNotFound.destroy ();
	});
}

public void msg_cmdTrash_Failed (Window win)
{   
    var cmdTrashFailed = new MessageDialog (win, DialogFlags.DESTROY_WITH_PARENT, MessageType.WARNING, ButtonsType.OK, "¡No se pudo limpiar la Papelera de Reciclaje! Pruebe nuevamente y verifique su contraseña.");
    cmdTrashFailed.set_title("Advertencia... Limpiando Papelera de Reciclaje");
    cmdTrashFailed.run ();
    cmdTrashFailed.destroy ();        
}

public string get_trash_params ()
{
    string home = GLib.Environment.get_variable ("HOME");
    path_trash_files = home + "/.local/share/Trash/files/";
    File file = File.new_for_path (path_trash_files);

    if (file.query_exists ())
    {
        return path_trash_files;
        } else {
            try
            {
                Process.spawn_command_line_sync ("mkdir -p " + path_trash_files);
                return path_trash_files;
                } catch (GLib.SpawnError e)
                {
                    stdout.printf ("COM.GCLEANER.PLUGIN-TRASH-S: [COMMAND-ERROR: %s]", e.message);
                    return "error";
                }
    }
}

public int trash_clean (Window win)
{
    string home = GLib.Environment.get_variable ("HOME");
    path_trash = home + "/.local/share/Trash/";
    string error;
    int status;
    try
    {
        Process.spawn_command_line_sync ("gksu --message \"Se necesita privilegios de administrador para limpiar los archivos de ROOT\" \"rm -rf " + path_trash + "\"", null, out error, out status);
        if (status != 0)
        {
            //Show MsgBox with Error
            msg_cmdTrash_Failed (win);
            return 1;
        } else {
            return 0;
        }
        } catch (GLib.SpawnError e)
        {
            stdout.printf ("COM.GCLEANER.PLUGIN-TRASH-C: [COMMAND-ERROR: %s]", e.message);
            stdout.printf ("COM.GCLEANER.PLUGIN-TRASH-C: [ERROR: %s]\n", error);
            stdout.printf ("COM.GCLEANER.PLUGIN-TRASH-C: [STATUS: %s]\n", status.to_string ());
            return 1;
        }
}
