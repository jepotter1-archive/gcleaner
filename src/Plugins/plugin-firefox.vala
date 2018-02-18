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
public string path_ffox;
public string complete_path;

public void msg_firefox_profileNotFound (Window win)
{   
    var profileFirefoxNotFound = new MessageDialog (win, DialogFlags.DESTROY_WITH_PARENT, MessageType.WARNING, ButtonsType.OK, "¡Error al buscar el Perfil de Usuario en Mozilla Firefox! Abra nuevamente Firefox para comprobar que todo este bien y pruebe nuevamente.");
    profileFirefoxNotFound.set_title("Advertencia... Perfil de Firefox");
    profileFirefoxNotFound.run ();
    profileFirefoxNotFound.destroy ();        
}

public string get_complete_path (File file, string space = "", Cancellable? cancellable = null)
{
    FileEnumerator enumerator = null;
    try
    {
        enumerator = file.enumerate_children (
            "standard::*",
            FileQueryInfoFlags.NOFOLLOW_SYMLINKS, 
            cancellable);
        } catch (GLib.Error e) {
            stdout.printf ("COM.GCLEANER.PLUGIN-FIREFOX-S: [ERROR CREANDO VARIABLE DE PERFIL] %s", e.message);
        }

    FileInfo info = null;

    try
    {
        info = enumerator.next_file (cancellable);
        } catch (GLib.Error e) {
        stdout.printf ("COM.GCLEANER.PLUGIN-FIREFOX-S: [ERROR ASIGNANDO PERFIL] %s\n", e.message); 
    }

        if (info.get_file_type () == FileType.DIRECTORY)
        {
            return info.get_name ();
        } else {
            stdout.printf ("COM.GCLEANER.PLUGIN-FIREFOX-S: [OCURRIO UN ERROR BUSCANDO EL PERFIL]\n");
        }

    return "null";
}

public string get_firefox_profile ()
{
    string home = GLib.Environment.get_variable ("HOME");
    path_ffox = home + "/.cache/mozilla/firefox/";
    
    string perfilName;

    File file = File.new_for_path (path_ffox);

    perfilName = get_complete_path (file, "", new Cancellable ());

    complete_path = path_ffox + perfilName;

    if (perfilName != "null")
    {
        return complete_path;
        } else {
        return "error";      
    }
}

public void firefox_clean ()
{
    //AREAS QUE LIMPIA
    string cache        = "Cache";
    string cache2       = "cache2";
    string cacheInicio  = "startupCache";
    string cacheOffline = "OfflineCache";
    string navPrivada   = "safebrowsing";
    string miniaturas   = "thumbnails";

    string error;
    int status;

    try
    {
        //BORRAR CACHE ***************************************************************************
        Process.spawn_command_line_sync ("rm -rf " + complete_path + "/" + cache, null, out error, out status);

        //BORRAR CACHE2 **************************************************************************
        Process.spawn_command_line_sync ("rm -rf " + complete_path + "/" + cache2, null, out error, out status);

        //BORRAR CACHE DE INICIO *****************************************************************
        Process.spawn_command_line_sync ("rm -rf " + complete_path + "/" + cacheInicio, null, out error, out status);

        //BORRAR CACHE OFFLINE *******************************************************************
        Process.spawn_command_line_sync ("rm -rf " + complete_path + "/" + cacheOffline, null, out error, out status);
        
        //BORRAR DATOS DE NAVEGACION PRIVADA ****************************************************
        Process.spawn_command_line_sync ("rm -rf " + complete_path + "/" + navPrivada, null, out error, out status);

        //BORRAR MINIATURAS ********************************************************************
        Process.spawn_command_line_sync ("rm -rf " + complete_path + "/" + miniaturas, null, out error, out status);
        } catch (GLib.SpawnError e)
        {
            stdout.printf ("COM.GCLEANER.PLUGIN-FIREFOX-C: [COMMAND-ERROR: %s]", e.message);
            stdout.printf ("COM.GCLEANER.PLUGIN-FIREFOX-C: [ERROR: %s]\n", error);
            stdout.printf ("COM.GCLEANER.PLUGIN-FIREFOX-C: [STATUS: %s]\n", status.to_string ());
        }
}