#
# Author:: Barry Steinglass (<barry@opscode.com>)
# Cookbook Name:: silverstripe
# Attributes:: silverstripe
#
# Copyright 2009-2010, Opscode, Inc.
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

default['silverstripe']['db']['name'] = "silverstripe"
default['silverstripe']['db']['user'] = "ss_user"
#default['silverstripe']['db']['password'] = nil
default['silverstripe']['db']['prefix'] = 'ss_'

# General settings
#default['silverstripe']['version'] = "latest"
#default['silverstripe']['checksum'] = ""
#default['silverstripe']['repourl'] = "http://silverstripe.org/"
default['silverstripe']['parent_dir'] = '/srv/www/current'
#default['silverstripe']['dir'] = "#{node['silverstripe']['parent_dir']}/silverstripe" #This needsd to be set to /wordpres because it populates the index file and wp config
#default['silverstripe']['wpcontent_dir'] = "#{node['silverstripe']['parent_dir']}/wp-content"
default['silverstripe']['db']['database'] = "silverstripe"
#default['silverstripe']['db']['user'] = "silverstripeuser"
##default['silverstripe']['server_aliases'] = [node['fqdn']]
#default['silverstripe']['server_name'] = node['fqdn']
#default['silverstripe']['server_port'] = 80
