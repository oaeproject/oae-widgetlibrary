class SakaiwidgetGenerator < Rails::Generators::NamedBase

  source_root File.expand_path('../templates', __FILE__)

  def create_sakaiwidget
    @apptitle = @_initializer[2][:apptitle]
    @appstyle = @_initializer[2][:appstyle]
    @createdir = @_initializer[2][:destination_root]

    if @appstyle.eql? "skeleton" then
      empty_directory "#{@createdir}"
      empty_directory "#{@createdir}/#{file_name}"
      copy_file "_template/README.md", "#{@createdir}/#{file_name}/README.md"
      empty_directory "#{@createdir}/#{file_name}/bundles"
      copy_file "_template/bundles/default.properties", "#{@createdir}/#{file_name}/bundles/default.properties"
      empty_directory "#{@createdir}/#{file_name}/css"
      template "_template/css/WIDGET_ID.css", "#{@createdir}/#{file_name}/css/#{file_name}.css"
      empty_directory "#{@createdir}/#{file_name}/js"
      template "_template/js/WIDGET_ID.js", "#{@createdir}/#{file_name}/js/#{file_name}.js"
      template "_template/manifest.json", "#{@createdir}/#{file_name}/manifest.json"
      template "_template/WIDGET_ID.html", "#{@createdir}/#{file_name}/#{file_name}.html"
    elsif @appstyle.eql? "helloworld" then
      empty_directory "#{@createdir}"
      empty_directory "#{@createdir}/#{file_name}"
      copy_file "helloworld/README.md", "#{@createdir}/#{file_name}/README.md"
      empty_directory "#{@createdir}/#{file_name}/bundles"
      copy_file "helloworld/bundles/default.properties", "#{@createdir}/#{file_name}/bundles/default.properties"
      copy_file "helloworld/bundles/de_DE.properties", "#{@createdir}/#{file_name}/bundles/de_DE.properties"
      copy_file "helloworld/bundles/es_ES.properties", "#{@createdir}/#{file_name}/bundles/es_ES.properties"
      copy_file "helloworld/bundles/fr_FR.properties", "#{@createdir}/#{file_name}/bundles/fr_FR.properties"
      copy_file "helloworld/bundles/ru_RU.properties", "#{@createdir}/#{file_name}/bundles/ru_RU.properties"
      empty_directory "#{@createdir}/#{file_name}/css"
      template "helloworld/css/helloworld.css", "#{@createdir}/#{file_name}/css/#{file_name}.css"
      empty_directory "#{@createdir}/#{file_name}/js"
      template "helloworld/js/helloworld.js", "#{@createdir}/#{file_name}/js/#{file_name}.js"
      template "helloworld/manifest.json", "#{@createdir}/#{file_name}/manifest.json"
      template "helloworld/helloworld.html", "#{@createdir}/#{file_name}/#{file_name}.html"
    end
  end
end

