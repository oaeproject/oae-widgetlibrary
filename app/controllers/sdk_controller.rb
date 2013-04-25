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
        
        # The requested template
        template = params[:section]   
                      
        # If section is 'api'
        if template == 'api'
            # Load the module names
            @modules = get_doc_module_names
            # Show the first module by default
            if params[:subsection] == nil
                @module_title = @modules.first
                @content = get_doc_details(@modules.first)
            # If a module is selected, load the module details
            else                
                @module_title = params[:subsection]
                @content = get_doc_details(@module_title)
            end
            locals = { :modules => @modules, :content => @content, :title => @module_title }
        # If section is 'development-environment-setup', load the parse the markdown file
        elsif template == 'development-environment-setup'
            @content = parse_markdown
            locals = { :content => @content }
        else
            template = params[:section]
            if !params[:subsection].blank?
                template = params[:subsection]
            end  
        locals = nil          
        end         
        
        # Render the template
        render template, :layout => request.xhr? ? 'sdkxhr' : 'lhnavigation', :locals => locals                            
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
    # @return   {Array}     arrData       The array containing all the module names

    def get_doc_module_names
        resp = Net::HTTP.get_response(URI.parse(@@url_rest_modules))
        data = resp.body        
        if !resp.body.is_a?(Net::HTTPSuccess)
            data = ActiveSupport::JSON.decode(resp.body).sort
        end        
        return data
    end


    # Get the module details from the REST API
    #
    # @param    {String}    m              The requested module
    # @return   {Hash}      *              The hash containing the module details

    def get_doc_details(m)
        resp = Net::HTTP.get_response(URI.parse(@@url_rest_module + m))                     
        return Yajl::Parser.parse(resp.body)
    end
end
