require 'open-uri'
require 'digest/md5'
require 'tmpdir'

APT = {
  directory: 'templates/apt/',
  outputs: ['dists', 'pool'],
  packages: {
    'go-agent' => [
      'http://download01.thoughtworks.com/go/12.4.1/ga/go-agent-12.4.1-16091.deb',
      '209f6cbd4e43bc6633ff15a11a252695'
    ],

    'go-server' => [
      'http://download01.thoughtworks.com/go/12.4.1/ga/go-server-12.4.1-16091.deb',
      'fa73aae61a640ced96bc818b90df2d15'
    ]
  }
}

YUM = {
  directory: 'templates/yum/',
  outputs: ['*.rpm', 'repodata'],
  packages: {
    'go-agent' => [
      'http://download01.thoughtworks.com/go/12.4.1/ga/go-agent-12.4.1-16091.noarch.rpm',
      'f3cdbf2822940528bd3e42aadfb23f2b'
    ],
  }
}

def sudo command
  system "sudo -- #{command}"
end

def in_template task, template
  Dir.mktmpdir do |dir|
    FileUtils.cp_r File.join(template[:directory], '.'), dir

    template[:packages].each do |name, (in_url, expected_md5)|
      filename = File.basename in_url
      FileUtils.cp filename, dir
    end

    yield dir

    system "tar -czf #{task.name} -C '#{dir}' #{template[:outputs].join ' '}"
  end
end

task 'apt' => 'apt.tar.gz'
task 'yum' => 'yum.tar.gz'

file 'yum.tar.gz' => ['yum:deps', 'yum:cache'] do |t|
  in_template t, YUM do |workdir|
    system "createrepo --verbose --outputdir '#{workdir}' ."
  end
end

file 'apt.tar.gz' => ['apt:deps', 'apt:cache'] do |t|
  in_template t, APT do |workdir|
    APT[:packages].each do |name, (in_url, expected_md5)|
      filename = File.join workdir, File.basename(in_url)
      system "reprepro --verbose --basedir '#{workdir}' includedeb go '#{filename}'"
    end
  end
end

namespace 'apt' do
  task 'deps' do
    sudo 'apt-get -y install reprepro'
  end

  task 'cache' => APT[:packages].map { |k, v| "cache:apt:#{k}" }
end

namespace 'yum' do
  task 'deps' do
    sudo 'apt-get -y install createrepo'
  end

  task 'cache' => YUM[:packages].map { |k, v| "cache:yum:#{k}" }
end

namespace 'cache' do
  def cache_tasks template
    template[:packages].each_pair do |name, (in_url, expected_md5)|
      filename = File.basename in_url

      desc "Download the #{name} package."
      task name => filename do
        actual_md5 = Digest::MD5.hexdigest File.read filename
        raise "MD5(#{filename}) == #{actual_md5} expected #{expected_md5}." unless actual_md5 == expected_md5
      end

      file filename do
        File.write filename, open(in_url).read
      end
    end
  end

  namespace 'apt' do
    cache_tasks APT
  end

  namespace 'yum' do
    cache_tasks YUM
  end
end
