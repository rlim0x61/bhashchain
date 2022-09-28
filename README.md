# Bash script hash chain (bhashchain)
Bash script to perform hashsum calculation and comparisons between two objects: hash list files either directories.

# Description
This script computes hashes from two directories (a source directory) wich contains reliable objects that are actually on a version you trusts on, and a (destination directory) which might be changed intention or unintentionally.
When executed according to the given instructions on its help menu, this program can check if there was or there wasn't any changes to the files. It does this by computing recursivelly the hashsum of all objects from both given directories and after that presenting the results.

# Installation
git clone git@github.com:leafara1000/bhashchain.git
chmod u+x bhashchain.sh

# Usage 

#To see its help menu
./bhashchain.sh -h

Help Menu.
Usage examples:
 ./hashchain.sh -a md5sum -d [/absolute/path/to/first-directory-name/]

Description: Computes hashes from two directories,
detect and report differences on the hashchain.
Syntax: bshash [-a|d|f|g|h|v|V]
options:
-a --algorithm     md5sum|sha1sum|sha256sum|sha512sum
		   With -d calculates hash values from two directories
		   and compares the respective hash lists.
-d --directory     Asks for path and directory name input
-D --debug-info    Presents exit codes and their meaning 
-h --help          Prints help menu.
-L --license-info  Prints license information.
-V --version       Print software version and exit.

----
#To show license information
./hashchain.sh -L

bhashchain.sh computes hashes from two directories,
detect and report differences on the hashchain.
Copyright (C) 2022 by Rafael Lima
Full license notice: https://github.com/leafara1000/bhashchain/blob/main/LICENSE

----

#To compare the hashchain from two directories
./bhashchain.sh -a md5sum|sha1sum|sha256sum|sha512sum [/absolute/path/to/first-directory-name/]

dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
d                                                              d
d [+] DATA INPUT: please insert the following information:     d
d                                                              d
dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd

Path AND name to directory 2:[/absolute/path/to/second-directory-name/]

# Contributing
If you have any ideas or feedbacks to share and to contribute with this project, just let me know.
You can talk to me by sending an e-mail to: username@mail either by forking or reporting issues. 
Thanks for any help in advance.

# License
This project is licensed under the GNU General Public License v3.0
