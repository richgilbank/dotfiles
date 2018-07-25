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
require 'open3'

SYMLINK_AFTER_SETUP = ['vim/vimrc.symlink']
FOLLOW_UP_SYMLINKS = []

desc "Hook our dotfiles into system-standard positions."
task :install => [:generate_gitconfig_from_template] do
  linkables = Dir.glob('*/**{.symlink}').map! do |linkable|
    file = linkable.split('/').last.split('.symlink').last
    { "path" => linkable,
      "file" => file,
      "target" => "#{ENV["HOME"]}/.#{file}"
    }
  end
  # Doesn't go into home directory:
  linkables << {
    "path" => "fish/",
    "file" => "fish/",
    "target" => "#{ENV["HOME"]}/.config/fish"
  }

  skip_all = false
  overwrite_all = false
  backup_all = false

  # `curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh`
  `mkdir -p ~/.config`

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
    if SYMLINK_AFTER_SETUP.include?(path)
      FOLLOW_UP_SYMLINKS << {path: path, target: target}
    else
      `ln -s "$PWD/#{path}" "#{target}"`
    end
  end

  FOLLOW_UP_SYMLINKS.each do |linkable|
    `ln -s "$PWD/#{linkable[:path]}" "#{linkable[:target]}"`
  end

  file = case `uname`.strip
    when 'Darwin' then './osx/set-defaults.sh'
    when 'Linux' then './linux/set-defaults.sh'
  end

  puts "Loading #{`uname`.strip}-specific settings"
  Open3.popen3(file) do |stdin, stdout, stderr, thread|
    while line = stdout.gets
      puts line
    end
    while line = stderr.gets
      puts "ERROR: " << line
    end
  end

  puts "Loading common setup"
  Open3.popen3('./common-setup.sh') do |stdin, stdout, stderr, thread|
    while line = stdout.gets
      puts line
    end
    while line = stderr.gets
      puts "ERROR: " << line
    end
  end

  `pip3 install powerline-shell`
  `curl -L https://get.oh-my.fish | fish`
  `omf install agnoster`

  puts 'Done'
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
