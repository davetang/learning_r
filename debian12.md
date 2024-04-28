# Installing on Debian 12

[Official instructions](https://cran.r-project.org/bin/linux/debian/).

The following was run on:

```console
cat /etc/os-release
```
```
PRETTY_NAME="Debian GNU/Linux 12 (bookworm)"
NAME="Debian GNU/Linux"
VERSION_ID="12"
VERSION="12 (bookworm)"
VERSION_CODENAME=bookworm
ID=debian
HOME_URL="https://www.debian.org/"
SUPPORT_URL="https://www.debian.org/support"
BUG_REPORT_URL="https://bugs.debian.org/"
```

Add the following line to `/etc/apt/sources.list`:

```
deb http://cloud.r-project.org/bin/linux/debian bookworm-cran40/
```

Then run:

```console
sudo apt update
```

If you get the following error:

```
W: GPG error: http://cloud.r-project.org/bin/linux/debian bookworm-cran40/ InRelease: The following signatures couldn't be verified because the public key is not available: NO_PUBKEY B8F25A8A73EACF41
E: The repository 'http://cloud.r-project.org/bin/linux/debian bookworm-cran40/ InRelease' is not signed.
N: Updating from such a repository can't be done securely, and is therefore disabled by default.
N: See apt-secure(8) manpage for repository creation and user configuration details.
```

You can fetch the key from the keyserver run by the Ubuntu project:

```console
gpg --keyserver keyserver.ubuntu.com --recv-key '95C0FAF38DB3CCAD0C080A7BDC78B2DDEABC47B7'
```

Then you export it and write it to the directory where apt will trust it (overwriting any pre-existing file with the same name, if existing):

```console
gpg --armor --export '95C0FAF38DB3CCAD0C080A7BDC78B2DDEABC47B7' | sudo tee /etc/apt/trusted.gpg.d/cran_debian_key.asc
```

Then `sudo apt update` should up date all packages. Then install.

```console
sudo apt update
sudo apt install -y r-base
```

R version.

```console
R --version
```
```
R version 4.4.0 (2024-04-24) -- "Puppy Cup"
Copyright (C) 2024 The R Foundation for Statistical Computing
Platform: x86_64-pc-linux-gnu

R is free software and comes with ABSOLUTELY NO WARRANTY.
You are welcome to redistribute it under the terms of the
GNU General Public License versions 2 or 3.
For more information about these matters see
https://www.gnu.org/licenses/.
```
