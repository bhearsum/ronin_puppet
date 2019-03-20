# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

class roles_profiles::profiles::vnc {

    case $::operatingsystem {
        'Windows': {

            $firewall_allowed_ips = lookup('win_dc_jumphosts')
            $pw_hash              = lookup('win_vncpw_hash')
            $read_only_pw_hash    = lookup('win_readonly_vncpw_hash')
            $ini_file             = "${facts['custom_win_programfiles']}\\uvnc bvba\\UltraVNC\\ultravnc.ini"
            $package              = 'UltraVnc'
            $msi                  = 'UltraVnc_1223_X64.msi'
            $firewall_port        = 5900
            $firewall_name        = 'UltraVNC'

            class { 'win_ultravnc':
                package           => $package,
                msi               => $msi,
                ini_file          => $ini_file,
                pw_hash           => $pw_hash,
                read_only_pw_hash => $read_only_pw_hash
            }
            case $facts['custom_win_mozspace'] {
                # Restrict VNC access in datacenters to jump hosts.
                'mdc1', 'mdc2': {
                    win_firewall::open_local_port { "allow_${name}":
                        port            => $firewall_port,
                        remote_ip       => $firewall_allowed_ips,
                        reciprocal      => false,
                        fw_display_name => $firewall_name,
                    }
                }
                default : {
                    # No restrictions by default. The UltraVNC install typical opens the needed port.
                }
            }
            # Bug List
            #
            # TODO Add 32 bit support
        'Darwin': {
            include macos_utils::enable_screensharing
        }
        default: {
            fail("${::operatingsystem} not supported")
        }
    }
}
