import 'lamp'
import 'processmaker'
import 'tools'

exec { "add-apt-repository":
	command => "/usr/bin/add-apt-repository -y ppa:ondrej/php"
}

exec { "apt-update":
	command => "/usr/bin/apt-get -y update"
}

class { 'lamp':
	require => Exec['apt-update']
}

class { 'processmaker':
	require => Class['lamp']
}

class { 'tools': 
	require => Class['processmaker']
}

exec {'restart-apache':
	command => '/etc/init.d/apache2 restart',
	require => Class['tools']
}
