# Credit to http://robonrails.tumblr.com/post/198322698/validating-images-with-paperclip for this handy module

module ValidatesAsImage

  def self.included receiver
    receiver.extend ClassMethods
  end

  module ClassMethods
    def validates_as_image fields

      validates_each fields do |record, attr, value|
        if !value.queued_for_write.empty? and value.to_file
          `identify "#{value.to_file.path}"`
          record.errors.add attr, 'is not a valid image' unless $? == 0
        end
      end
         
    end
  end
  
end
