# frozen_string_literal: true

LANGS = ENV['LANGS']
ENVM_ROOT = ENV['ENVM_ROOT']

# Helpers
def blank?(string)
  string.nil? || string.empty?
end

def env_variables_valid?
  !(blank?(LANGS) || blank?(ENVM_ROOT))
end

def set_path(lang, version)
  base_path = "#{ENV['ENVM_ROOT']}/#{lang}"
  exe_path = "#{base_path}/versions/#{version}/bin"
  envs = ENV['PATH'].split(':').reject { |env| env.include? base_path }

  unless File.exist?(exe_path)
    puts "The #{lang} - #{version} is not installed."
    exit 1
  end

  ENV['PATH'] = "#{exe_path}:#{envs.uniq.join(':')}"
end

def init_shell_session
  Kernel.exec(ENV['SHELL'])
end

def global_config_path(lang)
  "#{ENV['ENVM_ROOT']}/.#{lang}_version"
end

def local_config_path(lang)
  "#{Dir.pwd}/.#{lang}_version"
end

def read_global_config(lang)
  filename = global_config_path(lang)
  return File.read(filename).split[0] if File.exist?(filename)
end

def read_local_config(lang)
  filename = local_config_path(lang)
  return File.read(filename).split[0] if File.exist?(filename)
end

# Commands
def init
  LANGS.split.each do |lang|
    config = read_local_config(lang) || read_global_config(lang)
    set_path(lang, config)
  end
  puts ENV['PATH']
end

def list(lang)
  if blank?(lang)
    puts "Enter the language eg.\n$ envm list node"
    return
  end

  root_path = "#{ENVM_ROOT}/#{lang}/versions"
  versions = Dir.entries(root_path).reject { |file| File.directory?(file) || file == '.DS_Store' }
  puts "The available versions are \n#{versions.join("\n")} \n "
end

def set_global_version(lang, version)
  if blank?(lang) || blank?(version)
    puts "Please enter language, version eg.\n $ envm global node <version>."
    exit 1
  else
    File.write(global_config_path(version), version)
    set_path(lang, version)
    puts ENV['PATH']
  end
end

def use_version(lang, version)
  if blank?(lang) || blank?(version)
    puts "Please enter language, version eg.\n $ envm local node <version>."
    exit 1
  else
    set_path(lang, version)
    puts ENV['PATH']
  end
end

def use_local_version(lang)
  config = read_local_config(lang)

  if blank?(config)
    puts 'No local configuration files exists in the current directory.'
    puts 'Create a file of format .<lang>_version and put the version in it.'
    exit 1
  else
    set_path(lang, config)
    puts ENV['PATH']
  end
end
