class SdkController < ApplicationController
    require 'net/http'
    require 'open-uri'
    require 'redcarpet'
    require 'yajl'

    # Properties

    @@url_readme_file = 'https://raw.github.com/sakaiproject/Hilary/master/README.md'
    @@url_rest_api_doc = 'http://tenant1.oae.com/api/doc/'
    @@url_css_file = 'http://tenant1.oae.com/shared/oae/css/oae.components.css'
    
    # Regular expressions
    #regex_cat = /(\/\*{3,}\s*.*\s*\*+\/\s*.*(\s*.**))/
    @@regex_cat_title = /\/\*{3,}\s*.*\s*\*+\//
    @@regex_description = /\/{1}\*{2}\s*(\*?\s.*\s*)*\*{1}\/{1}/
    @@regex_selector = /(\S*\.?\#?[^\s]+\s{1}\{(\s*[^\;]*;+)*\s*\}{1})/
   
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
            
            # Parse the CSS file
            @content = parse_css_file(@@url_css_file)
                        
            # Pass the content as a parameter for the view variables
            locals = { :content => @content }            
                                                           
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
    
    # Parse the markdown file
    #
    # @return {String}      *               The html that will be injected in the template

    def parse_markdown
        begin
            markdown = open(@@url_readme_file) {|io| io.read}
            renderer = Redcarpet::Render::HTML
            render = renderer.new(render_extensions = {})
            return Redcarpet::Markdown.new(render, parse_extensions = {}).render(markdown).html_safe
        rescue
            return nil
        end
    end


    # Get all the modules from the REST API
    #
    # @param    {String}    url             The endpoint of the documentation api
    # @return   {Array}     data            The array containing all the module names

    def get_doc_module_names(url)
        begin
            resp = Net::HTTP.get_response(URI.parse(url))
            data = resp.body        
            if !resp.body.is_a?(Net::HTTPSuccess)
                data = ActiveSupport::JSON.decode(resp.body).sort
            end  
            return data 
        rescue
            return nil
        end
    end


    # Get the module details from the REST API
    #
    # @param    {String}    url            The url for the HTTPRequest
    # @return   {Hash}      *              The hash containing the module details

    def get_doc_details(url)  
        begin 
            resp = Net::HTTP.get_response(URI.parse(url))           
            return Yajl::Parser.parse(resp.body)
        rescue
            return nil
        end
    end
    
    
    # Parse a css file
    #
    # @param    {String}    url             The endpoint of the documentation api
    # @return   {String}    the css dump    The hash containing the module details

    def parse_css_file(url)           
        output = nil     
        begin
            resp = Net::HTTP.get_response(URI.parse(url))            
            if resp.body.class == String
                                    
                # Create an array to store the categories => create item for each category
                categories = []    
                resp.body.scan(@@regex_cat_title).collect{|x| categories.push(x)}   
                    
                # Loop the categories to get their content
                i = 1
                arrCategories = []    
                categories.each do |cat| 
                                             
                    # Create an object for each category     
                    obj = {}
                    obj['title'] = remove_all_dirty_chars_from_string([["*", ""], ["/", ""]], cat)
                    obj['content'] = {}
                    
                    # To get the content, split on a regex of the type 'title'
                    # Returns a string with the description and selectors of the 'category'
                    # Puts each string in an array
                    splitted = []
                    resp.body.split(@@regex_cat_title).each do |item|
                        splitted.push(item)
                    end 
                                        
                    # Loop the content for the category and look for other codeblocks
                    # Splits the string on empty lines
                    selectors = []                    
                    splitted[i].split(/\n\n/).each do |paragraph|    

                        # Split the paragraph                                                     
                        if !paragraph.blank?
                            arrParagraph = paragraph.split('*/')                                                                                 
                            arrParagraph.each do |item| 
                                objItem = {}
                                objItem['value'] = item                                                           
                                objItem['type'] = "selector"
                                if item.match(/^\/\*/)
                                    objItem['type'] = "description"
                                    
                                    #TODO: make cleanup function dynamic...                                
                                    objItem['value'] = remove_all_dirty_chars_from_string([["*", ""]], item)
                                end                       
                                selectors.push(objItem)
                            end
                        end                                      
                    end           
                    
                    # Add the selectors to the content object
                    obj['content']['selectors'] = selectors
                    arrCategories.push(obj)
                    i += 1          
                end             
                output = arrCategories                                                                 
            end                               
            return output
        rescue
            return nil
        end        
    end
          
    # Remove all the characters from a string (to create a clean title)
    #
    # @param    {Array}  chars              The characters that need to be replaced
    # @param    {String} string             The given string that needs to be cleaned up
    # @return   {String} string             The cleaned up string
    
    def remove_all_dirty_chars_from_string(chars, string)
        chars.each {|char| string.gsub!(char[0], char[1])}
        return string
    end
    
end
