# lazyFreeBSDDesktop

*lazyFreeBSDDesktop* is a collection of shell scripts to setup a Desktop with packages on a fresh installed FreeBSD. 
I started in Summer 2025 with this collection, because i love to setup FreeBSD on different machines but I'm too lazy to do all the steps manually over and over again. 

Tested with FreeBSD `14.3` and initial with `15.0`, but **use at your own risk!**

## Scripts 

- **installDesktop.sh** Call a minimal collection of scripts:
  - **recommended for install and setup a Desktop without any other changes.**
  - *Update:* update this current packages
  - *Graphic Driver Selection:* see also `freeBSD_graphic_drivers.sh`
  - *Display Manager:* Select and install a display manager see also `freeBSD_DM_select.sh`
  - *Window Manager:* Select basic package list - see also `freeBSD_basic_packages.sh` 
  
---

- **lazyFreeBSDDesktop.sh** Call a collection of scripts:
  - *Fasterboot* see also `freeBSD_fasterboot.sh`
  - *Update* update this current packages
  - *Musthave* see also `freeBSD_musthave.sh`
  - *Graphic Driver Selection* see also `freeBSD_graphic_drivers.sh`
  - *Select package list* At the moment there are two package installer lists `toms` (my nickname) and `xfce` see also `freeBSD_toms_packages.sh` and `freeBSD_xfce4_packages.sh` 
  - *Prepate overlays*
    - copy files overlays to /usr/share/skel/dot.config/
    - backgrounds + icons to /opt/local/share/.
    - install a i386 wine to /opt/local which can be linked to home directory instead of every user have to install it
  - *Prepare user* see also `freeBSD_prepare_user.sh`

---
  
- **freeBSD_fasterboot.sh:** set different parameters in rc.conf and loader.conf to speed up the boot loading

- **freeBSD_musthave.sh**
  - DBUS and FUSEFS will be added
  - Polkit rule for user mount
  - Install sudo, allow wheel and set to noargs

- **freeBSD_graphic_drivers.sh:** install your manually selected you graphic driver.

- **freeBSD_toms_packages.sh:** select packages premade by me, select a display manager and install them if possible

- **freeBSD_basic_packages.sh:** select packages from a basic package list premade by me, select a display manager and install them if possible

- **freeBSD_DM_select.sh** select and install a display manager

- **freeBSD_xfce4_packages.sh:** like freeBSD_toms_packages.sh but only for xfce with lightdm and less packages to select

- **freeBSD_prepare_user.sh:** setup selected user for wine-i386, group Video and custom .config

- **freeBSD_updatecheck.sh** install an system to notify the user about updates see also `files/updatecheck/README`

## Lenovo Scripts

The scripts can be found in ./notebook

- **thinkpad.sh** a basic add on for Thinkpads. Called by the other scripts below:
- **x260.sh** script for the Thinkpad X 260 to setup sound and modules
- **e531.sh** script for Thinkpad E 531 to setup sound and modules
- **ideapadS10_3.sh** I guess i'am the last one on earth using this netbook with FreeBSD. Useful to setup the old intel graphic so I was able to play my game Auteria with 10 fps 🙃

## Other Scripts
 - **freeBSD_current.sh** This sets FreeBSD to current repos. It's maybe obsolete i used it with FreeBSD 14.3, but with 15 it should *not* be used.
 - **freeBSD_brokenConsole.sh** fix tty, when you go from desktop to tty and it looks like an old 8 bit game.
 - **freeBSD_steam.sh** **experimental** steam setup - setup user "steam" and all the stuff to run steam - i tested it once but would not use it.
