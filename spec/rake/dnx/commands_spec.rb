shared_examples 'a command wrapper' do
  it 'should call the command with the given subcommand' do
    expect(self).to receive(:system)
      .with(command, 'some-subcommand')
      .and_return true

    public_send command, 'some-subcommand'
  end

  it 'should fail if the command fails' do
    allow(self).to receive(:system).and_return false

    expect { public_send(command, 'something') }
      .to raise_error(Rake::Dnx::CommandError)
  end

  it 'should fail if the command is missing' do
    allow(self).to receive(:system).and_return nil

    expect { public_send(command, 'something') }
      .to raise_error(Rake::Dnx::CommandNotFoundError)
  end
end

describe Rake::Dnx::Commands do
  include Rake::Dnx::Commands

  describe '#dnx' do
    let(:command) { 'dnx' }
    it_should_behave_like 'a command wrapper'

    it 'should pass the project argument' do
      skip 'Temporary working around bug (aspnet/Home#981)'

      expect(self).to receive(:system)
        .with(command, '-p', 'My.Super.Project', 'thing').and_return true
      project = Rake::Dnx::Project.new 'My.Super.Project',
                                       [],
                                       Pathname.new('src/My.Super.Project')

      public_send command, 'thing', project: project
    end

    it 'should cd to the project dir' do
      dir = Pathname.new(__FILE__) + '../../../fixtures/single-project'
      expect(self).to receive(:system) do
        expect(Dir.pwd).to end_with dir.realpath.to_s
      end
      project = Rake::Dnx::Project.parse dir

      dnx 'thing', project: project
    end
  end

  describe '#dnu' do
    let(:command) { 'dnu' }
    it_should_behave_like 'a command wrapper'

    it 'should change directory with the project option' do
      dir = Pathname.new(__FILE__) + '../../../fixtures/single-project'
      expect(self).to receive(:system) do
        expect(Dir.pwd).to end_with dir.realpath.to_s
      end
      project = Rake::Dnx::Project.parse dir

      dnu 'thing', project: project
    end
  end
end
