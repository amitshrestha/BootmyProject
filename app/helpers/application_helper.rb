module ApplicationHelper
  def table_for(objects, html_attributes=nil, &block)
    table = TableBuilder.new(self)
    block.call(table)
    table.render(objects, html_attributes)
  end

  def nice_time(time)
    time.strftime("%b %d %Y")
  end

  def fancybox_css
    stylesheet_link_tag("/fancybox/jquery.fancybox-1.3.1.css")
  end

  def fancybox_js
    [javascript_include_tag("/fancybox/jquery.fancybox-1.3.1.pack.js"),
    javascript_include_tag("/fancybox/jquery.easing-1.3.pack.js")].join("\n").html_safe
  end

  def fancybox_includes
    [fancybox_css, fancybox_js].join("\n").html_safe
  end

  def form_builder_js
    if Rails.env.production?
      javascript_include_tag "/steal/steal.production.js?form_builder,production"
    else
      javascript_include_tag "/steal/steal.js?form_builder,#{Rails.env}"
    end
  end

  # This helper ouputs everything needed to put the form builder in a page
  # DO NOT USE THIS MORE THAN ONCE ON A PAGE!
  def form_builder_form(*args, &blk)
    @job_type.form.custom? ? custom_form_builder_form(*args, &blk) : standard_form_builder_form(*args, &blk)
  end


  def standard_form_builder_form(url_for_options = {}, options = {}, &blk)
    # These are the options passed to the interface in javascript
    # You must at least set the @job_type variable in your controller

    # Using @job_type.data.input_jobs to differentiate content vs review jobs is a
    # little shady.  We'll need to come up with something better in the future.
    form_options = {
      :form_id => @job_type.form.access_hash,
      :jobtype => @job_type.data.input_jobs ? 'review' : 'content',
      :mode => (@preview || false) ? 'preview' : 'performable',
      :data => @view_data,
      :field_states => @field_states,
    }

    output = ActiveSupport::SafeBuffer.new
    output << form_tag(url_for_options, options.merge({:id => 'job-form'}), &blk)
    output << javascript_tag("var form_options = #{form_options.to_json}")
    output << form_builder_js

    output
  end

  def custom_form_builder_form(url_for_options = {}, options = {}, &blk)
    form = @job_type.form

    extra_content = capture(&blk) if blk
    form_options = html_options_for_form(url_for_options, options)

    if Rails.env == "test"
      html = Liquid::Template.parse(File.read(form.storage_path)).render(@view_data)
    else
      remote_html_file_name = form.storage_path + "?t=#{Time.now.strftime("%Y_%m_%d_%H_%M_%S")}"
      response = HTTParty.get(remote_html_file_name)
      if response.code == 200
        remote_html_file = response.body
        html  = Liquid::Template.parse(remote_html_file).render(@view_data)
      else
        html = "No File!"
      end
    end

    doc   = Nokogiri.HTML(html)
    doc.xpath("//form").each do |form_element|
      # add action so the form is submitted to the proper location
      form_options.each_pair do |attribute, value|
        form_element[attribute] = value
      end
      form_element["method"] = "POST"
      # add the authenticity token so the form submission is considered valid by the rails App
      form_element << doc.create_element("input", :type => "hidden", :name => "authenticity_token", :value => form_authenticity_token)
      form_element << extra_content.to_s
    end

    # if its a review job, add the js to change the form into review mode
    if @job_type.data.input_jobs
      # filter out the input fields from the view data
      if @assignment && @assignment.job
        review_hash = @view_data.except(*@assignment.job.data_sources.first.data.keys)
        review_hash_json = Util.flatten_keys({'output' => review_hash}).to_json
      else
        review_hash_json = Util.flatten_keys({'output' => @view_data['output']}).to_json
      end
      js = <<-js
        jQuery(document).ready(function() {
          FormMarking.initialize(#{review_hash_json});
        });
      js
      body = doc.xpath("//body").first
      body << stylesheet_link_tag("form_marking")
      body << javascript_tag(js)
      body << javascript_include_tag("form_marking")
    end
    raw doc.to_html
  end

  def mturk_group_preview_url(groupId)
    "https://www.mturk.com/mturk/preview?groupId=#{groupId}"
  end

  def my_time_ago_in_words(t)
    time_ago_in_words(t).gsub("about", "").gsub("almost", "")
  end

  def truncate(name, chars)
    if name && name.length > chars
      name[0..chars] + "..."
    else
      name
    end
  end

  # taken from http://railscasts.com/episodes/228-sortable-table-columns
  def sortable(column, title = nil)
    title ||= column.titleize
    direction = (column == params[:sort] && params[:direction] == 'asc') ? 'desc' : 'asc'
    link_to title, :sort => column, :direction => direction
  end

  def is_become_user?
    cookies['become_id'] && @original_developer && @original_developer.is_admin
  end


  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, {:sort => column, :direction => direction}, {:class => css_class}
  end

end
