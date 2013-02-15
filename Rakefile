require './repositories'

repository 'apt' do
  directory 'templates/apt/'
  outputs %w(dists pool)
  tool 'reprepro'

  build do |workdir|
    self[:packages].each do |package|
      filename = File.join workdir, File.basename(package[:url])
      system "reprepro --verbose --basedir '#{workdir}' includedeb go '#{filename}'"
    end
  end

  package 'go-agent' do
    url 'http://download01.thoughtworks.com/go/12.4.1/ga/go-agent-12.4.1-16091.deb'
    md5 '209f6cbd4e43bc6633ff15a11a252695'
  end

  package 'go-server' do
    url 'http://download01.thoughtworks.com/go/12.4.1/ga/go-server-12.4.1-16091.deb'
    md5 'fa73aae61a640ced96bc818b90df2d15'
  end
end

repository 'yum' do
  outputs %w(*.rpm repodata)
  tool 'createrepo'

  build { |workdir| system "createrepo --verbose --outputdir '#{workdir}' ." }

  package 'go-agent' do
    url 'http://download01.thoughtworks.com/go/12.4.1/ga/go-agent-12.4.1-16091.noarch.rpm'
    md5 'f3cdbf2822940528bd3e42aadfb23f2b'
  end
end
