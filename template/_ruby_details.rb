# Load the project's deps and required Ruby version

ruby_version = nil
gemspecs = {}

begin
  if File.file?("Gemfile.lock")
    bundler_parser = Bundler::LockfileParser.new(Bundler.read_file("Gemfile.lock"))
    gemspecs =  Hash[bundler_parser.specs.map { |spec| [spec.name, spec.version] }]
    maybe_ruby_version = bundler_parser.ruby_version&.match(/ruby (\d+\.\d+\.\d+)./i)&.[](1)
  end

  begin
    if maybe_ruby_version
      ruby_version = ask("Which Ruby version would you like to use? (Press ENTER to use #{maybe_ruby_version})") || ""
      ruby_version = maybe_ruby_version if ruby_version.empty?
    else
      ruby_version = ask("Which Ruby version would you like to use? (For example, 3.2.0)") || ""
    end

    Gem::Version.new(ruby_version)
  rescue ArgumentError
    say "Invalid version. Please, try again"
    retry
  end
end
