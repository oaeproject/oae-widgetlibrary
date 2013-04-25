class SdkController < ApplicationController
    require 'net/http'
    require 'open-uri'
    require 'redcarpet'
    require 'yajl'

    # Properties

    @@url_readme_file = 'https://raw.github.com/sakaiproject/Hilary/master/README.md'
    @@url_rest_api_doc = 'http://tenant1.oae.com/api/doc/'

    # Show index page of SDK

    def index
        render :layout => 'application'
    end


    # Show section of SDK (e.g. api, faq...)

    def sdk_section
        
        # Properties
        @modules = nil
        
        # The requested template
        template = params[:section]   
                              
        # If section is 'api'
        if template == 'api'
                           
            # Show front or back end    
            if !params[:subsection].blank? 

                # Load the module names                
                @modules = get_doc_module_names(@@url_rest_api_doc + params[:subsection])     
                
                # Set module title
                @subsection = params[:subsection]
                                                
                # Set the url for the HTTPRequest
                if !params[:module].blank? 
                    url = params[:module]
                    @module_title = params[:module]
                else 
                    url = @modules.first
                    @module_title = @modules.first 
                end
                
                # Get the module details                                       
                @content = get_doc_details(@@url_rest_api_doc + params[:subsection]  + '/' + url)                    

                # Set the variables for rendering the page                
                locals = { :modules => @modules, :subsection => @subsection, :content => @content, :title => @module_title }  
                                                            
            end
                                                                            
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
    # @params   {String}    url             The endpoint of the documentation api
    # @return   {Array}     arrData         The array containing all the module names

    def get_doc_module_names(url)
        resp = Net::HTTP.get_response(URI.parse(url))
        data = resp.body        
        if !resp.body.is_a?(Net::HTTPSuccess)
            data = ActiveSupport::JSON.decode(resp.body).sort
        end        
        return data
    end


    # Get the module details from the REST API
    #
    # @param    {String}    url            The url for the HTTPRequest
    # @return   {Hash}      *              The hash containing the module details

    def get_doc_details(url)   
        resp = Net::HTTP.get_response(URI.parse(url))                             
        return Yajl::Parser.parse(resp.body)
    end
end
