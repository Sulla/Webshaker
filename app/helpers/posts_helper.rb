module PostsHelper
  
  def author_name(post)
    if post.user.company
      raw %Q(<span class="note"> By <a href="/profiles/#{post.user.profile.id}">#{post.user.fullname}</a> (<a href="/companies/#{post.user.company.id}">#{post.user.company.name}</a>) on #{format_date(post.created_at)}</span>)
    else
      raw %Q(<span class="note"> By <a href="/profiles/#{post.user.profile.id}">#{post.user.fullname}</a> on #{format_date(post.created_at)}</span>)
    end
  end
  
  def get_post_value(attribute, post)
    post[attribute] if post
  end
  
  def include_comments_for(post)
    !post.is_job?
  end
    
end
