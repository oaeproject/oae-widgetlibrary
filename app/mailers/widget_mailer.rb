class WidgetMailer < ActionMailer::Base
  default :from => "Sakai Widget Library <no-reply@sakaifoundation.org>",
          :host => ActionMailer::Base.default_url_options[:host]

  def new_submission(version, widget)
    @widget = widget
    @version = version
    to = User.where(:reviewer => true).map{|u| "#{u.name} <#{u.email}>"}
    mail(:to => to, 
         :subject => "[Widget Library] Widget submitted for review",
         :template_path => "mailers",
         :template_name => "new_submission")
  end

  def reviewed(version, widget)
    @version = version
    @widget = widget
    to = "#{@widget.user.name} <#{@widget.user.email}>"
    if @version.state_id.eql? State.accepted
      mail(:to => to, 
           :subject => "[Widget Library] Your widget has been approved!",
           :template_path => "mailers",
           :template_name => "submission_accepted")
    else
      mail(:to => to, 
           :subject => "[Widget Library] Your widget has been declined",
           :template_path => "mailers",
           :template_name => "submission_rejected")
    end
  end

end
