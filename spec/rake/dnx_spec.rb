require 'spec_helper'

# Cleaner matcher to check if a task exists
# Ignoring style rules becaue this makes sence in the context of rspec
# rubocop:disable Style/PredicateName
def have_task(task)
  be_task_defined task
end

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

shared_examples 'a dnu command task generator' do
  it 'should generate the dnu restore task' do
    Rake::Dnx.dnx_discover

    expect(Rake::Task).to have_task(:restore)
  end

  it 'should generate the dnu build task' do
    Rake::Dnx.dnx_discover

    expect(Rake::Task).to have_task(:build)
  end

  it 'should generate the dnu pack task' do
    Rake::Dnx.dnx_discover

    expect(Rake::Task).to have_task(:pack)
  end

  it 'should generate the dnu publish task' do
    Rake::Dnx.dnx_discover

    expect(Rake::Task).to have_task(:publish)
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

  describe '::dnx_discover' do
    context 'with a global.json file' do
      before do
        Dir.chdir Pathname.new(__FILE__) + '../../fixtures/multi-project'
      end

      it_should_behave_like 'a dnu command task generator'

      it 'should generate the dnu build task for every project'
      it 'should generate the dnu pack task for every project'
      it 'should generate the dnu publish task for every project'
      it 'should generate the dnx run task for every project'
      it 'should generate command tasks for every project'
      it 'should generate aggregate command tasks'
      it 'should not generate a dnx run task'
    end

    context 'with a project.json file' do
      before do
        Dir.chdir Pathname.new(__FILE__) + '../../fixtures/single-project'
      end

      it_should_behave_like 'a dnu command task generator'

      it 'should generate a dnx run task'
      it 'should generate a task for each command'
    end

    context 'with no global.json or project.json file in the root' do
      before do
        Dir.chdir Pathname.new(__FILE__) + '../../fixtures/bad-project'
      end

      it 'should fail' do
        expect { Rake::Dnx.dnx_discover }
          .to raise_error(Rake::Dnx::DiscoveryError)
      end
    end
  end
end
