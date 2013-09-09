def whyrun_supported?
  true
end



action :create do
  package 'default-jre'

  conf_hash = {
    "logs" => new_resource.logs,
    "sincedb_path" => new_resource.install_dir
  }

  directory "#{new_resource.install_dir}" do
    action :create
    recursive true
    owner new_resource.uid
    group new_resource.gid
  end

  remote_file "#{new_resource.install_dir}/logstash.#{new_resource.logstash_version}.jar" do
    source "https://logstash.objects.dreamhost.com/release/logstash-#{new_resource.logstash_version}-flatjar.jar"
    mode 0555
    owner new_resource.uid
    group new_resource.gid
    not_if { ::File.exists? "#{new_resource.install_dir}/logstash.#{new_resource.logstash_version}.jar" }
  end

  file "#{new_resource.install_dir}/logstash.log" do
    owner new_resource.uid
    group new_resource.gid
    mode "0666"
  end

  template "#{new_resource.install_dir}/shipper.conf" do
    source "shipper.conf.erb"
    mode 0555
    owner new_resource.uid
    group new_resource.gid
    variables conf_hash
    cookbook 'logstash'
    variables :install_dir => new_resource.install_dir,
    :server_host => new_resource.server_host,
    :logs => new_resource.logs
  end

  template "/etc/init/logstash_agent.conf" do
    source "upstart.conf.erb"
    cookbook 'logstash'
    owner new_resource.uid
    group new_resource.gid
    variables :description => "logstash_agent",
    :env => {:HOME => "#{new_resource.install_dir}"},
    :user => new_resource.uid,
    :group => new_resource.gid,
    :app_path => "#{new_resource.install_dir}",
    :sincedb_path => "#{new_resource.install_dir}",
    :log_path => "#{new_resource.install_dir}/logstash.log",
    :pid_path => "#{new_resource.install_dir}/pids",
    :start_command => "java -jar #{new_resource.install_dir}/logstash.#{new_resource.logstash_version}.jar agent -f #{new_resource.install_dir}/shipper.conf"
  end

  service "logstash_agent" do
    action [ :reload, :start ]
    supports :status => true, :restart => true, :enable => true
    provider Chef::Provider::Service::Upstart
  end
end
