class apache {
  case $facts['osfamily'] {
        'RedHat', 'CentOS': {
       $apachename = 'httpd'
       $vhostsource = '/etc/httpd/conf.d/vhost.conf'
       $servername = $facts['ipaddress_enp0s8']
  	}
  	/^(Debian|Ubuntu)$/: { 
       $apachename = 'apache2'
       $vhostsource = '/etc/apache2/sites-enabled/vhost.conf'
       $servername = $facts['ipaddress_eth1']
   	}
  default: { 
      fail("Module does not supported.") 
    	}
}

  package { $apachename :
  	ensure => installed,
  }

  file { '/var/www/public/':
      ensure    => directory,
      before => File['/var/www/public/index.html'],
  }

  file { '/var/www/public/index.html':
      ensure => file,
      content  => template('apache/index.html.erb'),
      before => File[$vhostsource],
  }

  $vhost_hash = {
       'servername' => $servername,
  }

  file { $vhostsource:
    content => epp('apache/vhost.conf.epp', $vhost_hash),
    notify => Service[$apachename],
  }

  service { $apachename :
  	enable => true,
  	ensure => running,
  	require => Package[$apachename],
	}

}
