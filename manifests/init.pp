class bash($code=false) {
    case $operatingsystem {
        centos, redhat: { $bashrc_path = '/etc/bashrc' }
        ubuntu: { $bashrc_path = '/etc/bash.bashrc' }
        default: { fail('Unrecognized operating system for bashrc file setting in bash') }
    }
    case $environment {
        production: { $prompt_color = "'\[\e[1;31m\][\u@\h \W]\$\[\e[0m\] '" }
        testing: { $prompt_color = "'\[\e[1;32m\][\u@\h \W]\$\[\e[0m\] '" }
        default: { fail('No environment variable set. Did you define it in your puppet.conf?') }
    }
    file {
        'home_bashrc':
            ensure => present,
            source => 'puppet:///modules/bash/bashrc',
            path   => '/etc/skel/.bashrc',
            owner  => 'root',
            group  => 'root';
        'bashrc':
            ensure => present,
            content => template('bash/bashrc.erb'),
            path   => $bashrc_path,
            owner  => 'root',
            group  => 'root';
        }
    file { '/usr/local/bin/bashrc_copy.sh':
        ensure => present,
        source => 'puppet:///modules/bash/bashrc_copy.sh',
        mode    => '755',
    }
    exec { '/usr/local/bin/bashrc_copy.sh':
        path    => ['/usr/local/bin','/bin'],
        subscribe   => File['home_bashrc'],
        refreshonly => true,
    }
}
