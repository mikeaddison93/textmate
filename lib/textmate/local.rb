class Textmate::Local

  def bundle_paths
    { 'Application'     => '/Applications/TextMate.app/Contents/SharedSupport/Bundles',
      'User'            => "#{ENV["HOME"]}/Library/Application Support/TextMate/Bundles",
      'System'          => '/Library/Application Support/TextMate/Bundles',
      'User Pristine'   => "#{ENV["HOME"]}/Library/Application Support/TextMate/Pristine Copy/Bundles",
      'System Pristine' => '/Library/Application Support/TextMate/Pristine Copy/Bundles',
    }
  end

  def bundle_install_path
    bundle_paths['User Pristine']
  end

  def bundles(search = '')
    bundle_paths.inject({}) do |hash, (name, path)|
      hash.update(name => find_bundles(name, search))
    end
  end

  def uninstall(bundle)
    bundle_paths.values.each do |path|
      bundle_path = File.join(path, "#{bundle}.tmbundle")
      if File.exist? bundle_path
        %x[osascript -e 'tell application "Finder" to move the POSIX file "#{bundle_path}" to trash']
      end
    end
  end

private ######################################################################

  def find_bundles(location, search='')
    search_term = Regexp.new(".*#{search}.*", 'i')

    Dir[File.join(bundle_paths[location], '*.tmbundle')].map do |bundle|
      File.basename(bundle, '.*')
    end.select do |bundle|
      bundle =~ search_term
    end
  end

end