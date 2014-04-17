class BoardController < ApplicationController
  def index
    all_list_ids = wunderlist_lists.map(&:id)

    if params[:list_id]
      list_ids = params[:list_id]
    else
      list_ids = all_list_ids
    end

    db_lists = List.where(wunderlist_id: list_ids)
    @lists = db_lists.each_with_object([]) do |list, arr|
      arr << info(list)
    end

    completed_tasks = @lists.map do |list|
      wunderlist_completed_tasks(list.wunderlist_id)
    end.flatten

    uncompleted_tasks = @lists.map do |list|
      wunderlist_uncompleted_tasks(list.wunderlist_id)
    end.flatten

    @board = Board.new(completed_tasks, uncompleted_tasks)

    @lists = List.where(wunderlist_id: all_list_ids)
    @lists = @lists.each_with_object([]) do |list, arr|
      arr << info(list)
    end
  end
end
