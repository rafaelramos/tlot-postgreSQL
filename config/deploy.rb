require 'rvm/capistrano'
require 'capistrano/ext/multistage'

set :application, "tlot-postgreSQL"

set :scm, :git
set :repository,  "git@github.com:rafaelramos/tlot-postgreSQL.git"
#set :scm_passphrase, ""

set :user, 'root'

set :stages, ['staging', 'production']
set :default_stage, "staging"

set :branch, "master"
set :ssh_options, { forward_agent: true, port: 22 }
set :deploy_via, :copy
set :use_sudo, false

default_run_options[:pty] = true