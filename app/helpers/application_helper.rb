module ApplicationHelper
  
  def avatar(user, html_class = '')
    if user.avatar_file_name.present?
      image_tag(user.avatar(:thumb), :alt => user.fullname, :class => html_class)
    else
      gravatar_image_tag(user.email, :alt => user.fullname, :class => html_class, :gravatar => { :default => "http://#{HOST}/images/noAvatar.png" })
    end
  end
  
  def avatar_small(user)
    if user.avatar_file_name.present?
      image_tag(user.avatar(:thumb), :alt => user.fullname, :width => '96x96', :class => 'photo')
    else
      gravatar_image_tag(user.email, :alt => user.fullname, :width => '96x96', :class => 'photo', :gravatar => { :default => "http://#{HOST}/images/noAvatar.png" })
    end
  end
  
  def avatar_micro(user)
    if user.avatar_file_name.present?
      image_tag(user.avatar(:thumb), :alt => user.fullname, :width => '36x36', :class => 'photo')
    else
      gravatar_image_tag(user.email, :alt => user.fullname, :width => '36x36', :class => 'photo', :gravatar => { :default => "http://#{HOST}/images/noAvatar.png" })
    end
  end  
  
  def avatar_micro_url(user)
    if user.avatar_file_name.present?
      user.avatar(:thumb)
    else
      "http://#{HOST}/images/noAvatar.png"
    end
  end
  
  def format_date(date)
    date.strftime('%a %d %B %Y %H:%M').gsub("00:00", "")
  end
  
  def set_odd(index)
    index % 2 == 0 ? 'odd' : 'even'
  end
  
  def display_flash
    str = ""
	  if flash[:notice]
      str << %Q(<div class="msg msg-success">
  			<span class="img-success"></span>
  			<p>#{flash[:notice]}</p>
	      <span class="hide_flash hide hide-error pictos size2" title="Hide">*</span>  			
	      <hr class="clear" />  			
  		</div>)
	  end
	  
    if flash[:error]
      str << %Q(<div class="msg msg-error">
  			<span class="img-error"></span>
  			<p>#{flash[:error]}</p>
	      <span class="hide_flash hide hide-error pictos size2" title="Hide">*</span>			
	      <hr class="clear" />  			
  		</div>)
	  end
	  
	  if flash[:alert]
      str << %Q(<div class="msg msg-warning">
  			<span class="img-warning"></span>
  			<p>#{flash[:alert]}</p>
	      <span class="hide_flash hide hide-error pictos size2" title="Hide">*</span>			
	      <hr class="clear" />  			
  		</div>)
	  end
	  
	  str << "" unless str.blank?
	  str.html_safe
  end
  
  def error_messages(model)
    html = ""
    if model.errors.any?
      html << %Q(<div id="error_explanation">)
      html << t('custom_errors.validation')
      html << "<ul>"
      
      model.errors.full_messages.each do |msg|
        html << %Q(<li>#{msg}</li>)
      end
      html << "</ul>"
    end
    raw html
  end
  
  def field_with_error?(model, field)
    if model && model.errors.any? && model.errors[field].present?
      %Q(class=field_with_errors)
    end
  end
  
  def get_like_status(user, type, id)
    return 'action' unless user
    if user.has_liked?(type, id)
      "action actionOK"
    else''
      "action"
    end
  end
  
  def get_like_status_small(user, type, id)
    return 'action' unless user
    if user.has_liked?(type, id)
      "action actionOKSmall"
    else
      "action"
    end
  end  
  
  def get_bookmark_status(user, type, id)
    return 'action' unless user    
    if user.has_bookmarked?(type, id)
      "action actionOK"
    else
      "action"
    end    
  end
  
  def set_selected(key, id)
    return 'selected' if cookies[key].blank? && id == 0
    return '' if cookies[key].nil?
    
    return 'selected' if cookies[key].split('_').include?("#{id}")
  end
  
  def sanitize_content(content, post)
    if post && post.user && post.user.is_admin?
      content.html_safe
    else
      sanitize content
    end
  end
  
  def current_acount_menu_selected(menu_name, selected)
    "current" if menu_name == selected
  end
  
  def get_selected_post_type(post, type)
    if post.post_type_id == type
      'selected'
    else
      ''
    end
  end
  
  def set_alert_status(model, user)
    if user.has_alert_for?(model)
      "checked=\"checked\""
    else
      ''
    end
  end
  
end
