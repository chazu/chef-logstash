actions :create
default_action :create

attr_accessor :exists

attribute :install_dir, :kind_of => String, :default => '/opt/logstash'
attribute :logstash_version, :kind_of => String, :default => '1.1.13'
attribute :uid, :kind_of => String, :default => "root"
attribute :gid, :kind_of => String, :default => "root"
attribute :server_host, :kind_of => String, :default => "127.0.0.1"
attribute :nodes, :kind_of => Array, :default => ["127.0.0.1"]
