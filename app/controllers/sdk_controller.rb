class SdkController < ApplicationController
    require 'open-uri'
    require 'redcarpet'

    def index
        render :layout => 'application'
    end

    def sdk_section
        @content = nil
        pad = params[:section].split('/').last
        if pad == 'development-environment-setup'
            markdown = open('https://raw.github.com/sakaiproject/Hilary/master/README.md') {|io| io.read}
            renderer = Redcarpet::Render::HTML
            render = renderer.new(render_extensions = {})
            @content = Redcarpet::Markdown.new(render, parse_extensions = {}).render(markdown).html_safe
        end

        render pad, :layout => request.xhr? ? 'sdkxhr' : 'lhnavigation', :locals => { :content => @content }
    end
end
