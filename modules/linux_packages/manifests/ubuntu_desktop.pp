# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# This should pull whatever package(s) are appropriate to get a full desktop
# environment
class linux_packages::ubuntu_desktop {
    package {
        'ubuntu-desktop':
            ensure => latest;
    }
}
