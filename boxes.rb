#!/usr/bin/ruby
#

APT_ENV_VARS = {
  'DEBIAN_FRONTEND': 'noninteractive',
  'DEBCONF_NONINTERACTIVE_SEEN': true,
}

INSTALL_ENV_VARS = {
  'VAGRANT_virtualbox_VERSION': ENV.fetch('QA_VAGRANT_virtualbox_VERSION', 'latest'),
}

BOXES = {
  'ubuntu' => {
    :virtualbox => {
      :box => "generic/ubuntu1804",
      :provision => [
        {:inline => 'ln -sf ../run/systemd/resolve/resolv.conf /etc/resolv.conf'},
      ],
    }
  },
  'ubuntu-18.04' => {
    :virtualbox => {
      :box => "generic/ubuntu1804",
      :provision => [
        {:inline => 'ln -sf ../run/systemd/resolve/resolv.conf /etc/resolv.conf'},
      ],
    },
  },
  'ubuntu-20.04' => {
    :virtualbox => {
      :box => "generic/ubuntu2004",
      :provision => [
        {:inline => 'ln -sf ../run/systemd/resolve/resolv.conf /etc/resolv.conf'},
      ],
    },
  },
  'ubuntu-22.04' => {
    :virtualbox => {
      :box => "generic/ubuntu2204",
      :provision => [
        {:inline => 'ln -sf ../run/systemd/resolve/resolv.conf /etc/resolv.conf'},
      ],
    },
  },
  'debian-10' => {
    :virtualbox => {
      :box => "generic/debian10",
      :provision => [
        {:name => 'disable dns-nameservers', :inline => 'sed -i -e "/^dns-nameserver/g" /etc/network/interfaces', :reboot => true},
        # restarting dnsmasq can require a retry after everything else to come up correctly.
        {:name => 'install dnsmasq', :inline => 'apt update && apt install -y dnsmasq && systemctl restart dnsmasq', :env => APT_ENV_VARS},
      ],
    },
  },
  'debian-11' => {
    :virtualbox => {
      :box => "generic/debian11",
      :provision => [
        {:name => 'disable dns-nameservers', :inline => 'sed -i -e "/^dns-nameserver/g" /etc/network/interfaces', :reboot => true},
        # restarting dnsmasq can require a retry after everything else to come up correctly.
        {:name => 'install dnsmasq', :inline => 'apt update && apt install -y dnsmasq && systemctl restart dnsmasq', :env => APT_ENV_VARS},
      ],
    },
  },
  'centos-7' => {
    :virtualbox => {
      :box => "generic/centos7",
    },
  },
  'centos-8' => {
    :virtualbox => {
      :box => "generic/centos8",
    },
  },
  'centos-8-stream' => {
    :virtualbox => {
      :box => "generic/centos8s",
    },
  },
  'centos-9-stream' => {
    :virtualbox => {
      :box => "generic/centos9s",
    },
  },
  'fedora-34' => {
    :virtualbox => {
      :box => "generic/fedora34",
    },
  },
  'fedora-35' => {
    :virtualbox => {
      :box => "generic/fedora35",
    },
  },
  'fedora-36' => {
    :virtualbox => {
      :box => "generic/fedora36",
    },
  },
  'archlinux' => {
    :virtualbox => {
      :box => "archlinux/archlinux",
    },
  },
  'opensuse-leap' => {
    :virtualbox => {
      :box => "opensuse/Leap-15.4.x86_64",
    },
  },
}

DEFAULT_PROVISION = [
  {:name => 'install script', :privileged => false, :path => './scripts/install.bash', :args => ENV['QA_VAGRANT_VERSION'].nil? ? "" : "--vagrant-version #{ENV['QA_VAGRANT_VERSION']}", :env => INSTALL_ENV_VARS},
  {:name => 'setup group', :reset => true, :inline => 'usermod -a -G virtualbox vagrant'},
  {:name => 'debug system capabilities', :privileged => false, :inline => 'virsh --connect qemu:///system capabilities'},
  {:name => 'debug uri', :privileged => false, :inline => 'virsh uri'},
]

if __FILE__ == $0
  require 'json'
  puts JSON.pretty_generate(BOXES)
end
