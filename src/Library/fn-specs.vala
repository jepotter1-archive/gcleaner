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
private string os;
private string version;
private string codename;
private string os_completo;
private string memory;
private string arquitectura;
private	string arch;
private string processor;
private string graphics;


/*PC Architecture*/
public string getArchitecture ()
{	

	 //Architecture
        try {
            Process.spawn_command_line_sync ("uname -m", out arch);//command that keeps in 'arch' raw architecture
            if (arch == "x86_64\n") {
                arch = "64-bit";//It becomes more legible the architecture
            } else if ("arm" in arch) {
                arch = "ARM";
            } else {
                arch = "32-bit";
            }
        } catch (Error e) {//In case of not match any of the above is taken for unknown the architecture
            stderr.printf ("COM.GCLEANER.APP.SPECS: [ERROR:: No se pudo establecer la arquitectura: [ %s ]]\n", e.message);
            arch = "NO ARCH";
        }

        return arch;
}

/*Operating System, Version and Codename*/
public string getOS ()
{
	//System Operating information
		File file = File.new_for_path ("/etc/lsb-release");//Save in 'file' the contents of '/etc/lsb-release'
		try {
			var dis = new DataInputStream (file.read ());//Dump the contents of 'file' to 'dis' to process information
			string line;


			while ((line = dis.read_line (null)) != null) {//Read line by line
				if ("DISTRIB_ID=" in line) {//If find the Distributor ID clean in a variable the value of the same
					os = line.replace ("DISTRIB_ID=", "");
					if ("\"" in os) {
						os = os.replace ("\"", "");
					}
				} else if ("DISTRIB_RELEASE=" in line) {
					version = line.replace ("DISTRIB_RELEASE=", "");
				} else if ("DISTRIB_CODENAME=" in line) {
					codename = line.replace ("DISTRIB_CODENAME=", "");
					codename = capitalize (codename);
				}
			}
		} catch (Error e) {//In case of not find the file, handled the Error
			stderr.printf ("COM.GCLEANER.APP.SPECS: [ERROR::OS] No se pudo leer el archivo /etc/lsb-release: [ %s ]\n", e.message);
			os = "Desconocido";
			version = "X";
			codename = "No encontrado";
		}

		arquitectura = getArchitecture ();//The architecture is obtained to build the entire chain of the operating system
		os_completo = os + " " + version + " (" + codename + ") " + arquitectura;

		return os_completo;
}

//MEMORY RAM ********************************************************************************
public string getMemory ()
{							//Funcion propia que trata el valor obtenido de la memoria RAM
	memory = GLib.format_size (get_mem_info_for("MemTotal:") * 1024, FormatSizeFlags.IEC_UNITS);
	return memory;
}

//PC Processor ************************************************************************
public string getProcessor ()
{
	try {
            Process.spawn_command_line_sync ("sed -n 's/^model name[ \t]*: *//p' /proc/cpuinfo", out processor);
            int cores = 0;
            foreach (string core in processor.split ("\n")) {
                if (core != "") {
                    cores++;
                }
            }
            if ("\n" in processor) {//It is checking to establish more legible according trademark or group
                processor = processor.split ("\n")[0];
            } if ("(R)" in processor) {
                processor = processor.replace ("(R)", "®");
            } if ("(TM)" in processor) {
                processor = processor.replace ("(TM)", "™");
            }
        } catch (Error e) {
            stderr.printf ("COM.GCLEANER.APP.SPECS: [ERROR:: No se encontro el procesador: [ %s ]]\n", e.message);
            processor = "Procesador Desconocido";
        }

        return processor;
}

//GRAPHICS (VIDEO CARD) *********************************************************
public string getGraphics ()
{
	// Graphics
       try {
           Process.spawn_command_line_sync ("lspci", out graphics);
           if ("VGA" in graphics) { //VGA-keyword indicates graphics-line
               string[] lines = graphics.split("\n");
               graphics="";
               foreach (var s in lines) {
                   if ("VGA" in s || "3D" in s) {
                       string model = get_graphics_from_string(s);//Proper function that deals the models of video cards
                       if(graphics=="")
                           graphics = model;
                       else
                           graphics += "\n" + model;
                   }
               }
           }
       } catch (Error e) {
           stderr.printf ("COM.GCLEANER.APP.SPECS: [ERROR::Placa de Video [ %s ]]\n", e.message);
           graphics = "Video Desconocido";
       }

       return graphics;
}