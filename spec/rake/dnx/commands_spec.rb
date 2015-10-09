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

  it 'should pass the project argument' do
    expect(self).to receive(:system)
      .with(command, '--project', 'My.Super.Project', 'thing').and_return true

    public_send command, 'thing', project: 'My.Super.Project'
  end
end

describe Rake::Dnx::Commands do
  include Rake::Dnx::Commands

  describe '#dnx' do
    let(:command) { 'dnx' }
    it_should_behave_like 'a command wrapper'
  end

  describe '#dnu' do
    let(:command) { 'dnu' }
    it_should_behave_like 'a command wrapper'
  end
end
