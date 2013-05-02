module SdkHelper
    
    # Regular expressions
    
    @@regex_cat_title = /\/\*{3,}\s*.*\s*\*+\//
    @@regex_description = /\/{1}\*{2}\s*(\*?\s.*\s*)*\*{1}\/{1}/
    @@regex_selector = /(\S*\.?\#?[^\s]+\s{1}\{(\s*[^\;]*;+)*\s*\}{1})/
    
    
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
      
          
    # Remove all the characters from a string (to create a clean title)
    #
    # @param    {Array}  chars              The characters that need to be replaced
    # @param    {String} string             The given string that needs to be cleaned up
    # @return   {String} string             The cleaned up string
    
    def replace_all_dirty_chars_from_string(chars, string)
        chars.each {|char| string.gsub!(char, "")}
        return string
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
                    obj['title'] = replace_all_dirty_chars_from_string([/\*/, /\//], cat)
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
                                
                                # Create new item object and set as selector by default
                                objItem = {}
                                objItem['value'] = item                                                           
                                objItem['type'] = "selector"
                                
                                # If the item matches ' /*'
                                if item.match(/^\/\*/)

                                    # Override type and set as description
                                    objItem['type'] = "description"     
                                    
                                    # Create some arrays for other elements
                                    objItem['examples'] = []
                                    objItem['snippets'] = []
                                    objItem['explanations'] = []
                                                                   
                                    # First remove all the '*' and the ' \' from the string                         
                                    val = replace_all_dirty_chars_from_string([/\*/, /^\//], item)  
                                    val = val.gsub(/\s</,"<pre><").gsub(/>$/,"></pre>").gsub(/\se.g./, "")
                                            
                                    # EXAMPLES: Get all the examples out of the string and remove 'example: '
                                    val.scan(/example.*\.html/).collect{|example| 
                                        example = example.gsub(/example:\s/,"")
                                        objItem['examples'].push(example)
                                    }                           
                                              
                                    # SNIPPETS: Get all the html snippets out of the string               
                                    val.scan(/<pre>.*<\/pre>/).collect{|item|
                                        snippet = item.gsub(/<pre>/,"").gsub(/<\/pre>/,"")
                                        objItem['snippets'].push(snippet)
                                    }
                                            
                                    # EXPLANATIONS: Parse comment blocks and remove the examples                        
                                    val.split(/<pre>.*<\/pre>/).each do |i|
                                        stripped = i.gsub(/\n/,"").gsub(/example:.*\.html/,"")                                        
                                        if !stripped.blank? && stripped != ""  
                                            objItem['explanations'].push(stripped) 
                                        end
                                    end                                    
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

end