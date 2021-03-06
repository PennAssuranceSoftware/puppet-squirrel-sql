class squirrel_sql(
    $aliases = []
) {
  include squirrel_sql::params

  archive::download { 'squirrel-sql-3.6-standard.jar':
    url              => 'http://sourceforge.net/projects/squirrel-sql/files/1-stable/3.6.0/squirrel-sql-3.6-standard.jar/download',
    checksum         => false,
    follow_redirects => true,
    timeout          => 2120,
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
  } ->
  maven { "/opt/squirrel-sql/lib/postgresql-9.4-1202-jdbc4.jar":
    groupid => "org.postgresql",
    artifactid => "postgresql",
    version => "9.4-1202-jdbc4",
    packaging => "jar",
  } ->
  maven { "/opt/squirrel-sql/lib/h2-1.4.186.jar":
    groupid => "com.h2database",
    artifactid => "h2",
    version => "1.4.186",
    packaging => "jar",
  } ->
  maven { "/opt/squirrel-sql/lib/jtds-1.3.1.jar":
    groupid => "net.sourceforge.jtds",
    artifactid => "jtds",
    version => "1.3.1",
    packaging => "jar",
  } ->
  file { "/home/vagrant/.squirrel-sql":
    ensure => "directory",
    owner  => "vagrant",
  } ->
  file { '/home/vagrant/.squirrel-sql/SQLAliases23.xml':
    ensure  => $ensure,
    content => template('squirrel_sql/SQLAliases23.xml.erb'),
    owner  => "vagrant",
    mode    => 644,
  }
}
