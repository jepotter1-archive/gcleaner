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

//Fork of the Function String Strip (a.k.a. 'streep') ******************************************
//Rarely vala for Ubuntu wrong calls the 'strip' function, therefore one fork is crafted *******
public string streep (string str)
{
	var result_builder = new StringBuilder ("");

	weak string i = str;

	while (i.length > 0)
	{
		unichar c = i.get_char ();
		
		if ((c == ' ') || (c =='\t'))
		{
			i = i.next_char ();
		} else {
			result_builder.append_unichar (c);
			i = i.next_char ();
		}
	}

	return result_builder.str;
}

//Calculate RAM Memory **********************************************************************
public uint64 get_mem_info_for(string name) {//This is the value obtained from the RAM, here 'strip' is used to remove the blank spaces
    uint64 result = 0;
    File file = File.new_for_path ("/proc/meminfo");//and thus be able parse String to Integer
    try {
        DataInputStream dis = new DataInputStream (file.read());
        string line;
        while ((line = dis.read_line (null,null)) != null) {
            if(line.has_prefix(name)) {
                //Part Obtained in 'kB' of String with blank spaces
                line = line.substring(name.length, line.last_index_of("kB")-name.length);
                result = uint64.parse(streep(line));
                break;
            }
        }
    } catch (Error e) {
        stderr.printf ("[ %s ]\n", e.message);
    }

    return result;
}

public string capitalize (string str)//Function that CAPITALIZED (put in MAYUS) all letters of a string
{
	var result_builder = new StringBuilder ("");

	weak string i = str;

	bool first = true;
	while (i.length > 0)
	{
		unichar c = i.get_char ();
		if (first) {
			result_builder.append_unichar (c.toupper ());
			first = false;
		} else {
				result_builder.append_unichar (c);
		}
			i = i.next_char ();
	}

	return result_builder.str;
}