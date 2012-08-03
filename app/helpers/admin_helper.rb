# encoding: utf-8

module AdminHelper
    def save_item (model, properties, success_redirect, fail_render, config)
        obj = model.to_s.downcase
        if params[:add_new] ==  "true"
            @item = model.new(params[obj])
            pass = @item.save
        else
            @item = model.find(params[:id])
            pass = @item.update_attributes(params[obj])
        end

        if pass
            redirect_to success_redirect
        else
             # Pass back objects for displaying table if process failed.
            @results = model.find(:all, :order => "title")
            @config = config
            @items_used = get_used_items(model)
            render :action => fail_render
        end
    end

    def get_language_config
        @config = {
          :table_headings => ["Language", "Code", "Region"],
          :db_properties => ["title", "code", "region"],
          :urls => {
            :base => "/admin/options",
            :edit => "/admin/languages/edit/",
            :remove => "/admin/languages/remove/",
            :save => "/admin/languages/save/"
          }
        }
        @config
    end

    def get_category_config
        @config = {
          :table_headings => ["Category", "URL"],
          :db_properties => ["title", "url_title"],
          :urls => {
            :base => "/admin/categories/",
            :edit => "/admin/categories/edit/",
            :remove => "/admin/categories/remove/",
            :save => "/admin/categories/save/"
          }
        }
        @config
    end

    def get_used_items(model)
        obj = model.to_s.downcase
        case obj
        when "language"
            @items_used = LanguagesVersion.where("language_id = version_id").collect {|item| item.language_id}
        when "category"
            @items_used = CategoriesVersion.where("category_id = version_id").collect {|item| item.category_id}
        end
        @items_used
    end
end