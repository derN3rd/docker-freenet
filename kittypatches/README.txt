
FNAutoPatch Enhanced v1.4
by The Kitty & Helix


== Official project website (also has many other useful tools):

  USK@~kiTTy3Rc2kOhIRnJl1P13JXtZeJSqln76h7DC3AgGw,Ocr6A3ZSED6iBZJZrCd9jTtW5JuxkRP7S4NXL9XWBgg,AQACAAE/The_Kitty/-11/


== What is it?:

AUTOMATIC FREENET NODE PATCHER AND INSTALLER
FOR LINUX AND OTHER UNIX-BASED SYSTEMS (OS X)

Allows you to easily patch Freenet with a single command.
It's time to stop trusting strangers to do it for you.

Remember: Even someone you trust today could be a government lackey tomorrow!


== What has changed in release 1.1? (by Helix):

Freenet has greatly improved its native routing and performance, which means that the original "oo" patches are way too aggressive and no longer work on the network (they were causing massive backoff).

Those older patches have been removed and switched to the "mmaalfdks" patches instead, which are very well balanced and offer both great performance *and* stability of your node's connections.


== What has changed in release 1.2? (by Helix):

The autopatcher now downloads the chosen Freenet base-installer and source code versions via GitHub (instead of FreenetProject.org), for improved anonymity.

Thanks to this change, any network-level attackers will only be able to see that you are connecting to the totally legal "github.com" site, which is an incredibly popular open-source site used by millions of people daily.

Furthermore, the base-installer and source code downloads are both performed in an encrypted manner, as always (via HTTPS), which means that any would-be attackers can only see that you're connecting to a legal site (github.com). The encryption ensures that they *cannot* see *what* project source code you're downloading from GitHub, so they have no idea that you're about to compile Freenet! ;-)


== What has changed in release 1.3? (by The Kitty):

This is a major update. The project is now maintained by The Kitty again. Thanks to Helix for helping out while I was gone!

* Added new Freenet 1469+ compilation dependencies: JUnit4 and Hamcrest.

* Changed the compilation process to automatically detect Freenet 1469+'s current filename for the BouncyCastle library (they stopped using the name "lib/bcprov.jar" and now use the full version name, such as "lib/bcprov-jdk15on-152.jar").

