describe 'enterprise-hello-world example project' do
  let(:root) { example_project_dir 'enterprise-hello-world' }

  around do |example|
    Dir.chdir root do
      example.run
    end
  end

  before do
    begin
      Pathname.glob('src/*/bin').each(&:rmtree)
      Pathname.new('project.lock.json').delete
    rescue Errno::ENOENT # rubocop:disable Lint/HandleExceptions
      # do nohting
    end
  end

  describe 'rake' do
    it 'should output "Hello World!"' do
      expect { rake }.to output(/^Hello World!$/).to_stdout
    end
  end

  describe 'rake build' do
    def dll(project, dir = 'src')
      root + dir + project + 'bin/Debug/dnx451' + "#{project}.dll"
    end

    it 'should build all projects' do
      rake 'restore', 'build', quiet: true

      expect(dll 'Acme.HelloWorld.App').to exist
      expect(dll 'Acme.HelloWorld.Data').to exist
      expect(dll 'Acme.HelloWorld.Data.Test', 'test').to exist
    end
  end

  describe 'rake test' do
    it 'should run all tests' do
      expect { rake 'test' }.to \
        output(/Finished:\s*Acme\.HelloWorld\.Data\.Test/).to_stdout
    end
  end

  describe 'rake pack' do
    def nupkg(project, version, dir = 'src')
      root + dir + project + 'bin/Debug' + "#{project}.#{version}.nupkg"
    end

    def symbols_nupkg(project, version, dir = 'src')
      package = "#{project}.#{version}.symbols.nupkg"
      root + dir + project + 'bin/Debug' + package
    end

    it 'should build the Acme.HelloWorld.App packages' do
      rake 'restore', 'pack', quiet: true

      expect(nupkg 'Acme.HelloWorld.App', '1.0.0').to exist
      expect(symbols_nupkg 'Acme.HelloWorld.App', '1.0.0').to exist
      expect(nupkg 'Acme.HelloWorld.Data', '1.0.0').to exist
      expect(symbols_nupkg 'Acme.HelloWorld.Data', '1.0.0').to exist
      expect(nupkg 'Acme.HelloWorld.Data.Test', '1.0.0', 'test').to exist
      expect(symbols_nupkg 'Acme.HelloWorld.Data.Test',
                           '1.0.0', 'test').to exist
    end
  end
end
