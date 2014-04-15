class TimelineController < ApplicationController
  def index
    list_ids = wunderlist_lists.map(&:id)
    db_lists = List.where(wunderlist_id: list_ids)

    @completed_tasks = db_lists.map(&:wunderlist_id).each_with_object([]) do |id, completed|
      completed.concat wunderlist_completed_tasks(id)
    end

    @completed_tasks.sort_by!{ |x| x.completed_at }.reverse
  end
end
