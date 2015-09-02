class squirrel_sql {
  include squirrel_sql::params

  archive::download { 'squirrel-sql-3.6-standard.jar':
    url              => 'http://sourceforge.net/projects/squirrel-sql/files/1-stable/3.6.0/squirrel-sql-3.6-standard.jar/download',
    checksum         => false,
    follow_redirects => true,
  } ->
  file { "/usr/src/squirrel-sql-automatic.xml":
    source => "puppet:///modules/squirrel_sql/squirrel-sql-automatic.xml"
  } ->
  exec { "insall_squirrel":
    command => "java -jar /usr/src/squirrel-sql-3.6-standard.jar /usr/src/squirrel-sql-automatic.xml",
    path    => ["/bin", "/usr/bin"],
  } ->
  file { '/usr/share/applications/opt-squirrel-sql.desktop':
    ensure  => $ensure,
    content => template('squirrel_sql/opt-squirrel-sql.desktop.erb'),
    mode    => 644,
  } ->
  file { '/usr/local/bin/squirrel-sql':
    ensure  => 'link',
    target  => "${squirrel_sql::params::download_bin}",
  }
}