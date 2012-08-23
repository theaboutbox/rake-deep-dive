require 'redcarpet'

def markdown_convert(source_file, dest_file)
  markdown = Redcarpet::Markdown.new(
    Redcarpet::Render::XHTML,
    autolink: true)
  html = markdown.render(open(source_file).read)
  open(dest_file,'w').print(html)
end

# Creates a task to convert a bunch of markdown files to html
def markdown(task_name, source_files, dest_dir)
  directory dest_dir
  dest_files = source_files.pathmap("#{dest_dir}/%n.html")
  dest_files.zip(source_files).each do |target,source|
    file target => [source, dest_dir] do
      markdown_convert(source,target)
    end
  end
  task task_name => dest_files
end
