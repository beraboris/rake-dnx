require 'spec_helper'

describe Rake::Dnx do
  it 'should have a version number' do
    expect(Rake::Dnx::VERSION).not_to be nil
  end

  describe '::dnx' do
    it 'should call the dnx command with the given subcommand' do
      expect(Rake::Dnx).to receive(:system)
        .with('dnx', 'some-subcommand')
        .and_return true

      Rake::Dnx.dnx 'some-subcommand'
    end

    it 'should fail if the dnx command fails' do
      allow(Rake::Dnx).to receive(:system).and_return false

      expect { Rake::Dnx.dnx('something') }.to raise_error(Rake::Dnx::DnxError)
    end

    it 'should fail if the dnx command is missing' do
      allow(Rake::Dnx).to receive(:system).and_return nil

      expect { Rake::Dnx.dnx('something') }
        .to raise_error(Rake::Dnx::DnxNotFoundError)
    end

    it 'should pass the project argument' do
      expect(Rake::Dnx).to receive(:system)
        .with('dnx', '--project', 'My.Super.Project', 'thing').and_return true

      Rake::Dnx.dnx 'thing', project: 'My.Super.Project'
    end
  end
end
