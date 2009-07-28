class Post
  attr_reader :file, :id, :title, :updated_at

  def initialize(path)
    # The path of the source file.
    @file = path
    # views/posts/post_first_post.html.haml => first_post
    name = File.basename(file).split('.').first[5..-1]
    # The id of this post for url_for.
    @id = name
    # The title of the post.
    @title = name.humanize
    # When this file was last updated.
    @updated_at = File::mtime(file)
  end

  # Return all posts, most recent updated first.
  def self.all
    posts = Dir["#{RAILS_ROOT}/app/views/posts/*"]
    posts.map!{|file| Post.new(file)}
    posts = posts.select{|file| File.basename(file.file) =~ /^post_.+$/}
    posts.sort{|p1,p2| p2.updated_at <=> p1.updated_at}
  end
  
  def self.find(id)
    posts = Dir["#{RAILS_ROOT}/app/views/posts/*"]
    posts = posts.select{|file| File.basename(file) =~ /^post_#{id}.+$/}
    return Post.new(posts.first)
  end
  
  def to_s
    return id
  end
end