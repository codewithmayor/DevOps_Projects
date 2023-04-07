#!/usr/bin/env bash
#Bash script that  Configure Nginx so that:its HTTP response contains a custom header (on web-01 and web-02) using puppet
sudo apt update
sudo apt install puppet
sudo systemctl start puppet
sudo systemctl enable puppet
file { '/etc/haproxy/haproxy.cfg':
  ensure => file,
  owner  => 'root',
  group  => 'root',
  mode   => '0644',
}

# Add custom HTTP header
exec { 'Add custom HTTP header':
  command => "sed -i '/^global$/,/^frontend/ s/httplog-format .*/httplog-format %{+X-Served-By: $hostname}o %ci:%cp %fi:%fp %{+Q}r %ST %B %Ts/' /etc/haproxy/haproxy.cfg",
  require => File['/etc/haproxy/haproxy.cfg'],
}

