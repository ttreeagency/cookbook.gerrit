default['set_fqdn'] = 'gerrit.ttree.ch'

default['gerrit']['server_name'] = 'gerrit.ttree.ch'
default['gerrit']['doc_root'] = '/var/www'

override['postfix']['myhostname'] = 'gerrit.ttree.ch'
override['postfix']['mydomain']   = 'gerrit.ttree.ch'