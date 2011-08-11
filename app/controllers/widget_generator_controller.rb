require 'zip/zip'
require 'zip/zipfilesystem'

require 'rails/generators'
require 'guid'
require 'find'

class WidgetGeneratorController < ApplicationController

  def zippedwidget
    # The six variables below are the parameters that should be changed for
    # passing in to the widget generator.
    appstyle = "skeleton"
    myappname = "websakaiwidget"
    appdesc = "This is my widget from the Sakai OAE Widget Builder."
    tempdir = "#{Dir::tmpdir}/#{Guid.new}"
    showinsakaigoodies = "true"
    personalportal = "true"

    Rails::Generators.invoke 'sakaiwidget', ["#{myappname}"], :behavior => :invoke, :destination_root => tempdir, :appstyle => appstyle, :appdesc => appdesc, :showinsakaigoodies => showinsakaigoodies, :personalportal => personalportal
    t = Tempfile.new("#{myappname}")
    zos = Zip::ZipOutputStream.open(t.path)
    prefix = "#{tempdir}/"
    Find.find("#{tempdir}/#{myappname}") { |path| 
      zippath = path.slice(prefix.length...path.length)
      if zippath != myappname then
        if !File.directory?(path) then
          zos.put_next_entry(zippath)
          open(path) do |f| 
              zos << f.read
          end
        end
      end
    }
    zos.close
    send_file t.path, :type => 'application/zip', :disposition => 'attachment', :filename => "#{myappname}.zip"   
    t.close
  end

end
