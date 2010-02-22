class Post
  POSTS_PATH = "#{RAILS_ROOT}/app/views/posts"

  attr_reader :file, :id, :title, :updated_at, :created_at, :post_meta

  def initialize(path)
    # Fetch meta data for blog post.
    @post_meta = meta[@id]

    # The path of the source file.
    @file = path
    # views/posts/post_first_post.html.haml => first_post
    name = File.basename(file).split('.').first[5..-1]
    # The id of this post for url_for.
    @id = name

    # Create a default set of meta values for this post.
    @post_meta[@id] ||= {}
    @post_meta[@id].reverse_merge!({
      'title' => nil,
      'created_at' => nil,
      'updated_at' => nil
    })

    # The title of the post.
    @title = @post_meta[@id]['title'] || name.humanize
    # When this post created and updated.
    @updated_at = @post_meta[@id]['updated_at'] || File::mtime(file)
    @created_at = @post_meta[@id]['created_at'] || @updated_at
  end

  # Return meta data for blog.
  def self.meta
    m = if File.exists?(POSTS_PATH+'/meta.yml')
      parsed_yaml = ERB.new(IO.read(POSTS_PATH+'/meta.yml')).result
      YAML::load(parsed_yaml)
    else
      {}
    end
    return m
  end

  # Return all posts, most recent updated first.
  def self.all
    posts = Dir[POSTS_PATH+"/post_*"]
    # posts = posts.select{|file| File.basename(file) =~ /^post_.+$/}
    posts.map!{|file| Post.new(file)}
    posts.sort{|p1,p2| p2.updated_at <=> p1.updated_at}
  end
  
  def self.find(id)
    posts = Dir[POSTS_PATH+"/*"]
    posts = posts.select{|file| File.basename(file) =~ /^post_#{id}.+$/}
    return Post.new(posts.first)
  end
  
  def to_s
    return id
  end
end