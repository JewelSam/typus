module Admin::ResourcesHelper

  def admin_search(resource = @resource, params = params)
    if (typus_search = resource.typus_defaults_for(:search)) && typus_search.any?

      hidden_filters = params.dup
      rejections = %w(controller action locale utf8 sort_order order_by search page)
      hidden_filters.delete_if { |k, v| rejections.include?(k) }

      render "helpers/admin/resources/search", :hidden_filters => hidden_filters
    end
  end

  def build_sidebar
    app_name = @resource.typus_application
    resources = admin_user.application(app_name).map(&:constantize).delete_if { |k| k.typus_options_for(:hide_from_sidebar) }

    if resources.any?
      render "helpers/admin/resources/sidebar", :resources => resources
    else
      render "admin/dashboard/sidebar"
    end
  end

  def sidebar_add_new(klass)
    if admin_user.can?("create", klass)
      { :message => Typus::I18n.t("Add New"), :url => { :controller => "/admin/#{klass.to_resource}", :action => "new" } }
    end
  end

  def sidebar_list(klass)
    if admin_user.can?("read", klass)
      { :message => Typus::I18n.t("List"), :url => { :controller => "/admin/#{klass.to_resource}", :action => "index" } }
    end
  end

  # TODO: This method should be moved to `lib/typus/controller/actions.rb`
  def resource_actions
    @resource_actions ||= []
  end

  # TODO: This method should be moved to `lib/typus/controller/actions.rb`
  def resources_actions
    @resources_actions ||= []
  end

end
