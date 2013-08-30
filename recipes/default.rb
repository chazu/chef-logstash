#
# Cookbook Name:: chef-logstash
# Recipe:: default
#
# Copyright (C) 2013 YOUR_NAME
# 
# All rights reserved - Do Not Redistribute
#

include_recipe "apt::default"

logstash_server "booya"
logstash_shipper "kasha"
