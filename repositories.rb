require 'pp'

require 'open-uri'
require 'digest/md5'
require 'tmpdir'

def sudo command
  system "sudo -- #{command}"
end

class Package < Struct.new :name, :url, :md5
  def url value
    self.url = value
  end

  def md5 value
    self.md5 = value
  end

  def filename
    File.basename self['url']
  end
end

class Repository < Struct.new :name, :directory, :outputs, :tool, :packages, :build
  def directory value
    self.directory = value
  end

  def period_directory
    File.join self[:directory], '.'
  end

  def outputs value
    self.outputs = value
  end

  def output_string
    self[:outputs].join ' '
  end

  def tool value
    self.tool = value
  end

  def package name, &blk
    self.packages ||= []
    self.packages << Package.new(name).tap { |p| p.instance_eval(&blk) }
  end

  def build &blk
    self.build = blk
  end
end

def repository name, &blk
  create_tasks Repository.new(name).tap { |r| r.instance_eval(&blk) }
end

def create_tasks repository
  desc "Generate #{repository.name} repository archive"
  task repository.name => "#{repository.name}.tar.gz"

  file "#{repository.name}.tar.gz" => ["#{repository.name}:deps", "#{repository.name}:cache"] do |t|
    Dir.mktmpdir do |workdir|
      FileUtils.cp_r repository.period_directory, workdir

      repository.packages.each do |package|
        FileUtils.cp package.filename, workdir
      end

      repository[:build].call workdir

      system "tar -czf #{t.name} -C '#{workdir}' #{repository.output_string}"
    end
  end

  namespace repository.name do
    desc "Install #{repository.name} packaging tools"
    task 'deps' do
      sudo "apt-get -y install #{repository[:tool]}"
    end

    desc "Cache #{repository.name} packages"
    task 'cache' => repository.packages.map { |p| "#{repository.name}:cache:#{p.name}" }

    namespace 'cache' do
      repository.packages.each do |package|
        desc "Download the #{package.name} #{repository.name} package"
        task package.name => package.filename do
          actual_md5 = Digest::MD5.hexdigest File.read package.filename
          unless actual_md5 == package[:md5]
            raise "MD5(#{package.filename}) == #{actual_md5} expected #{package[:md5]}."
          end
        end

        file package.filename do
          File.write package.filename, open(package[:url]).read
        end
      end
    end
  end
end
