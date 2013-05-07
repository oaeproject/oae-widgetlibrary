#!/usr/bin/env ruby
require 'net/http'
require 'open-uri'
require 'timeout'

# Examples for testing
# http://tenant1.oae.com/shared/oae/css/oae.components.css
# public/examples/style-guide/assets/css/style.css

# Properties
@regex_cat_title = /\/\*{3,}\s*.*\s*\*+\//

@dir_public = "public/"
@dir_examples = "examples/"
@dir_template_target = "app/views/sdk/style-guide/"

@url_remote_css_file_components = nil
@url_remote_css_file_ui = nil

# Remove all the characters from a string (to create a clean title)
#
# @param    {Array}     chars           The characters that need to be replaced
# @param    {String}    string          The given string that needs to be cleaned up
# @return   {String}    string          The cleaned up string

def replace_chars_in_string(chars, string)
    chars.each {|char| string.gsub!(char, "")}
    return string
end



# Save the file
#
# @param    {String}    directory       The target directory for the new file
# @param    {String}    filename        The name of the HTML file
# @param    {String}    dump            The HTML dump

def save_file(directory, filename, dump)
    
    # First check if directory exists => create directory if not
    if !File.directory?("../../" + directory)
        Dir::mkdir("../../" + directory)
    end
   
    # Create a new file object and write content
    file = File.new("../../" + directory + filename, "w")
    file.write(dump)
    file.close
           
    puts '../../' + directory + filename + ' was created successfully!'
end



# Write the HTML to a file
#
# @param    {String}    directory       The target directory for the new file
# @param    {String}    dump            The HTML dump

def prepare_file(directory, dump)
    #print "Please enter the name for the HTML file: \n"
    #filename = gets.chomp
    filename = "_reusable-css-categories" 
    if filename != ""
        file = filename + ".html.erb"
        begin
            save_file(directory, file, dump)
        rescue
            print "Saving the HTML file failed. Try again? (y/n): "
            answer = gets.chomp
            if answer == "y"
                save_file(directory, file, dump)
            else
                exit   
                puts "Exit"         
            end
        end 
    else
        prepare_file(directory, dump)
    end
end



# Prepare an example file before creating
#
# @param    {String}    directory       The target directory for the new file
# @param    {String}    filename        The name for the new file
# @param    {Array}     lines           Array of all the HTML lines

def prepare_example_file(directory, filename, lines)  
    if lines.length > 0
        dump = "<html><head>"
        dump << "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" />"
        dump << "<meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge,chrome=1\" />"
        dump << "<link type=\"text/css\" rel=\"stylesheet\" href=\"https://raw.github.com/sakaiproject/3akai-ux/newframework/shared/oae/css/oae.core.css\"></link>"
        dump << "<link type=\"text/css\" rel=\"stylesheet\" href=\"http://tenant1.oae.com/api/ui/skin\"></link>"
        dump << "<link type=\"text/css\" rel=\"stylesheet\" href=\"../assets/css/style.css\"></link>"
        dump << "</head><body>"
        dump << "<div class=\"example-container\" id=\"#{filename}\">"
        lines.each{ |line|
            dump << line
        }
        dump << "</div>"
        dump << "</body></html>"
        save_file(directory, filename + ".html", dump)
    end
end



# Creates an object for each block
#
# @param    {String}    dump            A string containing a comment or a selector
# @return   {Object}    obj             The returned object

