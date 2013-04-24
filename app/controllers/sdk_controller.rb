class SdkController < ApplicationController
    require 'net/http'
    require 'open-uri'
    require 'redcarpet'
    require 'yajl'

    # Properties

    @@url_readme_file = 'https://raw.github.com/sakaiproject/Hilary/master/README.md'
    @@url_rest_module = 'http://oae.oaeproject.org/api/doc/module/'
    @@url_rest_modules = 'http://oae.oaeproject.org/api/doc/modules/'

    # Show index page of SDK

    def index
        render :layout => 'application'
    end


    # Show section of SDK (e.g. api, faq...)

    def sdk_section
        
        # The content that will be passed to the template
        @content = nil
        # The requested template
        pad = params[:section].split('/').last   
        # Put the template in a temporary variable
        template = pad
              
        # If section is 'api'
        if pad == 'api'
            # If no module selected, load all the module names
            if params[:subsection] == nil
                @content = get_docs_from_rest_api
            # If a module is selected, load the module details
            else
                @content = get_doc_details('oae-logger')
                template = 'api-oae-module'
            end
        # If section is 'development-environment-setup', load the parse the markdown file
        elsif pad == 'development-environment-setup'
            @content = parse_markdown
        end
        
        # Render template
        render template, :layout => request.xhr? ? 'sdkxhr' : 'lhnavigation', :locals => { :content => @content }
    end
    
    # Parse the markdown file

    def parse_markdown
        markdown = open(@@url_readme_file) {|io| io.read}
        renderer = Redcarpet::Render::HTML
        render = renderer.new(render_extensions = {})
        return Redcarpet::Markdown.new(render, parse_extensions = {}).render(markdown).html_safe
    end


    # Get all the modules from the REST API
    #
    # @return   {Array} arrData       The array containing all the module names

    def get_docs_from_rest_api
        resp = Net::HTTP.get_response(URI.parse(@@url_rest_modules))
        data = resp.body        
        if !resp.body.is_a?(Net::HTTPSuccess)
            data = ActiveSupport::JSON.decode(resp.body).sort
        end        
        return data
    end


    # Get the module details from the REST API
    #
    # @param    {String} m            The requested module
    # @return   {Hash} *              The hash containing the module details

    def get_doc_details(m)
        resp = Net::HTTP.get_response(URI.parse(@@url_rest_module + m))                     
        return Yajl::Parser.parse(resp.body)
    end
end
