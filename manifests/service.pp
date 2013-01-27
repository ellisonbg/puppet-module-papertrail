class papertrail::service {

  service { 'rsyslog':
    ensure      => running,
    hasstatus   => true,
    hasrestart  => true,
    enable      => true,
    require     => File_line['rsyslog_set_hostname'];
  }
}
