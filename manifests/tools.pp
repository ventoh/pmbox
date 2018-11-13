class tools {

	# Install Git and ZSH
	$tools_require = ['git-core', 'curl']
	package { $tools_require: ensure => installed }

	# Install PHPMyAdmin
	exec {
		'get_phpmyadmin':
			command => "/usr/bin/wget -P /var/www https://files.phpmyadmin.net/phpMyAdmin/4.8.3/phpMyAdmin-4.8.3-all-languages.tar.gz",
			creates => "/var/www/phpMyAdmin-4.8.3-all-languages.tar.gz",
			timeout => '0',
			require => Package[$tools_require];
		'extract_phpmyadmin':
			cwd => '/var/www/',
			command => "/bin/tar xzvf phpMyAdmin-4.8.3-all-languages.tar.gz",
			creates => '/var/www/phpMyAdmin-4.8.3-all-languages',
			require => Exec['get_phpmyadmin'];
	}

	# Rename folder to phpmyadmin
	file { "/var/www/phpmyadmin":
		ensure => directory,
		source => '/var/www/phpMyAdmin-4.8.3-all-languages',
		recurse => true,
		require => Exec['extract_phpmyadmin'];
	}

}
