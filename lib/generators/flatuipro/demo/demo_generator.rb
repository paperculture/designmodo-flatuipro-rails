require 'rails/generators'
require 'pathname'

module Flatuipro
  module Generators
    class DemoGenerator < Rails::Generators::Base
      desc "Setup Flat UI Pro Demo page."
      source_root "vendor/assets/demo"

      # Detect if Flat UI Pro assets copied over to gem
      def check_flatuipro_install
        unless File.exist?("vendor/assets/demo/index.html")
          raise "Please run install generator first"
        end
      end

      def generate_demo_controller
        generate "controller flatuipro_demo index --no-helper --no-test-framework --no-assets"
      end

      def add_demo_assets
        # Overwrite generated index.html.erb with demo html
        copy_file "index.html.erb", "app/views/flatuipro_demo/index.html.erb"

        # Add demo LESS
        copy_file "flatuipro-demo.less", "vendor/assets/stylesheets/flatuipro-demo.less"
        
        # Handle CSS Manifest
        css_manifest = "app/assets/stylesheets/application.css"
        if File.exist?(css_manifest)
          content = File.read(css_manifest)
          unless content.match(/require_tree\s+\./)
            style_require_block = " *= require flatuipro-demo\n"
            insert_into_file css_manifest, style_require_block, :after => "require_self\n"
          end
        end

        # Add demo javascript
        copy_file "flatuipro-demo.js", "app/assets/javascripts/flatuipro-demo.js"

        # Handle JS Manifest
        js_manifest = "app/assets/javascripts/flatui-application.js"
        if File.exist?(js_manifest)
          content = File.read(js_manifest)
          unless content.match(/require_tree\s+\./)
            insert_into_file js_manifest, "//= require flatuipro-demo\n", :after => "flatuipro\n"
          end
        end
      end
    end
  end
end