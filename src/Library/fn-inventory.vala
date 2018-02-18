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

namespace GCleaner.Tools
{
	public class InventoryPaths : GLib.Object {

		/*
     	 * Local Variables
     	 */
     	public Array<string> paths;

     	public InventoryPaths ()
	    {
	      paths = new Array<string> ();
	    }

	    /*
	     * Inventory Methods
	     */

	    public void add (string file_path) {
	    	paths.append_val (file_path);
	    }

	}
}