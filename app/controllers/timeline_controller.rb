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
    @timeline = Timeline.new(tasks.select(&:due_date).sort_by(&:due_date)) #sorry about all this
  end
end
