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

public string get_graphics_from_string (string graphics)
{
        //In this line we have the correct output of lspci
        //as the output now takes the form of "00:01.0 VGA compatible controller:Info"
        //and as we look for the <Info>, separated with ":" and get the 3rd part
        string[] parts = graphics.split(":");
        string result = graphics;
        if (parts.length == 3)
            result = parts[2];
        else if (parts.length > 3) {
            result = parts[2];
            for (int i = 2; i < parts.length; i++) {
                result+=parts[i];
            }
        }
        else {
            warning("Unknown LSPCI format: "+parts[0]+parts[1]);
            result = "Unknown"; //set back to unkown
        }
        
        if ("Intel" in processor) {
                return "Video Intel";
        }

		if ("NVIDIA" in processor) {
                return "Video NVIDIA";
        }

        if ("AMD" in processor) {
                return "Video AMD";
        }        

        if ("Radeon" in processor) {
                return "Video AMD Radeon";
        }        

    	return "VIDEO DESCONOCIDO";
}