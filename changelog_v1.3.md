# addwnet #
v1.3 CHANGELOG


Fixes:

General ease of use functionality improved.

Help command (-h) has been improved. Organized and more detailed information.

Access points with no security can now be added without special precedures by simply entering a dash, '-' as password.

Addwnet will now promt user to run with elevated privilages instead of showing permission errors when trying to run as user.



Added functions:

-Restore. Its now possible to revert the last change made to the network config with the -r command.

-List networks. The command -l <..> will list information about your networks.

-Current network connection. The command -l -c displays what network you currently are connected to. 

-Network list. A list with all the stored networks including which you currently are connected to, and their priority level can be viewed with command -l -a.

-Priority. When adding new networks you can designate them connection priority. Details in help command.

-Restart networking services. You can now restart the linux networking services with the command restart.

-
See help -h for instructions.