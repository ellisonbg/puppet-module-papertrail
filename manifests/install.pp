class papertrail::install {

  package { ['rsyslog', 'rsyslog-gnutls', 'wget']:
    ensure  => 'installed'
  }

  file { '/etc/rsyslog.d/papertrail.conf':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    content => template('papertrail/etc/rsyslog.d/papertrail.conf.erb'),
    require => [Service['rsyslog'],
                Package['rsyslog', 'rsyslog-gnutls']]
  }

  file { $papertrail::cert:
    ensure  => 'present',
    replace => 'no',
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    require => [
      File['/etc/rsyslog.d/papertrail.conf'],
      Exec['get_certificates']
    ];
  }

  exec { 'get_certificates':
    path    => '/bin/:/usr/bin/:/usr/local/bin/',
    command => "wget ${papertrail::cert_url} -O ${papertrail::cert}",
    creates => $papertrail::cert
  }

  file_line { 'rsyslog_set_hostname':
    path   => '/etc/rsyslog.conf',
    line   => "\$LocalHostName ${papertrail::hostname}",
    notify  => Service['rsyslog'];
  }

}
