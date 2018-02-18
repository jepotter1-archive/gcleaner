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
public string path_packages;
public string list;

public void msg_cacheAptPackages (Window win)
{   
    var pathTrashNotFound = new MessageDialog (win, DialogFlags.DESTROY_WITH_PARENT, MessageType.WARNING, ButtonsType.OK, "¡No se pudieron analizar los paquetes de APT! Pruebe nuevamente y compruebe de que APT funcione correctamente.");
    pathTrashNotFound.set_title("Advertencia... Paquetes de APT");
    pathTrashNotFound.run ();
    pathTrashNotFound.destroy ();        
}

public void msg_cmdPackage_Failed (Window win)
{   
    var cmdPackageFailed = new MessageDialog (win, DialogFlags.DESTROY_WITH_PARENT, MessageType.WARNING, ButtonsType.OK, "¡No se pudo limpiar los paquetes de APT! Pruebe nuevamente y verifique su contraseña.");
    cmdPackageFailed.set_title("Advertencia... Limpiando Paquetes");
    cmdPackageFailed.run ();
    cmdPackageFailed.destroy ();        
}

public void msg_dpkgBusy (Window win)
{   
    var dpkgBusy = new MessageDialog (win, DialogFlags.DESTROY_WITH_PARENT, MessageType.WARNING, ButtonsType.OK, "¡No se pudo analizar las configuraciones de paquetes porque DPKG se encuentra ejecutado ya en otra instancia! Espere porfavor a que termine la instancia ejecutada de DPKG e intentelo nuevamente.");
    dpkgBusy.set_title("Advertencia... Limpiando Configuracion de Paquetes");
    dpkgBusy.run ();
    dpkgBusy.destroy ();        
}

public string get_packages_params ()
{
    path_packages = "/var/cache/apt/archives";
    File file = File.new_for_path (path_packages);

    if (file.query_exists ())
    {
        return path_packages;
        } else {
            stdout.printf ("COM.GCLEANER.PLUGIN-PACKAGES-S: [PATH-ERROR]");
            return "error";
        }
}

public int packages_clean (Window win)
{
    string error;
    int status;
    try
    {
        Process.spawn_command_line_sync ("gksu --message \"Se necesita privilegios de administrador para limpiar la cache de APT\" -- bash -c \"rm -rf " + path_packages + "/*; apt-get clean; apt-get autoclean" + "\"", null, out error, out status);
        if (error != "")
        {
            //imprimir MsgBox de Error
            msg_cmdPackage_Failed (win);
            return 1;
        } else {
            return 0;
        }
        } catch (GLib.SpawnError e)
        {
            stdout.printf ("COM.GCLEANER.PLUGIN-PACKAGES-C: [COMMAND-ERROR: %s]", e.message);
            stdout.printf ("COM.GCLEANER.PLUGIN-PACKAGES-C: [ERROR: %s]\n", error);
            stdout.printf ("COM.GCLEANER.PLUGIN-PACKAGES-C: [STATUS: %s]\n", status.to_string ());
            return 1;
        }
}
// **************************************** PACKAGE CONFIG *************************************************
public int packageconfig_scan ()
{
    string home = GLib.Environment.get_variable ("HOME");
    string list_of_packages;
    list_of_packages = home + "/.cache/gcleaner-packageconfig-list";
    try
    {
        Process.spawn_command_line_sync ("bash -c \"dpkg -l | grep '^rc  ' | awk '{print $2}' > " + list_of_packages + "\"");
        return 0;
    } catch (GLib.SpawnError e)
    {
        stdout.printf ("COM.GCLEANER.PLUGIN-PACKAGES-S: [ERROR PKGCONFIG: %s]", e.message);
        return 1;
    }
}

public int armar_lista_paquetes ()
{
    int pkg_count;
    pkg_count = 0;
    string home = GLib.Environment.get_variable ("HOME");
    string list_of_packages;

    list = "";

    list_of_packages = home + "/.cache/gcleaner-packageconfig-list";
    File file = File.new_for_path (list_of_packages);

    try
    {
        var dis = new DataInputStream (file.read ());
        string line;
        string aux = "";

        while ((line = dis.read_line (null)) != null)
        {
            aux = list;
            list = aux + " " + line;
            pkg_count = pkg_count + 1;
        }
    } catch (Error e)
    {
            stderr.printf ("COM.GCLEANER.PLUGIN-PACKAGES-S: [NO SE PUDO LEER EL ARCHIVO DE CONFIGURACION DE PAQUETES]");
            pkg_count = -1;
    }
    return pkg_count;
}

public string get_packageconfig_list () { return list; }

public void packageconfig_clean ()
{
    try
    {    
        Process.spawn_command_line_sync ("gksu --message \"Se necesita privilegios de administrador para limpiar la configuracion de los paquetes no desinstalados completamente.\" -- bash -c \"dpkg --purge" + list + "\"");
    } catch (GLib.SpawnError e)
    {
        stdout.printf ("COM.GCLEANER.PLUGIN-PACKAGES-C: [ERROR PKGCONFIG: %s]", e.message);
    }
}