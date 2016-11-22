init.sh
=======

A simple shell file to run shell scripts.

## Summary

I created this so I can easily create shell scripts inside a folder that will be executed
every time I log in into my computer.

The use case is mostly personal, I wanted to create this things dinamically (via provisioning)
and wanted something OS/DM agnostic, so I thought a shell script would be the perfect
solution.

Since I use i3 as of now and its config file can't import other config files (so I could
have different init scripts and stuff based on the current machine) now I just have an
`exec bash ~/.init.sh` to get everything started and i3 (or the DM I'm using) doesn't care
about what I load.

## How it works

Once you have your script *installed* and setup your system to execute it on login, it will
execute every script on the `~/.init` path on background, storing a pidfile based on the
script's name with the PID so if you execute the `init.sh` script again it can check
if the process is still running so we do not launch it twice.

The script also redirects *stdout* and *stderr* to `/tmp/initsh` to debug or check your
scripts for malfunction.
