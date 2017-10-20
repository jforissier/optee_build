**WARNING**:

This Git is **experimental**. It is an ongoing attempt at rewriting the official
OP-TEE build repository (https://github.com/OP-TEE/build) using Git submodules
instead of Google's `repo` tool. It may be incomplete, outdated, or even totally
broken.

--------------------------------------------------------------------------------

================
OP-TEE build Git
================

Here you will find all the software needed to build and run `OP-TEE OS`_ on
various platforms. There is one branch per platform (`qemu`, `hikey`, `rpi3`
and so on), as well as tags that match OP-TEE releases (`2.6.0-qemu`,
`2.6.0-hikey`, `2.6.0-rpi3`, etc.).

- Platform branches are used for development. They are not guaranteed to be
  stable, although they usually are.
- Tags are made on stable (tested) snapshots of the platform branches, using
  released OP-TEE versions.

Prerequisites
-------------

We recommend using a 64-bit Ubuntu-based Linux distribution to build this
project. A few packages need to be installed::

  sudo dpkg --add-architecture i386
  sudo apt-get update
  sudo apt-get install android-tools-adb android-tools-fastboot autoconf \
	automake bc bison build-essential ccache cscope curl \
	device-tree-compiler flex ftp-upload gdisk iasl libattr1-dev \
	libc6:i386 libcap-dev libfdt-dev libftdi-dev libglib2.0-dev \
	libhidapi-dev libncurses5-dev libpixman-1-dev libssl-dev \
	libstdc++6:i386 libtool libz1:i386 make mtools netcat python-crypto \
	python-serial python-wand unzip uuid-dev xdg-utils xterm xz-utils \
	zlib1g-dev

The cross-compilers (toolchains) are preferably downloaded by doing
``make toolchains``.

Download and build instructions
-------------------------------

Note: if you plan to work with several platforms simultaneously, it is
recommended that you use the ``gitsm`` script rather than the ``git
submodules`` commands given in the following lines. It will speed up things
by using a cache for Git submodules. Please see below for details.

Use the follwowing commands to clone the OP-TEE build project::

  # Specify a platform branch or a tag after -b
  git clone <this project's URL> -b hikey
  cd optee_build
  # Clone submodules (Linux kernel, OP-TEE, bootloader...)
  git submodule update --init
  # Optional: update optee* submodules to their latest upstream state
  git submodule update --remote optee*

To build::

  # Download the cross-compiler(s)
  make toolchains
  make -j8

The toolchains normally need to be downloaded only once. Different branches
normally share the same toolchains, but if you suspect your have build errors
due to the wrong toolchain being used, you may delete the `toolchains/``
directory and run ``make toolchains`` again.

To run:

- Most hardware platforms have a ``flash`` target to upload the binaries to the
  board. See the Makefile for platform-specific info.
- Emulated platforms (QEMU, QEMUv8, FVP) have ``make run`` and ``make
  run-only`` to boot OP-TEE and Linux in the emulated environment.

Run tests
---------

After building and booting OP-TEE and Linux as shown above, you are ready to
run the OP-TEE test suite.

Some platforms load `tee-supplicant` on boot, while others do not. Use
``ps aux | grep tee-supplicant`` to check, and if it is not loaded, run::

  tee-supplicant &

To run the OP-TEE test suite (xtest_) on the device, type::

  xtest

Please note that some error cases are tested, so you will likely see error
messages on the console. What matters is the final summary displayed by `xtest`.
It should report no failure. For instance::

  23904 subtests of which 0 failed
  79 test cases of which 0 failed
  0 test case was skipped
  TEE test application done!

Tips and Tricks
---------------

Switching platform
..................

If you have cloned a platform already, changing platform is a matter of
switching branch and updating the submodules::

  cd optee_build
  # Get up-to date branches
  git fetch
  git checkout qemu_v8
  # Synchronize submodule URLs (for instance, the linux submodule in optee
  # branch `qemu` does not use the same upstream URL than branch `hikey960`)
  git submodule sync
  # Make sure all submodules are configured (the new branch might contain new
  # submodules)
  git submodule init
  # Fetch and checkout the submodules
  git submodule update
  # Optional: get latest upstream state of optee*
  git submodule update --remote optee*

Referencing a local cache to speed up ``git submodule update``
..............................................................

Occasionally, you may want to clone and build a branch 'from scratch'. Or you
may want to have several copies of the project to build for several platform
branches simultaneously. To minimize network usage, you may use a Python script
called ``gitsm`` to set up and use a local Git cache. To install the tool, use
the following commands::

  mkdir ~/bin
  curl https://raw.githubusercontent.com/jforissier/optee_build_common/master/gitsm >~/bin/gitsm
  chmod a+x ~/bin/gitsm
  export PATH=$PATH:~/bin

Then, you may use the following commands to clone the whole OP-TEE build
environment for QEMU and QEMUv8 (for instance)::

  git clone -b qemu https://github.com/jforissier/optee_build ~/optee_build_qemu
  cd ~/optee_build_qemu
  gitsm cache
  gitsm update

  git clone -b qemu_v8 https://github.com/jforissier/optee_build optee_build_qemu_v8
  cd ~/optee_build_qemu_v8
  gitsm cache
  gitsm update

Please see ``gitsm -h`` for details, and note that sharing object references
between Git repositories *will* cause problems if the reference Git (the cache)
is deleted or becomes corrupted.

FAQ
---

Please have a look at our FAQ_ for a list of commonly asked questions and their
answers.


.. _OP-TEE OS: https://github.com/OP-TEE/optee_os
.. _xtest: https://github.com/OP-TEE/optee_test
.. _FAQ: https://github.com/OP-TEE/optee_website/tree/master/faq

