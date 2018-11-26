# Install Automation

A bunch of script to automate computer installation.
This is an easy way to record a clean configuration state for a set of
computers (whether physical or virtual).
The scripts here only care about the configuration and not about the data.
Use a backup manager for this task.

## What it contains

There are two components: the `script`s and the `package`s.
The scripts are used in the early phases of installation, when the new
system does not even exist while the packages are used to do most of the
work. An additional component, the `archiso` contains what is necessary to
create installation ISO (basing on the standard Archlinux ISO images).
