class TimelineController < ApplicationController
  def index
    list_ids = wunderlist_lists.map(&:id)
    db_lists = List.where(wunderlist_id: list_ids)

    @completed_tasks = db_lists.map(&:wunderlist_id).each_with_object([]) do |id, completed|
      completed.concat wunderlist_completed_tasks(id)
    end

    @completed_tasks.sort_by!{ |x| x.completed_at }.reverse![0..60]

    @tasks_in_progress = db_lists.map(&:wunderlist_id).each_with_object([]) do |id, completed|
      completed.concat wunderlist_uncompleted_tasks(id).select(&:assignee_id)
    end.select { |t| t.title.include?("#in-progress") }

    @tasks_in_progress.sort_by!{ |x| x.created_at }.reverse

    @lists = db_lists.each_with_object([]) do |list, arr|
      arr << info(list)
    end.sort {|x,y| x.title <=> y.title}
  end
end
