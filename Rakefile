# The MIT License
#
# Copyright (c) Zach Holman, http://zachholman.com
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
# Note: - Some edits made by Andrew Sardone to create the gitconfig installation
#         procedure. https://github.com/andrewsardone/dotfiles
#       - Other edits made by Michael Russo, including the ability to
#         move files into place that are not in the standard location
#         of '*/**{.symlink}'. http://mjrusso.com

require 'rake'
require 'fileutils'

desc "Hook our dotfiles into system-standard positions."
task :install => [:generate_gitconfig_from_template] do
  linkables = Dir.glob('*/**{.symlink}').map! do |linkable|
    file = linkable.split('/').last.split('.symlink').last
    { "path" => linkable,
      "file" => file,
      "target" => "#{ENV["HOME"]}/.#{file}"
    }
  end

  # Custom include for fish shell. The fish shell requires config
  # files to be in the location of ~/.config/fish/config.fish.
  FileUtils.mkdir_p "#{ENV['HOME']}/.config/fish"
  linkables << { "path" => "fish/config.fish",
    "file" => "config.fish",
    "target" => "#{ENV['HOME']}/.config/fish/config.fish"
  }

  skip_all = false
  overwrite_all = false
  backup_all = false

  linkables.each do |linkable|
    overwrite = false
    backup = false

    path = linkable['path']
    file = linkable['file']
    target = linkable['target']

    if File.exists?(target) || File.symlink?(target)
      unless skip_all || overwrite_all || backup_all
        puts "File already exists: #{target}, what do you want to do? [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all"
        case STDIN.gets.chomp
        when 'o' then overwrite = true
        when 'b' then backup = true
        when 'O' then overwrite_all = true
        when 'B' then backup_all = true
        when 'S' then skip_all = true
        when 's' then next
        end
      end
      FileUtils.rm_rf(target) if overwrite || overwrite_all
      `mv "#{target}" "#{target}.backup"` if backup || backup_all
    end
    `ln -s "$PWD/#{path}" "#{target}"`
  end

  case `uname`.strip
  when 'Darwin' then puts `./osx/set-defaults.sh`
  when 'Linux' then puts `./linux/set-defaults.sh`
  end

  puts `./common-setup.sh`
end

desc "Generate a gitconfig file from the template based on user input"
task :generate_gitconfig_from_template do
  gitconfig_name = 'git/gitconfig.symlink'
  exists = false
  skip = false
  regenerate = false

  if File.exists?(gitconfig_name)
    exists = true
    puts "gitconfig file already exists, what do you want to do? [s]kip, [r]egenerate"
    case STDIN.gets.chomp
    when 's' then skip = true
    when 'r' then regenerate = true
    end
  end

  if not exists or regenerate
    repl = {}
    puts "\nGenerating gitconfig"
    print("Your Name: "); STDOUT.flush; repl['__USER_NAME__'] = STDIN.gets.chomp
    print("Your Email: "); STDOUT.flush; repl['__USER_EMAIL__'] = STDIN.gets.chomp
    temp = IO.read('git/gitconfig.template')
    repl.each { |k,v| temp.gsub!(k,v) }
    File.new(gitconfig_name, File::WRONLY|File::TRUNC|File::CREAT).puts temp
  else
    puts "\nSkipping generation of gitconfig"
  end
end

task :uninstall do

  Dir.glob('**/*.symlink').each do |linkable|

    file = linkable.split('/').last.split('.symlink').last
    target = "#{ENV["HOME"]}/.#{file}"

    # Remove all symlinks created during installation
    if File.symlink?(target)
      FileUtils.rm(target)
    end

    # Replace any backups made during installation
    if File.exists?("#{ENV["HOME"]}/.#{file}.backup")
      `mv "$HOME/.#{file}.backup" "$HOME/.#{file}"`
    end

  end
end

task :default => 'install'
