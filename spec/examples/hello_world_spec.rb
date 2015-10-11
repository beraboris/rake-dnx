describe 'hello-world example project' do
  around do |example|
    Dir.chdir example_project_dir 'hello-world' do
      example.run
    end
  end

  before do
    begin
      Pathname.new('bin').rmtree
      Pathname.new('project.lock.json').delete
    rescue Errno::ENOENT # rubocop:disable Lint/HandleExceptions
      # do nohting
    end
  end

  describe 'rake' do
    it 'should output "Hello World"' do
      expect { rake }.to output(/^Hello World!$/).to_stdout
    end
  end

  describe 'rake restore' do
    it 'should create project.lock.json' do
      rake 'restore', quiet: true

      expect(Pathname.new 'project.lock.json').to exist
    end
  end

  describe 'rake build' do
    it 'should build the executable' do
      rake 'build', quiet: true

      expect(Pathname.new 'bin/Debug/dnx451/hello-world.dll').to exist
    end
  end

  describe 'rake pack' do
    it 'should build a nuget package' do
      rake 'restore', 'pack', quiet: true

      bin_dir = Pathname.new 'bin/Debug'
      expect(bin_dir + 'hello-world.1.0.0.nupkg').to exist
      expect(bin_dir + 'hello-world.1.0.0.symbols.nupkg').to exist
    end
  end
end
