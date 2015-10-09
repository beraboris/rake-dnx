# Cleaner matcher to check if a task exists
# Ignoring style rules becaue this makes sence in the context of rspec
# rubocop:disable Style/PredicateName
def have_task(task)
  be_task_defined task
end

def project_path(name)
  Pathname.new(__FILE__) + '../../../fixtures' + name
end

shared_examples 'a dnu command task generator' do
  it 'should generate the dnu restore task' do
    dnx_discover

    expect(Rake::Task).to have_task(:restore)
  end

  it 'should generate the dnu build task' do
    dnx_discover

    expect(Rake::Task).to have_task(:build)
  end

  it 'should generate the dnu pack task' do
    dnx_discover

    expect(Rake::Task).to have_task(:pack)
  end
end

describe Rake::Dnx::Discovery do
  include Rake::Dnx::Commands
  include Rake::Dnx::Discovery

  describe '::dnx_discover' do
    before do
      Rake.application.clear
    end

    context 'with a global.json file' do
      before do
        Dir.chdir project_path 'multi-project'
      end

      it_should_behave_like 'a dnu command task generator'

      it 'should generate the dnu build task for every project' do
        dnx_discover

        expect(Rake::Task).to have_task('Project.A:build')
        expect(Rake::Task).to have_task('Project.A.Test:build')
        expect(Rake::Task).to have_task('Project.B:build')
        expect(Rake::Task).to have_task('Project.B.Test:build')
      end

      it 'should generate the dnu pack task for every project' do
        dnx_discover

        expect(Rake::Task).to have_task('Project.A:pack')
        expect(Rake::Task).to have_task('Project.A.Test:pack')
        expect(Rake::Task).to have_task('Project.B:pack')
        expect(Rake::Task).to have_task('Project.B.Test:pack')
      end

      it 'should generate the dnu publish task for every project' do
        dnx_discover

        expect(Rake::Task).to have_task('Project.A:publish')
        expect(Rake::Task).to have_task('Project.A.Test:publish')
        expect(Rake::Task).to have_task('Project.B:publish')
        expect(Rake::Task).to have_task('Project.B.Test:publish')
      end

      it 'should generate the dnx run task for every project' do
        dnx_discover

        expect(Rake::Task).to have_task('Project.A:run')
        expect(Rake::Task).to have_task('Project.A.Test:run')
        expect(Rake::Task).to have_task('Project.B:run')
        expect(Rake::Task).to have_task('Project.B.Test:run')
      end

      it 'should generate command tasks for every project' do
        dnx_discover

        expect(Rake::Task).to have_task 'Project.A:a-command'
        expect(Rake::Task).to have_task 'Project.A:common-command'
        expect(Rake::Task).to have_task 'Project.B:b-command'
        expect(Rake::Task).to have_task 'Project.B:common-command'
      end

      it 'should generate aggregate command tasks' do
        dnx_discover

        expect(Rake::Task).to have_task :test
        expect(Rake::Task).to have_task 'common-command'
        expect(Rake::Task).to have_task 'a-command'
        expect(Rake::Task).to have_task 'b-command'
      end

      it 'should not generate a dnx run task' do
        dnx_discover

        expect(Rake::Task).not_to have_task(:run)
      end

      it 'should not generate tasks for non-projects' do
        dnx_discover

        expect(Rake::Task).not_to have_task 'Not.A.Project:run'
        expect(Rake::Task).not_to have_task 'Not.A.Project:build'
        expect(Rake::Task).not_to have_task 'Not.A.Project:pack'
        expect(Rake::Task).not_to have_task 'Not.A.Project:publish'
      end

      it 'should not have a publish task' do
        dnx_discover

        expect(Rake::Task).not_to have_task :publish
      end
    end

    context 'with a project.json file' do
      before do
        Dir.chdir project_path 'single-project'
      end

      it_should_behave_like 'a dnu command task generator'

      it 'should generate a dnx run task' do
        dnx_discover

        expect(Rake::Task).to have_task :run
      end

      it 'should generate a task for each command' do
        dnx_discover

        expect(Rake::Task).to have_task :fi
        expect(Rake::Task).to have_task :fo
        expect(Rake::Task).to have_task :fum
      end

      it 'should generate the dnu publish task' do
        dnx_discover

        expect(Rake::Task).to have_task(:publish)
      end
    end

    context 'with no global.json or project.json file in the root' do
      before do
        Dir.chdir project_path 'bad-project'
      end

      it 'should fail' do
        expect { dnx_discover }
          .to raise_error(Rake::Dnx::DiscoveryError)
      end
    end
  end
end
