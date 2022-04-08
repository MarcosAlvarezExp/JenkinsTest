#!/usr/bin/env ruby
# git_submodule_helper.rb
# Some helper functions to work with submodules
PROJECT_ROOT = "../../"

# Update submodule reference and add the change to git
# Note that this function does not update the submodule or install the pods
# branch: The branch to execute the submodule update
# submodule_name: the submodule to check the reference
# enforce_branch: ensure that current branch and the requested one is the same
# def update_core_reference(branch, submodule_name)
	
# 	if branch == "" || submodule_name == ""
# 		puts "Error: Update core reference params are empty"
# 		return
# 	end
# 	if branch != "master" && !(branch.include? "release")
# 		puts "Error: current branch " + branch + " not allowed for automatic update"
# 		return
# 	end
# 	begin
# 		local_core_ref = get_local_core_reference(submodule_name)
# 		puts "Local core ref: " + local_core_ref
# 		remote_core_ref = get_last_remote_core_commit(branch, submodule_name)
# 		puts "Remote core ref: " + remote_core_ref
		
# 		if local_core_ref == "" || remote_core_ref == ""
# 			puts "Error: at least one ref is empty"
# 			return
# 		end

# 		if local_core_ref != remote_core_ref
# 			puts "New reference found for submodule " + submodule_name + " in branch " + branch
# 			pull_submodule_changes(branch, submodule_name)
# 			# set_new_submodule_reference(branch, submodule_name)
# 		end
# 	rescue
# 		puts "Exception: Unable to update the submodule reference"
# 	end
# end

private def get_local_core_reference(submodule_name)
	Dir.chdir(PROJECT_ROOT) do
		core_commit = %x{git ls-files -s #{submodule_name} | awk '{print $2}'}
		return core_commit
	end
end

private def get_last_remote_core_commit(branch, submodule_name)
	Dir.chdir(PROJECT_ROOT + submodule_name + "/") do
		`git fetch origin`
		core_commit = %x{git for-each-ref refs/remotes/origin | grep "origin/#{branch}" | awk '{print $1}'}
		return core_commit
	end
end

# private def set_new_submodule_references(branch, submodule_name)
# 	Dir.chdir(PROJECT_ROOT) do
# 		%x{git pull origin #{branch}}
# 		%x{git add #{submodule_name}}
# 	end
# end

# private def pull_submodule_changes(core_branch, submodule_name)
# 	Dir.chdir(PROJECT_ROOT + "#{submodule_name}") do
# 		%x{git checkout #{core_branch}}
# 		%x{git pull origin #{core_branch}}
# 	end
# end

# private def set_new_submodule_reference(branch, submodule_name)
# 	Dir.chdir(PROJECT_ROOT) do
# 		%x{git add #{submodule_name}}
# 		%x{git commit -m "Update Core submodule reference" #{submodule_name}}
# 		%x{git push origin #{branch}}
# 	end
# end

private def branch_containing(ref, submodule_name) 
	puts "Branches containing #{ref}"
	Dir.chdir(PROJECT_ROOT + "#{submodule_name}") do
		branches_containing_ref = %x{git branch -r --contains #{ref} }
		branches = branches_containing_ref.split(" ")
		# puts branches.grep(/v3$/)
		# regex = 'release'
		# r = Regexp.new regex
		# puts branches.grep(r)
		# puts branches

		puts branches.filter { |e| e.include?("release") }
		# branches.each do |branch|
		# 	puts "Branch"
  # 			puts branch
		# end

		# lista = [1, "Hola", 2]
		# puts lista.grep(String)

		# return branches_list.match(/release/)
		# return branches_list.map { |e|""  }
	end
end

private def branches_containing(ref, submodule_name)
	Dir.chdir(PROJECT_ROOT + "#{submodule_name}") do
		branches_containing_ref = %x{git branch -r --contains #{ref} }
		branches = branches_containing_ref.split(" ")
		return branches
	end
end

private def filter_release_branches(branches)
	releaseRegex = "release\/[0-9]{4}\/[0-9]*.[0-9]*"
	release_branches = branches.filter { |e| e.match(releaseRegex) }
	return release_branches
end

private def latest_release_branch_containing(ref, submodule_name)
	branches_containing_ref = branches_containing(ref, submodule_name)
	release_branches = filter_release_branches(branches_containing_ref)
	return release_branches.sort { |a, b| b <=> a }.first
end

# lista = ["origin/release/2022/v3", "origin/release/2022/v4"]
# primero = lista.sort { |a, b| b <=> a }.first
# puts primero


# update_core_reference("feature/hub-ci-improvements", "santander-one")
submodule_name = "santander-one"
ref= get_local_core_reference(submodule_name)
# puts branch_containing(ref, submodule_name)

# selected_branch = release_branches_containing(ref, submodule_name)
# puts selected_branch

selected_branch = latest_release_branch_containing(ref, submodule_name)
puts "Selected branch: #{selected_branch}"
echo "test"


# puts(get_last_remote_core_commit("release/0.4", "santander-one"))
# pull_submodule_changes("develop", "santander-one")
