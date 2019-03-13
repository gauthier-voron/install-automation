# Install Automation

A bunch of script to automate computer installation.
This is an easy way to record a clean configuration state for a set of
computers (whether physical or virtual).
The scripts here only care about the configuration and not about the data.
Use a backup manager for this task.

## Build instructions

To build the installation iso, type `make all`. You obtain a modified archlinux
installation iso that launches automatically a custom and *machine specific*
install. Burn this iso on a CD-ROM or on a USB key to use it.
