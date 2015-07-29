if defined?(ChefSpec)
  def install_ghostdriver(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:ghostdriver, :install, resource_name)
  end
end
