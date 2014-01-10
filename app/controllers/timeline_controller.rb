class TimelineController < ApplicationController
  def index
    list_ids = wunderlist_lists.map(&:id)
    db_lists = List.where(wunderlist_id: list_ids)
    @lists = db_lists.each_with_object([]) do |list, arr|
      arr << info(list)
    end
    tasks = @lists.map do |list|
      wunderlist_completed_tasks(list.wunderlist_id).concat wunderlist_uncompleted_tasks(list.wunderlist_id)
    end.flatten
    @tasks_with_due_dates = split_into_sprints(tasks.select(&:due_date).sort_by(&:due_date)) #sorry about all this
  end

  def sprint_boundaries
    start_date = Date.parse("3/1/2014")
    @sprint_boundaries ||= 26.times.map do |n|
      start_date + ((n + 1) * 14 ) #every 2 weeks
    end
  end

  def split_into_sprints(tasks)
    sprints = []
    sprint_boundaries.inject(tasks) do |unselected_tasks, date|
      for_this_sprint, unclaimed = unselected_tasks.partition{|t| Date.parse(t.due_date) <= date }
      sprints << [date, for_this_sprint]
      unclaimed
    end
    sprints
  end
end
