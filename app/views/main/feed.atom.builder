atom_feed do |feed|
  feed.title("WebShaker RSS")
  feed.updated(@posts.first.updated_at)

  @posts.each do |post|
    feed.entry(post) do |entry|
      entry.title(post.title)
      entry.content(post.content, :type => 'html')

      entry.author do |author|
        author.name(post.user.fullname)
      end
    end
  end
end