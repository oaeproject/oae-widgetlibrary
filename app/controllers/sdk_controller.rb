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
            @content = parse_markdown
        end
        render pad, :layout => request.xhr? ? 'sdkxhr' : 'lhnavigation', :locals => { :content => @content }
    end

    def parse_markdown
        markdown = open('https://raw.github.com/sakaiproject/Hilary/master/README.md') {|io| io.read}
        renderer = Redcarpet::Render::HTML
        render = renderer.new(render_extensions = {})
        return Redcarpet::Markdown.new(render, parse_extensions = {}).render(markdown).html_safe
    end
end