def create_css_block(dump)
    # Create a new object
    objBlock = {}
    objBlock['value'] = dump                                                           
    objBlock['type'] = "selector"
       
    # If the item matches ' /*'
    if dump.match(/^\/\*/)
        objBlock['type'] = "description" 
              
        # Create some arrays for other elements
        objBlock['examples'] = []
        objBlock['snippets'] = []
        objBlock['explanations'] = []
                                       
        # First remove all the '*' and the ' \' from the string                         
        val = replace_chars_in_string([/\*/, /^\//], dump)  
        val = val.gsub(/\s</,"<pre><").gsub(/>$/,"></pre>").gsub(/\se.g./, "")      
        
        # EXAMPLES: extract all the code out of the block
        tempval = val
        tempval.gsub(/\/?\*\s*[^<]*/,"")  
        tempval.scan(/<pre>.*<\/pre>/).collect{|item|
            item = item.gsub(/<pre>/,"").gsub(/<\/pre>/,"").gsub(/^(\s)*/,"")
            if item.length > 0
                objBlock['examples'].push(item)                          
            end
        }
                    
        # SNIPPETS: Get all the html snippets out of the string               
        val.scan(/<pre>.*<\/pre>/).collect{|item|
            snippet = item.gsub(/<pre>/,"").gsub(/<\/pre>/,"").gsub(/^(\s)*/,"")            
            objBlock['snippets'].push(snippet)
        }
                             
        # EXPLANATIONS: Parse comment blocks and remove the examples                        
        val.split(/<pre>.*<\/pre>/).each{|i|
            stripped = i.gsub(/\n/,"").gsub(/example:.*\.html/,"")                                        
            if stripped && stripped != ""  
                objBlock['explanations'].push(stripped) 
            end
        }                                                                
    end  
            
    # Return the object
    return objBlock  
end



# Generate a HTML structure
#
# @param    {Array}     categories      The categories

def create_html_output(categories)  
        
    dump = ""
    
    # Loop the categories 
    categories.each{ |category| 
        
        # wl-widget-item
        dump << "<div class=\"wl-widget-item\">\n"
        
            # Category title
            dump << "<h3>#{category['title']}</h3>\n"
            
            # Category content      
            if category['content']
            
                dump << "<div class=\"css-content\">\n"
                
                # Loop the category content items
                counter = 1
                category['content'].each{ |item|
                                    
                    # If item is not a selector
                    if item["type"] != "selector"
                        
                        # Create a foldername
                        foldername = "v1"
                        
                        # Create a filename for the example page
                        filename = category['title'] + counter.to_s
                        filename = filename.gsub(/\s/,"")
                        
                        # If the item has an explanation
                        if item["explanations"].length > 0
                            item["explanations"].each{ |explanation|
                                dump << "<p class=\"description\">#{explanation}</p>\n"
                            }                    
                        end
                        
                        # If the item has examples
                        if item["examples"].length > 0
                            dir = @dir_examples + foldername                                                      
                            dump << "<iframe seamless scrolling=\"no\" src=\"/#{dir + "/" + filename + ".html"}\"></iframe>\n"
                        end
                        
                        # If the item has snippets
                        if item["snippets"].length > 0
                            arrLines = []
                            dump << "<ul class=\"snippets\">\n"
                            item["snippets"].each{ |snippet|
                                arrLines.push(snippet)
                                dump << "<li>#{snippet.gsub(/</,'&lt;').gsub(/>/,'&gt;')}</li>\n"
                            }
                            dump << "</ul>\n"
                                                
                            directory = @dir_public + @dir_examples + foldername + "/"                                                                                               
                            prepare_example_file(directory, filename, arrLines)
                            
                            counter += 1
                        end
                                        
                    # If item is a selector
                    else
                        dump << "<pre class=\"selector\">#{item['value']}\n</pre>\n"               
                    end         
                }
                
                dump << "</div>\n"
            
            end          
           
        # close wl-widget-item        
        dump << "</div>\n"
    }   
    
    # Prepare the main HTML file         
    prepare_file(@dir_template_target, dump)
end



# Parse the CSS file
#
# @param    {String}    file            The CSS dump

def parse_css_file(file)
    
    # Create an array to store the categories => create item for each category
    titles = []  
    file.scan(@regex_cat_title){|title| titles.push(title)}
        
    # If categories is not empty
    if !titles.empty?

        # Create a new array to store the categories
        arrCategories = []
        
        # Create a new object for each title   
        i = 1            
        titles.each{|title| 
                   
            # Create a new object for each category
            objCategory = {}
            objCategory['title'] = replace_chars_in_string([/\*/, /\//, /\s$/, /\n\s*/], title).downcase
            objCategory['content'] = []  
                        
            # To get the content, split on a regex of the type 'title'
            # Returns a string with the description and selectors of the 'category'
            # Puts each string in a temporary array
            temp_categories = []
            file.split(@regex_cat_title).each{|category| 
                temp_categories.push(category)
            }
                                                                          
            # Split the content on empty lines
            arrParagraphs = []   
            temp_categories[i].split(/\n\n/).each{|paragraph|
                if paragraph.length > 1
                    # Differentiate comment blocks from selectors
                    paragraph.split('*/').each{|block|
                        # Create e new object for each item (comment or selector)
                        arrParagraphs.push(create_css_block(block))
                    }
                end
            }
            
            # Add all the paragrahps to the category object         
            objCategory['content'] = arrParagraphs                
                                                                                                     
            # Update counter
            i += 1  
                     
            # Add the object to the array
            arrCategories.push(objCategory)
        }
                    
        # Generate the HTML
        create_html_output(arrCategories)
        
    else
        puts "CSS file has no categories"
    end              
end



# Load the CSS file
#
# @param    {String}    url         The url to the css file

def load_css_file(url)   
    begin                                      
        res = open(url).read                 
        if res.length && res.class == String
            parse_css_file(res)      
        end  
    rescue 
        puts "Loading CSS file failed! Try again? (y/n): "
        answer = gets.chomp
        if answer == "y"
            init
        else
            puts "Exit"
            exit
        end
    end
end



# Initialize the script, asks for the path to the CSS file that needs to be parsed

def init
    print "Please enter the path to the CSS file: "
    name = gets.chomp
    if name == ""
        puts "Please enter a valid path!"    
        init
    else
        load_css_file(name)
    end
end

init
    