* Updated all speed-patches for Freenet 1469+ and added the new "oo" patches as an alternative set, since some people want to use those instead. They're more aggressive and cause more peer backoff, so it's up to you whether you want to use them or not (I don't recommend it, since the default "mmaalfdks" patches are already very fast). You can use the "oo" patches by specifying the new "-p oo" option as the final parameter on the "autopatch.sh" command line; see full description further down in the instructions.

* The patched JAR is now installed with a more descriptive name, such as "freenet_1469_fnap_default.jar" (if you install the patch for Freenet 1469 and use the default "mmaalfdks" patchset), or "freenet_1469_fnap_oo.jar" (if you use the alternative "oo" patchset). This helps you easily see which version and patchset it was built with, and makes it possible to keep multiple different versions in your Freenet folder.

* All of the regular unpatched Freenet JAR filenames are now overwritten with symlinks to the latest patched JAR, to ensure that the patched JAR is loaded no matter what JAR your Freenet installation was using: We now link "freenet.jar", "freenet.jar.new" (used if you've let Freenet auto-update itself) and "freenet-stable-latest.jar" (used by default on new installations) to the patched JAR file.

* Lastly, we've got a very nice improvement to the Freenet version info shown on the webpage. Instead of the usual "@unknown@", the version now says "Freenet x.x.x Build #xxxx (fnap-default)" (or "fnap-oo" if you used the "oo" patches instead). This lets you easily see which patchset your active Freenet node was built with!


== What has changed in release 1.4? (by The Kitty):

* Updated the patches to work with the latest Freenet sources (1478).


== How to use the automatic Freenet patcher:

* All commands below use the number 1478 as an example, which was the latest version as of this writing. Adjust that number when future releases come out.


* This tool comes with the "mmaalfdks" patches by default, which will massively speed up your Freenet traffic and will make your downloads finish in hours rather than days! You can also put additional patches into the "./patches.default" folder (or "patches.oo" if you plan to use the "oo" patches) and they will be automatically applied too, as long as their filenames end in "*.patch". Alternatively, you can create your own "patches.examplename" folder and put everything in there, and then use that patchset via the "-p examplename" option (explained further down).


* You only need to know 3 simple commands, and this README file exists to educate you on how to use them. It also helps you with some good practices for speeding up your node even more than just through the patches.


* Before proceeding, I highly recommend that Linux users install the "haveged" package and reboot their machine, because it is a Kernel-based random number generator which cuts down Freenet's node-start times to mere seconds, which is incredibly time-saving when restarting your node after patching it. To do that on Debian-based distros like Ubuntu, type:

sudo apt-get install haveged
(remember to reboot so that Haveged takes effect)


* You MUST also have the Apache ANT packager, Java JDK (compiler) and Patch utilities before proceeding! The lines below are yet again for Debian/Ubuntu but you MUST do this in whatever way your Linux distro does it since you NEED these utilities and libraries!

sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get install oracle-java7-installer ant patch

Note: If you are on OS X, you will have to install wget and ant via a terminal tool such as Homebrew. You also need to install the Java JDK.


* Now it's time to install Freenet! First install the latest, full (unpatched) Freenet version:

./baseinstall.sh 1478


* Follow the web wizard that comes up after the installation, and use these settings:

- Custom security.
- Auto update: Ask when a new version is available (so that it won't overwrite our patch automatically).
- Connect to strangers.
- Protection against strangers attacking you: NORMAL.
- Protection of your downloads, uploads and Freenet browsing cache: NONE (the queue encryption is both slow and completely useless since everything you've queued for download gets decrypted when the downloads complete anyway, and everything you've queued for upload already exists unencrypted on your disk, so those precious "encrypted queues" give absolutely ZERO security benefits for most users and are just a waste of CPU cycles)
- Datastore size: 10 GiB is a nice sweetspot but more is better if you can afford it.
- Bandwidth limit: Your up/down rates in MiB.


* Switch to advanced mode (at the bottom of the open Freenet page), and enter the "Configuration: Load management" page and double the thread limit. That will fix the issue where Freenet fills up its 500 threads and becomes unresponsive. Under heavy use with lots of downloads and page browsing, Freenet is very likely to need to use around 600-700 threads, so by doubling the thread limit you're sure to keep a good performance even in overloaded situations.

- Thread limit: 1000.
- Hit Apply at the bottom of the page. This setting immediately takes effect!


* Now enter the "Configuration: Core settings" page and tweak it as follows to optimize Freenet for RAM use rather than disk (ab)use:

- Warning: This will be limited by how much RAM you actually have in your machine, so low memory machines will not want to do ANY of these tweaks! These tweaks increase the amount of RAM that Freenet uses and greatly improves its performance, so it's really, really worth doing if you have a lot of RAM!

- Maximum memory usage: 4096 (up from 512 megabytes; anything from 2048 and up is good but 4 GB is what I highly suggest if you've got lots of RAM and a 64-bit OS)
- Encrypt the persistent temporary buckets: false (for the same reason that we're not encrypting the queues).
- Maximum size of a RAMBucket: 16 MiB (up from 2)
- Amount of RAM to dedicate to temporary buckets: 320 MiB (up from 39; this has a huge effect on reducing disk I/O)
- Encrypt the temporary buckets: false
- Maximum size of the in-memory write cache for each store (there are 9 such stores): 10 MiB (up from 1; meaning that we'll need 90 MB of RAM for this)
- Maximum time blocks will be kept in the in-memory datastore cache before being written to the store on disk: 600k (up from 300k; meaning 10 minutes instead of 5 minutes; this reduces disk I/O a bit by allowing more writes to be queued up in our new, larger in-memory write caches)
- Client cache size: 512 MiB (up from 200; this is a disk-based cache which has nothing to do with RAM, and it speeds up re-visits to Freesites)
- How long to keep data in the recent requests cache: 7200k (up from 1800k; meaning 2 hours instead of 30 minutes; this cache is for file downloads and ensures that redownloads of files can often be done from your cache rather than asking Freenet again)
- Maximum size of the recent requests cache: 128 MiB (up from 27; this uses up RAM and isn't a frequently needed feature so I kept the cache quite small)


* Now hit Apply, but DON'T click the "Restart Now" button. Instead, click "Return to your Freenet homepage", scroll down to the bottom and click the "Shutdown Freenet" button. You MUST COMPLETELY SHUT DOWN FREENET *NOW* before proceeding with the rest of this tutorial.



* Create an easy Freenet launcher by pointing this script to both your Freenet installation folder and where you want the new shortcut link to reside:

./makelauncher.sh ~/Freenet ~/Downloads/Start\ Freenet


* If you are using a modern version of Ubuntu, you won't be able to double-click that shortcut later (it will just open as a text-file). To solve that, open Ubuntu's File Explorer and go into the Edit > Preferences menu. Under the "Behavior" tab, set "Executable Text Files" to "Ask each time".


* MAKE SURE FREENET IS NOW SHUT DOWN OR YOU WILL SEVERELY CRASH THE RUNNING FREENET INSTANCE WITH THIS COMMAND! It's finally time to automatically apply the routing speed patches, build Freenet from source, and install the patched binary all in a single, magical command (adjust the "~/Freenet" path if your Freenet installation is not in the default location):

- Install the "mmaalfdks" patches (recommended):
./autopatch.sh 1478 ~/Freenet

- Alternative (uses the "oo" patches instead, *not* recommended unless you know what they do):
./autopatch.sh 1478 ~/Freenet -p oo


* Now start Freenet by double-clicking the launcher shortcut you made earlier (such as ~/Downloads/Start\ Freenet). Visit the web interface and scroll down to the bottom and verify that the version says "Freenet x.x.x Build #xxxx (fnap-default)" (or "fnap-oo" if you used the "oo" patches instead). If it does, then you are now successfully running the patched version of Freenet!


* Whenever a newer version of Freenet is released, just shut down your node and run the autopatch command again with the new version number instead. This will patch and install the latest Freenet .jar file for you automatically, with no other actions needed.


Enjoy your new, fast node!

- The Kitty

