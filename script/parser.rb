#!/usr/bin/env ruby
require 'net/http'
require 'open-uri'

# Examples for testing
# http://tenant1.oae.com/shared/oae/css/oae.components.css
# public/examples/style-guide/assets/css/style.css

# Properties
@regex_cat_title = /\/\*{3,}\s*.*\s*\*+\//



# Remove all the characters from a string (to create a clean title)
#
# @param    {Array}  chars              The characters that need to be replaced
# @param    {String} string             The given string that needs to be cleaned up
# @return   {String} string             The cleaned up string

def replace_chars_in_string(chars, string)
    chars.each {|char| string.gsub!(char, "")}
    return string
end



# Save the file
#
# @param    {String}    filename        The name of the HTML file
# @param    {String}    dump            The HTML dump

def save_file(filename, dump)
    aFile = File.new(filename + ".html", "w")
    aFile.write(dump)
    aFile.close    
end



# Write the HTML to a file
#
# @param    {String}    dump            The HTML dump

def prepare_file(dump)
    print "Please enter the name for the HTML file: "
    filename = gets.chomp
    if filename != ""
        begin
            save_file(filename, dump)
        rescue
            print "Saving the HTML file failed. Try again? (y/n)"
            answer = gets.chomp
            if answer == "y"
                save_file(filename, dump)
            elsif answer == "n"
                exit            
            else
                print "Invalid answer"
            end
        end 
    else
        prepare_file(dump)
    end
end



# Generate a HTML structure
#
# @param    {Array}     categories      The categories

def create_html_output(categories)   
    
    puts "CREATE HTML OUTPUT"
           
    #dump = "<h1>Categories</h1>\n" 
    #categories.each{ |category| 
    #    dump << "<div class=\"wl-widget-item\">\n"
    #    dump << "<p>#{category['title']}</p>\n"             
    #    category['content'].each{ |item|
    #        dump << "<span>#{item}</span>\n"
    #    }            
    #    dump << "</div>\n"
    #}   
    #prepare_file(dump)
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
                               
        # EXAMPLES: Get all the examples out of the string and remove 'example: '
        val.scan(/example.*\.html/).collect{|example| 
            example = example.gsub(/example:\s/,"")
            objBlock['examples'].push(example)
        }  
                               
        # SNIPPETS: Get all the html snippets out of the string               
        val.scan(/<pre>.*<\/pre>/).collect{|item|
            snippet = item.gsub(/<pre>/,"").gsub(/<\/pre>/,"")
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



# Parse the CSS file
#
# @param    {String}    file                The CSS dump

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
        "Parsing css file failed"
    end
end



# Init

def init
    print "Please enter the path to the CSS file: "
    #name = gets.chomp
    name = "http://tenant1.oae.com/shared/oae/css/oae.components.css"
    if name == ""
        puts "Please enter a valid path!"    
        init
    else
        load_css_file(name)
    end
end

init
