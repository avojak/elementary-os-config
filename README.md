This script is intended for me to configure an elementary OS workstation from a clean install after setting up the user account. The goal is to install a few packages for development work and set any display resolution settings if running from a VM with a scaled display.

Usage:

```bash
$ bash <(wget -qO- https://raw.githubusercontent.com/avojak/elementary-os-config/master/download-and-run.sh)
```

If you run into an issue during the Ansible portion, you can re-run just the `run.sh` script from the directory.

TODO:

[ ] Set scaling factor
