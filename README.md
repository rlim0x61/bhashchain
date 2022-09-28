# Bash script hash chain (bhashchain)
It is a bash script that takes two directories, computes hashes from all objects stored on each of them, then detects and reports differences on the hashchain. 

# Description
This script computes hashes from two directories (a source directory) wich contains reliable objects that are actually on a version you trusts on, and a (destination directory) which might be changed intention or unintentionally.
When executed according to the given instructions on its help menu, this program can check if there was or there wasn't any changes to the files. It does this by computing recursivelly the hashsum of all objects from both given directories and after that presenting the results.

# Installation
git clone https://github.com/rlim0x61/bhashchain.git
chmod u+x bhashchain.sh

Just in case you see some "permission denied" messages:

- check file permission and ownership: ls -la
- make necessary changes by using chmod or chown

# Usage 

![help_menu](https://user-images.githubusercontent.com/39169975/192855594-4b0e9834-c241-431d-bccd-a6d4488e9200.png)

----
#To show license information
./hashchain.sh -L

bhashchain.sh computes hashes from two directories, detect and report differences on the hashchain.
Copyright (C) 2022 by Rafael Lima
Full license notice: https://github.com/rlim0x61/bhashchain/blob/main/LICENSE

----

#To compare the hashchain from two directories
./bhashchain.sh -a md5sum|sha1sum|sha256sum|sha512sum [/absolute/path/to/first-directory-name/]

![all_hashes_match](https://user-images.githubusercontent.com/39169975/192855920-c2370e6d-0623-4859-ac8e-09b790434356.png)

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

# Tested on
Ubuntu 20.04.5 LTS
Codename: focal
