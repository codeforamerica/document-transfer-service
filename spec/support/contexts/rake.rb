# frozen_string_literal: true

require_relative '../../../lib/document_transfer'

shared_context 'with rake' do
  subject(:task) { rake[task_name] }

  let(:rake) { Rake::Application.new }
  let(:task_name) { self.class.top_level_description }

  before do
    Rake.application = rake
    DocumentTransfer.load_rake_tasks
    Rake::Task.define_task(:environment)
  end

  # Invoke the task and return output.
  #
  # @return [String] The output of the task.
  def invoke_task
    output = StringIO.new
    $stdout = output
    task.invoke
    $stdout = STDOUT
    output.string
  end
end
