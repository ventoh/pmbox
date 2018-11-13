class lamp {

	# MySQL first, because yes
	$mysql_require = ['mysql-server', 'libapache2-mod-auth-mysql']
	# Ensure the required packages are there 
	package { $mysql_require: ensure => installed }
	# Set a default password
	exec { 'mysql_password':
		command => '/usr/bin/mysqladmin -u root password processmaker || /bin/true',
		require => Package[$mysql_require]
	}

	# Ensure the service is running
	service { 'mysql':
		ensure    => running,
		enable    => true,
		require   => Package[$mysql_require], 
	}

	# PHP, specifically PHP5.6
	$php_require = [
		'php5.6',
		'php5.6-common',
		'php5.6-mbstring',
		'php5.6-mcrypt',
		'php5.6-mysql',
		'php5.6-xml',
		'php5.6-gd',
		'php5.6-ldap',
		'php5.6-curl',
		'php5.6-cli',
		'php5.6-soap',
		'libapache2-mod-php5.6'
	]
	# Install packages
	package { $php_require: ensure => installed, require => Service['mysql'] }

	# Set our own php.ini file with our own parameters
	file { '/etc/php/5.6/apache2/php.ini':
		ensure  => present,
		source  => "/vagrant/files/php/php.ini",
		owner => root,
		group => root,
		require => Package[$php_require];
	}

	# Apache server
	$apache_require = ['apache2']
	package { $apache_require: ensure => installed, require => Package[$php_require]}

	service { 'apache2' :
		ensure  => running,
		enable  => true,
		require => Package[$apache_require],
	}


	# disable old php5.5
	#exec {
	#	'disable-php5':
	#	command => '/usr/sbin/a2dismod php5'
	#}

	# enable php5.6
	exec {
		'enable-php5.6':
		command => '/usr/sbin/a2enmod php5.6'
	}
}
