# coding: utf-8

Mailing.where(:sent => false).each do |mailing|
  mailing.sent = true
  mailing.save
  
  item = Post.find(mailing.resource_id)
  
  Alert.where(:model => mailing.model).each do |alert|
    if item.is_article?
      Notifier.new_article(alert.user, item).deliver
    elsif item.is_event?
      Notifier.new_event(alert.user, item).deliver
    elsif item.is_project?
      Notifier.new_project(alert.user, item).deliver
    elsif item.is_job?
      Notifier.new_job(alert.user, item).deliver
    elsif item.is_interview?
      Notifier.new_interview(alert.user, item).deliver
    end
  end
  
end