class Timeline
  attr_reader :tasks, :sprints

  class Sprint
    attr_reader :date, :tasks
    def initialize(date, tasks)
      @date = date
      @tasks = tasks
    end
  end

  def initialize(tasks)
    @tasks = tasks
    @sprints = split_into_sprints
  end

  def each
    @sprints.each do |sprint|
      yield sprint
    end
  end

  private
  def sprint_boundaries
    start_date = Date.parse("3/1/2014") #I'm sure there's a non-stupid way to do this
    @sprint_boundaries ||= 26.times.map do |n|
      start_date + ((n + 1) * 14 ) #every 2 weeks
    end
  end

  def split_into_sprints
    sprints = []
    sprint_boundaries.inject(@tasks) do |unselected_tasks, date|
      for_this_sprint, unclaimed = unselected_tasks.partition{|t| Date.parse(t.due_date) <= date }
      sprints << Sprint.new(date, for_this_sprint)
      unclaimed
    end
    sprints
  end
end
