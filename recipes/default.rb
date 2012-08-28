#
# Cookbook Name:: java-management
# Recipe:: default
#
# Copyright 2012
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

configuration_data_bag = Chef::EncryptedDataBagItem.load("java","management")
if configuration_data_bag[node.environment]['jmxremote']
  node['java-management']['jmxremote']['roles'] = configuration_data_bag[node.environment]['jmxremote']['roles']
end
if configuration_data_bag[node.environment]['snmp']
  node['java-management']['snmp']['acls'] = configuration_data_bag[node.environment]['snmp']['acls']
  node['java-management']['snmp']['traps'] = configuration_data_bag[node.environment]['snmp']['traps']
end

template "#{node['java']['java_home']}/jre/lib/management/jmxremote.access" do
  source "jmxremote.access.erb"
  owner  "root"
  group  "root"
  mode   "0644"
end

template "#{node['java']['java_home']}/jre/lib/management/jmxremote.password" do
  source "jmxremote.password.erb"
  owner  node['java-management']['owner']
  group  node['java-management']['group']
  mode   "0400"
end

template "#{node['java']['java_home']}/jre/lib/management/management.properties" do
  source "management.properties.erb"
  owner  "root"
  group  "root"
  mode   "0644"
end

template "#{node['java']['java_home']}/jre/lib/management/snmp.acl" do
  source "snmp.acl.erb"
  owner  node['java-management']['owner']
  group  node['java-management']['group']
  mode   "0400"
end
