# GC cameras Ubuntu DKMS

> **Note:** the drivers packaged here do not build on kernel 7.2+
> (`linux/of_gpio.h` was removed in `gti5035`) and report front/rear facing
> swapped on the Chuwi Hi10 Max. Updated sources live in
> [gc-cameras-akmod](https://github.com/pdamonte/gc-cameras-akmod)
> (`src/gc-cameras-0.2/`); Fedora users should install that package instead.

Combined Ubuntu DKMS package for GalaxyCore GC5035 / GCTI5035 and
GC8034 / GCTI8034 camera sensors on Intel IPU6 systems.

This package builds and installs:

- `gti5035`
- `gc8034`
- patched `ipu_bridge`

It must be built on the Ubuntu system that will run the drivers, using the
headers for that exact kernel.

## Install from the APT repository

```sh
echo "deb [trusted=yes] https://pdamonte.github.io/ppa stable main" | sudo tee /etc/apt/sources.list.d/pdamonte-ppa.list
sudo apt update
sudo apt install gc-cameras-dkms
```

The APT repository is maintained at:

- <https://github.com/pdamonte/ppa>

## Manual DKMS install

```sh
sudo apt update
sudo apt install dkms build-essential v4l-utils python3-pil "linux-headers-$(uname -r)"
sudo ./install.sh
```

For a non-running target kernel:

```sh
sudo ./install.sh 6.x.y-z-generic
```

Uninstall:

```sh
sudo ./uninstall.sh
```

## Build the Debian package

```sh
./scripts/build-deb.sh
```

The output package is written to `build/deb/` and can be copied into the
`pdamonte/ppa` repository under `pool/`, then indexed with that repository's
`scripts/update-apt-repo.sh`.

## Verify

```sh
lsmod | grep -E 'gti5035|gc8034|ipu_bridge|intel_ipu6'
dmesg | grep -Ei 'GCTI5035|GCTI8034|Connected [0-9]+ cameras|intel-ipu6'
v4l2-ctl --list-devices
media-ctl -d /dev/media0 -p
```

## Capture smoke test

The capture scripts auto-detect the active pipeline from `media-ctl -p`.
They do not depend on fixed `/dev/v4l-subdev*`, `/dev/video*`, or
`/dev/media*` numbering.

```sh
sudo tools/capture-gc5035.sh /tmp/gc5035.raw /tmp/gc5035.png
sudo tools/capture-gc8034.sh /tmp/gc8034.raw /tmp/gc8034.png
```

To force a specific media controller:

```sh
sudo MEDIA_DEV=/dev/media0 tools/capture-gc5035.sh /tmp/gc5035.raw /tmp/gc5035.png
sudo MEDIA_DEV=/dev/media0 tools/capture-gc8034.sh /tmp/gc8034.raw /tmp/gc8034.png
```

The preview PNGs are grayscale dumps from raw Bayer frames. They only confirm
that streaming works.

## Related repositories

- <https://github.com/pdamonte/gc5035-dkms> - standalone GC5035 / GCTI5035 DKMS package.
- <https://github.com/pdamonte/gc8034-dkms> - standalone GC8034 / GCTI8034 DKMS package.
- <https://github.com/pdamonte/ipu-bridge-gc-cameras-akmod> - Fedora akmods package for the patched IPU bridge.
- <https://github.com/pdamonte/ppa> - static Ubuntu APT repository containing the published `.deb`.

## License

GPL-2.0-only.
