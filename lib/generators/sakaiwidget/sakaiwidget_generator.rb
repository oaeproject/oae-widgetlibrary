class SakaiwidgetGenerator < Rails::Generators::NamedBase
  
  source_root File.expand_path('../templates', __FILE__)

  def create_sakaiwidget 
    @apptitle = @_initializer[2][:apptitle]
    @appstyle = @_initializer[2][:appstyle]
    @appdesc = @_initializer[2][:appdesc]
    @showinsakaigoodies = @_initializer[2][:showinsakaigoodies]
    @personalportal = @_initializer[2][:personalportal]
    @createdir = @_initializer[2][:destination_root]    

    if @appstyle.eql? "skeleton" then
      empty_directory "#{@createdir}"
      empty_directory "#{@createdir}/#{file_name}"
      empty_directory "#{@createdir}/#{file_name}/bundles"
      copy_file "_template/bundles/default.properties", "#{@createdir}/#{file_name}/bundles/default.properties"
      empty_directory "#{@createdir}/#{file_name}/css"
      template "_template/css/WIDGET_ID.css", "#{@createdir}/#{file_name}/css/#{file_name}.css"
      empty_directory "#{@createdir}/#{file_name}/images"
      copy_file "_template/images/WIDGET_ID.png", "#{@createdir}/#{file_name}/images/#{file_name}.png"
      empty_directory "#{@createdir}/#{file_name}/javascript"
      template "_template/javascript/WIDGET_ID.js", "#{@createdir}/#{file_name}/javascript/#{file_name}.js"
      template "_template/config.json", "#{@createdir}/#{file_name}/config.json"
      copy_file "_template/README.txt", "#{@createdir}/#{file_name}/README.txt"
      template "_template/WIDGET_ID.html", "#{@createdir}/#{file_name}/#{file_name}.html"
    elsif @appstyle.eql? "helloworld" then
      empty_directory "#{@createdir}"
      empty_directory "#{@createdir}/#{file_name}"
      empty_directory "#{@createdir}/#{file_name}/bundles"
      copy_file "helloworld/bundles/default.properties", "#{@createdir}/#{file_name}/bundles/default.properties"
      empty_directory "#{@createdir}/#{file_name}/css"
      template "helloworld/css/helloworld.css", "#{@createdir}/#{file_name}/css/#{file_name}.css"
      empty_directory "#{@createdir}/#{file_name}/images"
      copy_file "helloworld/images/helloworld_icon.png", "#{@createdir}/#{file_name}/images/#{file_name}.png"
      empty_directory "#{@createdir}/#{file_name}/javascript"
      template "helloworld/javascript/helloworld.js", "#{@createdir}/#{file_name}/javascript/#{file_name}.js"
      template "helloworld/config.json", "#{@createdir}/#{file_name}/config.json"
      template "helloworld/README.txt", "#{@createdir}/#{file_name}/README.txt"
      template "helloworld/helloworld.html", "#{@createdir}/#{file_name}/#{file_name}.html"
    end
  end
end
