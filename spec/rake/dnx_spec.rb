require 'spec_helper'

shared_examples 'a command wrapper' do
  it 'should call the command with the given subcommand' do
    expect(Rake::Dnx).to receive(:system)
      .with(command, 'some-subcommand')
      .and_return true

    Rake::Dnx.public_send command, 'some-subcommand'
  end

  it 'should fail if the command fails' do
    allow(Rake::Dnx).to receive(:system).and_return false

    expect { Rake::Dnx.public_send(command, 'something') }
      .to raise_error(Rake::Dnx::CommandError)
  end

  it 'should fail if the command is missing' do
    allow(Rake::Dnx).to receive(:system).and_return nil

    expect { Rake::Dnx.public_send(command, 'something') }
      .to raise_error(Rake::Dnx::CommandNotFoundError)
  end

  it 'should pass the project argument' do
    expect(Rake::Dnx).to receive(:system)
      .with(command, '--project', 'My.Super.Project', 'thing').and_return true

    Rake::Dnx.public_send command, 'thing', project: 'My.Super.Project'
  end
end

describe Rake::Dnx do
  it 'should have a version number' do
    expect(Rake::Dnx::VERSION).not_to be nil
  end

  describe '::dnx' do
    let(:command) { 'dnx' }
    it_should_behave_like 'a command wrapper'
  end

  describe '::dnu' do
    let(:command) { 'dnu' }
    it_should_behave_like 'a command wrapper'
  end
end
