require 'rake/dnx/project'

describe Rake::Dnx::Project do
  describe '::exist?' do
    it 'should be false if the dir does not have a project.json file' do
      path = Pathname.new(__FILE__) + '../../../fixtures/bad-project'
      expect(Rake::Dnx::Project.exist? path).to be false
    end

    it 'should be false if the dir does not exits' do
      path = Pathname.new(__FILE__) + '../../../fixtures/does-not-exist'
      expect(Rake::Dnx::Project.exist? path).to be false
    end

    it 'should be true if the dir has a project.json file' do
      path = Pathname.new(__FILE__) + '../../../fixtures/single-project'
      expect(Rake::Dnx::Project.exist? path).to be true
    end
  end

  describe '::parse' do
    let(:dir) { Pathname.new(__FILE__) + '../../../fixtures/single-project' }

    it 'should use the dir name as the name' do
      expect(Rake::Dnx::Project.parse(dir).name).to eq 'single-project'
    end

    it 'should parse the commands as an array' do
      expect(Rake::Dnx::Project.parse(dir).commands).to eq %w(fi fo fum)
    end

    it 'should set the path to the given one' do
      expect(Rake::Dnx::Project.parse(dir).path).to eq dir
    end
  end
end
