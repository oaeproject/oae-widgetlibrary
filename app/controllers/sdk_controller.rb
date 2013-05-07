class SdkController < ApplicationController
    require 'net/http'
    require 'open-uri'
    require 'redcarpet'
    require 'yajl'
    include SdkHelper

    # Properties

    @@url_readme_file = 'https://raw.github.com/sakaiproject/Hilary/master/README.md'
    @@url_rest_api_doc = 'http://tenant1.oae.com/api/doc/'
    @@url_css_file = 'http://tenant1.oae.com/shared/oae/css/oae.components.css'
       
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
            
            # Path to the template
            template = "sdk/api/index"
                           
            # Show front or back end               
            if !params[:subsection].blank? 

                # Load the module names                
                @modules = get_doc_module_names(@@url_rest_api_doc + params[:subsection])
                
                # If the modules are not empty
                if !@modules.blank?
                    
                    # Set module title
                    @subsection = params[:subsection]
                                                    
                    # Set the url for the HTTPRequest
                    if !params[:module].blank? 
                        url = params[:module]
                        @module_title = params[:module]
                        
                        # Re-render the lhnavigation
                        render template, :layout => 'lhnavigation' if request.xhr?
                              
                    else 
                        url = @modules.first
                        @module_title = @modules.first 
                    end
                    
                    # Get the module details                                       
                    @content = get_doc_details(@@url_rest_api_doc + params[:subsection]  + '/' + url)                          

                    # Set the variables for rendering the page                
                    locals = { :modules => @modules, :subsection => @subsection, :content => @content, :title => @module_title }  
                        
                end     
                                                                           
            end
                    
        # If section is 'style-guide' & subsection is 'reusable-css'
        elsif template == 'style-guide' && params[:subsection] == 'reusable-css'
            
            # Path to the template
            template = "sdk/style-guide/reusable-css"
            
            # Get the versions
            @versions = get_skins_from_directory                    
            if @versions.length > 0

                # Check if version is set in the querystring
                @version = @versions.first()
                if !params[:module].blank?
                    @version = params[:module]
                end
            
            end
                                                
            # Pass the content as a parameter for the view variables
            locals = { :version => @version, :versions => @versions }            
                                                           
        # If section is 'development-environment-setup', load the parse the markdown file
        elsif template == 'development-environment-setup'
            @content = parse_markdown
            locals = { :content => @content }
        else
            template = params[:subsection] if !params[:subsection].blank?                
            locals = nil          
        end         
        
        # Render the template
        render template, :layout => request.xhr? ? 'sdkxhr' : 'lhnavigation' , :locals => locals      
                
    end   
end
