class Board
  attr_reader :completed_tasks, :uncompleted_tasks

  def initialize(completed_tasks, uncompleted_tasks)
    @completed_tasks = completed_tasks
    @uncompleted_tasks = uncompleted_tasks
  end

  def open_and_assigned_tasks
    @open_tasks = @uncompleted_tasks.reject{ |task| task.title =~ /\#in-progress/ }
  end

  def open_tasks
    @open_tasks = @uncompleted_tasks.reject{ |task| task.title =~ /\#in-progress/ }.reject(&:assignee_id)
  end

  def assigned_tasks
    @assigned_tasks = @uncompleted_tasks.reject{ |task| task.title =~ /\#in-progress/ }.select(&:assignee_id)
  end

  def in_progress_tasks
    @progress_tasks = @uncompleted_tasks.select{ |task| task.title =~ /\#in-progress/ }.select(&:due_date).sort_by(&:due_date)
  end

  def done_tasks
    return @completed_tasks.select(&:due_date).sort_by(&:due_date)
  end

end
