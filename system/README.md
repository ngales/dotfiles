System dotfiles can be a bit hard to keep straight- its easy to forget the answers to questions like: Should you set environment variables in .bash_profile or .bashrc?  What is a login shell?  What's the real difference between .profile, .bash_profile, .bash_login, .bashrc, and .bash_logout?  Here's some info for your struggling memory.

Let's start with the bash-specific files .bash_profile and .bashrc, then follow up with .bash_login and .bash_logout.  We can then discuss .profile.

According to the bash man page, .bash_profile is executed for login shells, while .bashrc is executed for interactive non-login shells. A login shell is a shell where you login.  Since that's not too clear, specifically, it's generally where you login to a machine for the first time, most commonly either at signing onto a user's account at a command line at a physical machine or upon signing in via ssh remotely.  At this time .bashrc is not executed, instead it is executed upon opening an interactive shell terminal window, before the window command prompt. An interactive shell is one connected to a terminal (e.g. a terminal window) or a pseudo-terminal (e.g. a terminal emulator running under a windowing system).  Since .bashrc is not run on interactive login shells, this means that it is not typically sourced at places where .bash_profile is sourced, with some exceptions on specific platforms that are non-standard.

From this, you should takeaway that within a computing session, .bash_profile will generally be run only once and .bashrc might be run multiple times.  If you've got lengthy routines that you only want to see once per session, say, a message about recent load averages or memory usage, this would go in .bash_profile so it is not calculated every time you open a new terminal window, but instead just once.  Nowadays, machines are powerful enough that you don't have to worry about only running these sorts of things once per login. so perhaps it's not a large distinction.  A more important concern might be if you change a variable after logging in; if it was set in .bash_profile, the change would be carried to all subshells, whereas if it was set in .bashrc, the change would be reset in any new terminal windows you open.

Finally, the distinction is not even meaningful on OS X or Windows running Cygwin, as both of these environments will treat each new terminal window as a login shell-- meaning that .bash_profile is executed with every shell window opened.

.profile is similar to .bash_profile, but is more agnostic to the type of shell; it is the the login script filename originally used by /bin/sh.  bash, being generally backwards-compatible with /bin/sh, will read .profile if one exists.

.bash_login

.bash_logout is a bit different than the aforementioned configuration files.

Each of these files will also exist in a systemwide form.. sourced or not?

One final thing to keep in mind- by default, the shell will execute only a single configuration file, and there is a specific order to its decision.  The shell will look for (ordered from first to last): .profile, .bash_profile, .bash_login, .bashrc.

In practical terms, most of the time you don't want to maintain two separate configuration files for login and non-login shells (e.g. when you set a PATH, you want it to apply to both).  To fix this, chain the configuration files together, by sourcing .profile and .bashrc from your .bash_profile file-? or by sourcing .bashrc from your .bash_profile file.  If something can be in either .bash_profile or .profile, put it in .profile, so basically unless it's bash-specific.  Aliases and /___/ should go in .bashrc.