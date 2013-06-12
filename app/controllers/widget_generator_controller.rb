require 'zip/zip'
require 'zip/zipfilesystem'

require 'rails/generators'
require 'guid'
require 'find'

class WidgetGeneratorController < ApplicationController

  def zippedwidget
    # The six variables below are the parameters that should be changed for
    # passing into the widget generator.
    appstyle = params[:widgetbuilder_skeletontype]
    myappname = params[:widgetbuilder_title]
    appdesc = params[:widgetbuilder_description]
    tempdir = "#{Dir::tmpdir}/#{Guid.new}"

    # This is a bit of a leaky abstraction really. But we're doing the same thing
    # the generator does (humanize.downcase), but *also* replacing the spaces
    # because we don't want those in our tool ID's. We using this below to make
    # the temp directory for the zip file as well.
    filename = myappname.humanize.downcase.gsub(' ','')

    Rails::Generators.invoke 'sakaiwidget', ["#{filename}"], :behavior => :invoke, :destination_root => tempdir, :apptitle => myappname, :appdesc => appdesc, :appstyle => appstyle #, :personalportal => personalportal, :sakaidocs => sakaidocs
    t = Tempfile.new("#{filename}")
    zos = Zip::ZipOutputStream.open(t.path)
    prefix = "#{tempdir}/"
    Find.find("#{tempdir}/#{filename}") do |path| 
      zippath = path.slice(prefix.length...path.length)
      if zippath != myappname then
        if !File.directory?(path) then
          zos.put_next_entry(zippath)
          open(path) do |f| 
              zos << f.read
          end
        end
      end
    end
    zos.close
    send_file t.path, :type => 'application/zip', :disposition => 'attachment', :filename => "#{myappname}.zip"   
    t.close
  end

end
