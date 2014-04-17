class SyncWorker
  attr_reader :service

  def initialize(service)
    @service = service
  end

  def call
    get_lists
    get_users
  end

  def get_lists
    resp = service.get("v1/lists")
    if resp.success?
      resp.each do |json|
        list = List.find_or_create_with_json(json)
        if list.synced?
          get_tasks_for_list(list)
          get_comments_for_list(list)
        end
      end
    end
  end

  def get_users
    resp = service.get("v1/users")
    if resp.success?
      resp.each do |json|
        User.find_or_create_with_json(json)
      end
    end
  end

  def get_tasks_for_list(list)
    resp = service.get("v1/tasks", list_id: list.wunderlist_id)
    if resp.success?
      resp.each do |json|
        Task.find_or_create_with_json(json)
      end
    end
  end

  def get_comments_for_list(list)
    resp = service.get("v1/comments", list_id: list.wunderlist_id)
    if resp.success?
      resp.each do |json|
        Comment.find_or_create_with_json(json)
      end
    end
  end

  def get_comments_for_task(task)
    resp = service.get("v1/comments", task_id: task.wunderlist_id)
    if resp.success?
      resp.each do |json|
        Comment.find_or_create_with_json(json)
      end
    end
  end
end
