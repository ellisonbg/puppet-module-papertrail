class papertrail::service {

  service { 'rsyslog':
    ensure      => running,
    hasstatus   => true,
    hasrestart  => true,
    enable      => true,
    subscribe   => File_line['rsyslog_set_hostname'],
    require     => Class['papertrail::install'];
  }
}
