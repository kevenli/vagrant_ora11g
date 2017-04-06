node 'oradb'  {

  include oradb_os
  #include goldengate_11g
  include oradb_11g

}

# operating settings for Database & Middleware
class oradb_os {

  $default_params = {}
  $host_instances = hiera('hosts', [])
  #create_resources('host',$host_instances, $default_params)


  service { iptables:
    enable    => false,
    ensure    => false,
    hasstatus => true,
  }

  $groups = ['oinstall','dba' ,'oper' ]

  group { $groups :
    ensure      => present,
  }

  user { 'oracle' :
    ensure      => present,
    uid         => 500,
    gid         => 'oinstall',
    groups      => $groups,
    shell       => '/bin/bash',
    password    => '$1$DSJ51vh6$4XzzwyIOk6Bi/54kglGk3.',
    home        => "/home/oracle",
    comment     => "This user oracle was created by Puppet",
    require     => Group[$groups],
    managehome  => true,
  }

  user { 'ggate' :
    ensure      => present,
    uid         => 501,
    gid         => 'oinstall',
    groups      => $groups,
    shell       => '/bin/bash',
    password    => '$1$DSJ51vh6$4XzzwyIOk6Bi/54kglGk3.',
    home        => "/home/ggate",
    comment     => "This user ggate was created by Puppet",
    require     => Group['dba'],
    managehome  => true,
  }

  $install = [ 'binutils.x86_64', 'compat-libstdc++-33.x86_64', 'glibc.x86_64','ksh.x86_64','libaio.x86_64',
               'libgcc.x86_64', 'libstdc++.x86_64', 'make.x86_64','compat-libcap1.x86_64', 'gcc.x86_64',
               'gcc-c++.x86_64','glibc-devel.x86_64','libaio-devel.x86_64','libstdc++-devel.x86_64',
               'sysstat.x86_64','unixODBC-devel','glibc.i686','libXext.x86_64','libXtst.x86_64']



  package { $install:
    ensure  => present,
  }

  class { 'limits':
         config => {
                    '*'       => { 'nofile'  => { soft => '2048'   , hard => '8192',   },},
                    'oracle'  => { 'nofile'  => { soft => '65536'  , hard => '65536',  },
                                    'nproc'  => { soft => '2048'   , hard => '16384',  },
                                    'stack'  => { soft => '10240'  ,},},
                    },
         use_hiera => false,
  }

  sysctl { 'kernel.msgmnb':                 ensure => 'present', permanent => 'yes', value => '65536',}
  sysctl { 'kernel.msgmax':                 ensure => 'present', permanent => 'yes', value => '65536',}
  sysctl { 'kernel.shmmax':                 ensure => 'present', permanent => 'yes', value => '2588483584',}
  sysctl { 'kernel.shmall':                 ensure => 'present', permanent => 'yes', value => '2097152',}
  sysctl { 'fs.file-max':                   ensure => 'present', permanent => 'yes', value => '6815744',}
  sysctl { 'net.ipv4.tcp_keepalive_time':   ensure => 'present', permanent => 'yes', value => '1800',}
  sysctl { 'net.ipv4.tcp_keepalive_intvl':  ensure => 'present', permanent => 'yes', value => '30',}
  sysctl { 'net.ipv4.tcp_keepalive_probes': ensure => 'present', permanent => 'yes', value => '5',}
  sysctl { 'net.ipv4.tcp_fin_timeout':      ensure => 'present', permanent => 'yes', value => '30',}
  sysctl { 'kernel.shmmni':                 ensure => 'present', permanent => 'yes', value => '4096', }
  sysctl { 'fs.aio-max-nr':                 ensure => 'present', permanent => 'yes', value => '1048576',}
  sysctl { 'kernel.sem':                    ensure => 'present', permanent => 'yes', value => '250 32000 100 128',}
  sysctl { 'net.ipv4.ip_local_port_range':  ensure => 'present', permanent => 'yes', value => '9000 65500',}
  sysctl { 'net.core.rmem_default':         ensure => 'present', permanent => 'yes', value => '262144',}
  sysctl { 'net.core.rmem_max':             ensure => 'present', permanent => 'yes', value => '4194304', }
  sysctl { 'net.core.wmem_default':         ensure => 'present', permanent => 'yes', value => '262144',}
  sysctl { 'net.core.wmem_max':             ensure => 'present', permanent => 'yes', value => '1048576',}

}



class oradb_11g {
  require oradb_os

