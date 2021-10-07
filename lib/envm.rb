# frozen_string_literal: true

require_relative 'utils'

INVALID_COMMAND_MSG = "You've entered an invalid command. Please run the following to check all available commands
$ envm help
"

LIST_OF_COMMANDS = "The list of supported commands are 'envm <lang> list', eg.

$ envm list node                 -   Lists all the node versions installed
$ envm global node <version>     -   Sets the <version> globally
$ envm use node <version>        -   Sets the <version> locally
"

ENV_INVALID_MSG = "Please set the env variables LANGS, ENVM_ROOT as follows
$ export LANGS=\"node ruby\"
$ export ENVM_ROOT=<root path where envm the version folders are present>
The folder structure should be like below

  envm
  | node
  | |- versions
  | | |- v10.24.1
  |- ruby
  | |- versions
  | | |- 3.0.2
"

def handle_commands(argv)
  lang = argv[1]
  version = argv[2]

  case argv.first
  when 'help'
    puts LIST_OF_COMMANDS
  when 'init'
    init
  when 'list'
    list(lang)
  when 'global'
    set_global_version(lang, version)
  when 'local'
    use_local_version(lang)
  when 'use'
    use_version(lang, version)
  else
    puts INVALID_COMMAND_MSG
    exit 1
  end
end

def main
  if !env_variables_valid?
    puts ENV_INVALID_MSG
  elsif ARGV.empty?
    puts INVALID_COMMAND_MSG
  else
    handle_commands(ARGV)
  end
end
