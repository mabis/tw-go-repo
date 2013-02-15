require 'open-uri'
require 'digest/md5'

APT = {
  directory: 'templates/apt/',
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

namespace 'cache' do
  APT[:packages].each_pair do |name, (in_url, expected_md5)|
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
