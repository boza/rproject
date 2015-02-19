require 'yaml'

module Configurable

  mattr_accessor :app_constants

  def config!
    yield(self) if block_given?
    load_constants!
    app_constants.each { |const| send(const) }
  end

  def env
    ENV['RACK_ENV']
  end

  def app_constants
    @@app_constants ||= []
  end

  def config_dir
    @config_dir ||= File.expand_path("#{__dir__}/../config", __FILE__)
  end

  def config_dir=(dir) 
    @config_dir = dir
  end

  private


  def constant_file?
    File.exists?("#{config_dir}/constants.yml")
  end

  def load_constants_file
    constants_file = File.read("#{config_dir}/constants.yml")
    processed_erb = ERB.new(constants_file).result
    YAML.load(processed_erb).fetch(env, {})
  end

  def load_constants!
    raise('No Constant file located at %s' % config_dir) unless constant_file?
    build_constant_methods(load_constants_file)
  end

  def build_constant_methods(constant_values)
    constant_values.each do |constant, value|
      const_symbol = constant.to_sym
      app_constants << const_symbol
      define_method(const_symbol) { instance_variable_get("@#{constant}") || instance_variable_set("@#{constant}", value) }
      module_function const_symbol
    end
  end

end