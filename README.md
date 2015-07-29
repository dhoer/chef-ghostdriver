# GhostDriver Cookbook

[![Cookbook Version](http://img.shields.io/cookbook/v/ghostdriver.svg?style=flat-square)][supermarket]
[![Build Status](http://img.shields.io/travis/dhoer/chef-ghostdriver.svg?style=flat-square)][travis]
[![GitHub Issues](http://img.shields.io/github/issues/dhoer/chef-ghostdriver.svg?style=flat-square)][github]

[supermarket]: https://supermarket.chef.io/cookbooks/ghostdriver
[travis]: https://travis-ci.org/dhoer/chef-ghostdriver
[github]: https://github.com/dhoer/chef-ghostdriver/issues

This cookbook installs and configures PhantomJS GhostDriver (https://github.com/detro/ghostdriver) as a 
standalone server or selenium-grid node.

## Requirements

- Chef 11.6.0 (includes a built-in registry_key resource) or higher

### Platforms

- CentOS, RedHat
- Ubuntu
- Windows

### Cookbook Dependencies

- phantomjs

These cookbooks are referenced with suggests, so be sure to depend on cookbooks that apply:

- windows
- nssm - Required for Windows services only 

## Examples

See [ghostdriver_test](https://github.com/dhoer/chef-ghostdriver/tree/master/test/fixtures/cookbooks/ghostdriver_test)
cookbook for working examples. 

### Install ghostdriver as a standalone server

```ruby
ghostdriver 'ghostdriver_standalone' do
  action :install
end
```

### Install ghostdriver as a selenium-grid node

```ruby
ghostdriver 'ghostdriver_seleniumnode' do
  webdriverSeleniumGridHub "http://#{node['ipaddress']}:4444/grid/register/"
  action :install
end
```

## Attributes

- `servicename` - Service name.  Defaults to the name of the resource block. 
- `webdriver` - Webdriver ip:port.  Defaults to `#{node['ipaddress']}:8910`.
- `webdriverSeleniumGridHub` -  URL of selenium hub. Defaults to `nil`.

## ChefSpec Matchers

This cookbook includes custom [ChefSpec](https://github.com/sethvargo/chefspec) matchers you can use to test 
your own cookbooks.

Example Matcher Usage

```ruby
expect(chef_run).to install_ghostdriver('ghostdriver_seleniumnode').with(
  webdriverSeleniumGridHub: "http://#{node['ipaddress']}:4444/grid/register/"
)
```
      
Cookbook Matchers

- install_ghostdriver(resource_name)

## Getting Help

- Ask specific questions on [Stack Overflow](http://stackoverflow.com/questions/tagged/chef-ghostdriver).
- Report bugs and discuss potential features in [Github issues](https://github.com/dhoer/chef-ghostdriver/issues).

## Contributing

Please refer to [CONTRIBUTING](https://github.com/dhoer/chef-ghostdriver/blob/master/CONTRIBUTING.md).

## License

MIT - see the accompanying [LICENSE](https://github.com/dhoer/chef-ghostdriver/blob/master/LICENSE.md) file for details.
