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
    def dll_for_project(project)
      root + 'src' + project + 'bin/Debug/dnx451' + "#{project}.dll"
    end

    it 'should build Acme.HelloWorld.App' do
      rake 'build', quiet: true

      expect(dll_for_project 'Acme.HelloWorld.App').to exist
    end
  end

  describe 'rake pack' do
    def nupkg_for_project(project, version)
      root + 'src' + project + 'bin/Debug' + "#{project}.#{version}.nupkg"
    end

    def symbols_nupkg_for_project(project, version)
      package = "#{project}.#{version}.symbols.nupkg"
      root + 'src' + project + 'bin/Debug' + package
    end

    it 'should build the Acme.HelloWorld.App packages' do
      rake 'pack', quiet: true

      expect(nupkg_for_project 'Acme.HelloWorld.App', '1.0.0').to exist
      expect(symbols_nupkg_for_project 'Acme.HelloWorld.App', '1.0.0').to exist
    end
  end
end
