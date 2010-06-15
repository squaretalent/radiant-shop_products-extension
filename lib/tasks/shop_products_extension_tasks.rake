namespace :radiant do
  namespace :extensions do
    namespace :shop_products do
      
      desc "Runs the migration of the Shop Products extension and its dependancies"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          ImagesExtension.migrator.migrate(ENV["VERSION"].to_i)
          ShopExtension.migrator.migrate(ENV["VERSION"].to_i)
          ShopProductsExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          ImagesExtension.migrator.migrate
          ShopExtension.migrator.migrate
          ShopProductsExtension.migrator.migrate
        end
      end
      
      desc "Copies public assets of the Shop Products to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        puts "Copying assets from ShopProductsExtension"
        Dir[ShopProductsExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(ShopProductsExtension.root, '')
          directory = File.dirname(path)
          mkdir_p RAILS_ROOT + directory, :verbose => false
          cp file, RAILS_ROOT + path, :verbose => false
        end
        unless ShopProductsExtension.root.starts_with? RAILS_ROOT # don't need to copy vendored tasks
          puts "Copying rake tasks from ShopProductsExtension"
          local_tasks_path = File.join(RAILS_ROOT, %w(lib tasks))
          mkdir_p local_tasks_path, :verbose => false
          Dir[File.join ShopProductsExtension.root, %w(lib tasks *.rake)].each do |file|
            cp file, local_tasks_path, :verbose => false
          end
        end
      end  
    end
  end
end
