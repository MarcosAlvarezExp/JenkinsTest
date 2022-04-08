#!/usr/bin/env ruby
PROJECT_ROOT = "../../"

private def update_submodule(country_branch, core_branch, submodule_name)
    Dir.chdir(PROJECT_ROOT + "#{submodule_name}") do
        %x{git fetch origin }
        %x{git checkout #{core_branch} }
        # %x{git pull origin #{core_branch} }
    end

    Dir.chdir(PROJECT_ROOT) do
        # %x{git commit -m "Updated reference to Core" #{submodule_name}}
        # %x{git push origin #{country_branch} }
        dirname = Dir.pwd
        # files = Dir[dirname]
        puts "I would push here: #{dirname}"
    end
end

country_branch = ARGV[0]
core_branch = ARGV[1]
submodule_name = ARGV[2]

# update_submodule("release/0.4", "release/2022/v3", "santander-one")
#update_submodule(country_branch, core_branch, submodule_name)
puts country_branch
puts core_branch
puts submodule_name
