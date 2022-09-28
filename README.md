# Bash script hash chain (bhashchain)
Bash script to perform hashsum calculation and comparisons between two objects: hash list files either directories.

# Description
This script computes hashes from two directories (a source directory) wich contains reliable objects that are actually on a version you trusts on, and a (destination directory) which might be changed intention or unintentionally.
When executed according to the given instructions on its help menu, this program can check if there was or there wasn't any changes to the files. It does this by computing recursivelly the hashsum of all objects from both given directories and after that presenting the results.

# Installation
git clone git@github.com:leafara1000/bhashchain.git
chmod u+x bhashchain.sh

# Usage 

#To see the help menu
./bhashchain.sh -h

![help_menu](https://user-images.githubusercontent.com/39169975/192777833-01c348d8-0461-42f5-a5d1-501a94907d0d.png)

----
#To show license information
./hashchain.sh -L

bhashchain.sh computes hashes from two directories, detect and report differences on the hashchain.
Copyright (C) 2022 by Rafael Lima
Full license notice: https://github.com/leafara1000/bhashchain/blob/main/LICENSE

----

#To compare the hashchain from two directories
./bhashchain.sh -a md5sum|sha1sum|sha256sum|sha512sum [/absolute/path/to/first-directory-name/]

[+] DATA INPUT: please insert the following information:
Path AND name to directory 2:[/absolute/path/to/second-directory-name/]

# Contributing
If you have any ideas or feedbacks to share and to contribute with this project, just let me know.
You can talk to me by sending an e-mail to: username@mail either.
You can fork this project, report issues and propose new features. 

To contribute:

- Write or fix function codes to propose new features or to improve the current ones;
- Insert comments to help understand what your code does;
- Inside functions, declare variables as local;
- When submitting pull requests, include a brief summary of what you've done.

Thanks for any help in advance!

# License
This project is licensed under the GNU General Public License v3.0
