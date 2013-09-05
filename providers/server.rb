def whyrun_supported?
  true
end

action :create do
  if false #TODO
    Chef::Log.info "#{ new_resource } exists already, skipping..."
  else
    converge_by("Create #{ new_resource }") do
      package 'default-jre'

      directory "#{new_resource.install_dir}" do
        action :create
        recursive true
        owner new_resource.uid
        group new_resource.gid
      end

      remote_file "/#{new_resource.install_dir}/logstash.#{new_resource.logstash_version}.jar" do
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

      template "#{new_resource.install_dir}/indexer.conf" do
        source "indexer.conf.erb"
        mode 0555
        owner new_resource.uid
        group new_resource.gid
        cookbook 'logstash'
      end

      template "/etc/init/logstash_indexer.conf" do
        source "upstart.conf.erb"
        cookbook 'logstash'
        owner new_resource.uid
        group new_resource.gid
        variables :description => "logstash_indexer",
        :env => {:HOME => "#{new_resource.install_dir}"},
        :user => new_resource.uid,
        :group => new_resource.gid,
        :app_path => "#{new_resource.install_dir}",
        :log_path => "#{new_resource.install_dir}/logstash.log",
        :pid_path => "#{new_resource.install_dir}",
        :start_command => "java -jar #{new_resource.install_dir}/logstash.#{new_resource.logstash_version}.jar agent -f #{new_resource.install_dir}/indexer.conf"
      end
    end
  end
end

def load_current_resource
  []
end
