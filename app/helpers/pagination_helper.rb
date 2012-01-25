module PaginationHelper
  class LinkRenderer < WillPaginate::ActionView::LinkRenderer

    private

      def link(text, target, attributes = {})
        if target.is_a? Fixnum
          attributes[:rel] = rel_value(target)
          attributes["data-page"] = target
          target = url(target)
        end
        attributes[:href] = target
        tag(:a, text, attributes)
      end

  end
end
