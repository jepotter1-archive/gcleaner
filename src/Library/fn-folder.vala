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

public string to_file_size_format (int64 bytes)
{
    float size;
    string format = "";
    size = bytes / 1000;
    if (size < 1000)
    {
        size = Math.roundf (size * 100) / 100;
        format = size.to_string () + " KB";
      } else {
          size = size / 1000;
          if (size < 1000)
          {
              size = Math.roundf (size * 100) / 100;
              format = size.to_string () + " MB";
            } else {
                size = size / 1000;
                if (size < 1000)
                {
                    size = Math.roundf (size * 100) / 100;
                    format = size.to_string () + " GB";
                }
          }
    }

    return format;
}

namespace GCleaner.Tools
{
  public class Scanner : GLib.Object {

    /*
     * Local Variables
     */
    public int64 contador;
    public int64 fileSize;

    public Scanner ()
    {
      contador = 0;
      fileSize = 0;
    }

    /*
     * Function to search for files and folder size
     */
    private int64[] listar_contenido (File file, string space = "", Cancellable? cancellable = null, GCleaner.Tools.InventoryPaths? inventory = null) throws Error
    {
      int64[] valores = new int64[2];
      FileEnumerator enumerator;

      try {
        enumerator = file.enumerate_children (
          "standard::*",
          FileQueryInfoFlags.NOFOLLOW_SYMLINKS, 
          cancellable);
      } catch (IOError e) {
        stderr.printf ("COM.GCLEANER.FN-FOLDER: [WARNING: Unable to access the path '%s': %s\n", file.get_path (), e.message);
        valores[0] = 0;
        valores[1] = 0;
        return valores;
      }  

      FileInfo info = null;
      while (cancellable.is_cancelled () == false && ((info = enumerator.next_file (cancellable)) != null))
      {
        if (info.get_file_type () == FileType.DIRECTORY)
        {
          File subdir = file.resolve_relative_path (info.get_name ());
          listar_contenido (subdir, space + " ", cancellable, inventory);
          //contador = contador + 1;//Folder Count
         } else {
          contador = contador + 1;//Files Count
          fileSize = fileSize + info.get_size ();
          inventory.add (file.get_uri () + "/" + info.get_name ());
        }
      }

      if (cancellable.is_cancelled ())
      {
        throw new IOError.CANCELLED ("Operation was cancelled");
      }

      valores[0] = contador;
      valores[1] = fileSize;

      return valores;
    }

    public int64[] get_file_folderSize (string path, GCleaner.Tools.InventoryPaths inventory)
    {
      //Variables Locales
      int64[] data = null;

      //Setear Variables Locales
      contador = 0;
      fileSize = 0;
      if (path == "")
      {
            stdout.printf ("COM.GCLEANER.FN-FOLDER [DIRECTORIO NO VALIDO: %s]\n", path);
        } else {
            File file = File.new_for_path (path);

            try
            {
                data = listar_contenido (file, "", new Cancellable (), inventory);
              } catch (Error e) {
                stdout.printf ("COM.GCLEANER.FN-FOLDER [Error: %s]\n", e.message);
                stdout.printf (">>> Comprobar ruta: %s", path);
            }
      }
      
      return data;
    }
  }
}