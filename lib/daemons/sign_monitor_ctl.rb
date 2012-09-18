#!/usr/bin/env ruby
require 'rubygems'
require 'daemons'
require 'yaml'
require 'erb'
require 'active_support'

# For some reason, ActiveSupport 3.0.0 doesn't load.
# Load needed extension directly for now.
require "active_support/core_ext/object"
require "active_support/core_ext/hash"

options = YAML.load(
  ERB.new(
    IO.read(
      File.dirname(__FILE__) + "/../../config/daemons.yml"
  )).result).with_indifferent_access
  
options[:dir_mode] = options[:dir_mode].to_sym

Daemons.run File.dirname(__FILE__) + '/sign_monitor.rb', options