    # oradb::installdb{ '11.2_linux-x64':
      # version                => '11.2.0.4',
      # file                   => 'p13390677_112040_Linux-x86-64',
      # databaseType           => 'SE',
      # oracleBase             => hiera('oracle_base_dir'),
      # oracleHome             => hiera('oracle_home_dir'),
      # userBaseDir            => '/home',
      # user                   => hiera('oracle_os_user'),
      # group                  => 'dba',
      # group_install          => 'oinstall',
      # group_oper             => 'oper',
      # downloadDir            => hiera('oracle_download_dir'),
      # remoteFile             => false,
      # puppetDownloadMntPoint => hiera('oracle_source'),
    # }
    oradb::installdb{ '112010_Linux-x86-64':
      version       => '11.2.0.1',
      file          => 'linux.x64_11gR2_database',
      database_type => 'SE',
      oracle_base   => '/oracle',
      oracle_home   => '/oracle/product/11.2/db',
      user          => 'oracle',
      group         => 'dba',
      group_install => 'oinstall',
      group_oper    => 'oper',
      download_dir  => '/install',
      zip_extract   => false,
     }

    oradb::net{ 'config net8':
      oracle_home   => '/oracle/product/11.2/db',
      version      => '11.2',
      user         => 'oracle',
      group        => 'dba',
      download_dir  => '/install',
      require      => Oradb::Installdb['112010_Linux-x86-64'],
    }
    
    db_listener{ 'startlistener':
      ensure          => 'running',  # running|start|abort|stop
      oracle_base_dir => '/oracle',
      oracle_home_dir => '/oracle/product/11.2/db',
      os_user         => 'oracle',
      listener_name   => 'listener' # which is the default and optional
    }


    oradb::listener{'start listener':
      oracle_base   => '/oracle',
      oracle_home   => '/oracle/product/11.2/db',
      user         => 'oracle',
      group        => 'dba',
      action       => 'start',
      require      => Oradb::Net['config net8'],
    }

    oradb::database{ 'oraDb':
      oracle_base              => '/oracle',
      oracle_home              => '/oracle/product/11.2/db',
      version                 => '11.2',
      user                    => 'oracle',
      group                   => 'dba',
      download_dir             => '/install',
      action                  => 'create',
      db_name                  => hiera('oracle_database_name'),
      db_domain                => hiera('oracle_database_domain_name'),
      sys_password             => hiera('oracle_database_sys_password'),
      system_password          => hiera('oracle_database_system_password'),
      data_file_destination     => "/oracle/oradata",
      recovery_area_destination => "/oracle/flash_recovery_area",
      character_set             => "AL32UTF8",
      nationalcharacter_set     => "UTF8",
      init_params               => {'open_cursors'        => '1000',
                                'processes'           => '600',
                                'job_queue_processes' => '4' },
      sample_schema             => 'TRUE',
      memory_total              => 800,
      database_type             => "MULTIPURPOSE",
      em_configuration          => "NONE",
      require                   => Oradb::Listener['start listener'],
    }

    oradb::dbactions{ 'start oraDb':
      oracle_home              => hiera('oracle_home_dir'),
      user                    => hiera('oracle_os_user'),
      group                   => hiera('oracle_os_group'),
      action                  => 'start',
      db_name                  => hiera('oracle_database_name'),
      require                 => Oradb::Database['oraDb'],
    }

    oradb::autostartdatabase{ 'autostart oracle':
      oracle_home              => hiera('oracle_home_dir'),
      user                    => hiera('oracle_os_user'),
      db_name                  => hiera('oracle_database_name'),
      require                 => Oradb::Dbactions['start oraDb'],
    }


}

class goldengate_11g {
  require oradb_11g

  file { '/oracle/product/12.1.2' :
    ensure        => directory,
    recurse       => false,
    replace       => false,
    mode          => '0775',
    owner         => hiera('ggate_os_user'),
    group         => 'oinstall',
  }

  oradb::goldengate{ 'ggate12.1.2':
    version                 => '12.1.2',
    file                    => '121210_fbo_ggs_Linux_x64_shiphome.zip',
    databaseType            => 'Oracle',
    databaseVersion         => 'ORA11g',
    databaseHome            => hiera('oracle_home_dir'),
    oracleBase              => hiera('oracle_base_dir'),
    goldengateHome          => "/oracle/product/12.1.2/ggate",
    managerPort             => 16000,
    user                    => hiera('ggate_os_user'),
    group                   => 'oinstall',
    downloadDir             => '/install',
    puppetDownloadMntPoint  => hiera('oracle_source'),
    require                 => File['/oracle/product/12.1.2'],
 }

}
