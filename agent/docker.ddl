#{spaces}#!/bin/ruby
metadata    :name        => "Docker Access Agent",
            :description => "Agent to access the Docker API via MCollective",
            :author      => "Martin Uddén <martin.udden@gmail.com>",
            :license     => "Apache 2",
            :version     => "1.0",
            :url         => "https://github.com/CMartinUdden/mcollective-docker-agent",
            :timeout     => 60

action "commit", :description => "Create a new image from a container's changes" do
	display :always

	input	:container,
		:description	=> "Id",
		:prompt => "Id",
		:display_as	=> "Container ID",
		:type		=> :string,
		:validation	=> '^[a-fA-F0-9]+$',
		:optional	=> :false,
		:maxlength	=> 64

	input	:repo,
		:description	=> "Repository",
		:prompt => "Repo",
		:display_as	=> "Repo",
		:type		=> :string,
		:validation	=> '^([A-Za-z0-9_\.-]{1,1024}(:[0-9]{1,5})?/)?([A-Za-z0-9@_-]{1,64}/)?[A-Za-z0-9@_-]{1,64}$',
		:optional	=> :false,
		:maxlength	=> 1060

	input	:tag,
		:description	=> "Tag",
		:prompt => "Tag",
		:display_as	=> "Tag",
		:type		=> :string,
		:validation	=> '^[a-zA-Z0-9_@-]+$',
		:optional	=> :false,
		:maxlength	=> 64

	input	:comment,
		:description	=> "Commit message",
		:prompt => "Message",
		:display_as	=> "Message",
		:type		=> :string,
		:validation	=> '^.*$',
		:optional	=> :true,
		:maxlength	=> 1024

	input	:author,
		:description	=> "Author (e.g., \"John Hannibal Smith <hannibal@a-team.com>\")",
		:prompt => "Author",
		:display_as	=> "Author",
		:type		=> :string,
		:validation	=> '^.*$',
		:optional	=> :true,
		:maxlength	=> 1024

	output :id,
		:description	=> "Image id",
		:display_as   => "ID"
end

action "create", :description => "Create a new container" do
	display :always

	input	:image,
		:description	=> "From image",
		:prompt => "From",
		:display_as	=> "From",
		:type		=> :string,
		:validation	=> '^[-\.a-zA-Z0-9_:/]*$',
		:optional	=> :false,
		:maxlength	=> 1024

	input :name,
		:description	=> "Assign the specified name",
		:prompt => "Name",
		:display_as	=> "Name",
		:type		=> :string,
		:validation	=> '^[-\.a-zA-Z0-9_:@/]*$',
		:optional	=> :true,
		:maxlength	=> 64

	input	:config,
		:description	=> "Container configuration in JSON format",
		:prompt => "Configuration",
		:display_as	=> "Configuration",
		:type		=> :string,
		:validation	=> '^.*$',
		:optional	=> :false,
		:maxlength	=> 65536

	output :warnings,
		:description	=> "Warnings",
		:display_as   => "Warnings"

	output :id,
		:description => "ID of created container",
		:display_as => "ID"
end

action "diff", :description => "Inspect changes on a container's filesystem" do
	display :always

	input	:id,
		:description	=> "Id",
		:prompt => "Id",
		:display_as	=> "Container ID",
		:type		=> :string,
		:validation	=> '^[a-fA-F0-9]+$',
		:optional	=> :false,
		:maxlength	=> 64

	output :changes,
		:description	=> "Container changes as map",
		:display_as   => "Changes"
end

action "history", :description => "Show the history of an image" do
	input	:image,
		:description	=> "Name or image id",
		:prompt => "Name",
		:display_as	=> "Name",
		:type		=> :string,
		:validation	=> '^[-\.a-zA-Z0-9_:/]+$',
		:optional	=> :false,
		:maxlength	=> 1024

    output :history,
	  :description => "Output from API call, map of image history",
          :display_as  => "History"
end

action "images", :description => "List images" do
	input	:all,
		:description => "Get all images",
		:prompt => "All",
		:display_as	=> "All",
		:type		=> :boolean,
		:default	=> :false,
		:optional	=> :true

	input	:filter,
		:description	=> "Filters to apply",
		:prompt => "Filter",
		:display_as	=> "Filter",
		:type		=> :string,
		:optional	=> :true,
		:validation	=> '.*',
		:maxlength	=> 1024

    output :images,
	  :description => "Output from API call, map of images with detail data",
          :display_as  => "Images"
end

action "info", :description => "Display system-wide information" do
	output :info,
		:description => "Output from /info API call",
			:display_as => "Info"
end

action "inspect", :description => "Return low-level information on a container" do
	display :always

	input	:id,
		:description	=> "Id",
		:prompt => "Id",
		:display_as	=> "Container ID",
		:type		=> :string,
		:validation	=> '^[a-fA-F0-9]+$',
		:optional	=> :false,
		:maxlength	=> 64

	output :details,
		:description	=> "Container details as map",
		:display_as   => "Details"
end

action "inspecti", :description => "Return low-level information on an image" do
	input	:image,
		:description	=> "Name or image id",
		:prompt => "Name",
		:display_as	=> "Name",
		:type		=> :string,
		:validation	=> '^[-\.a-zA-Z0-9_:/]+$',
		:optional	=> :false,
		:maxlength	=> 1024

    output :details,
	  :description => "Output from API call, map of image details",
          :display_as  => "Details"
end

action "kill", :description => "Kill a running container using SIGKILL or a specified signal" do
	display :always

	input	:id,
		:description	=> "Id",
		:prompt => "Id",
		:display_as	=> "Container ID",
		:type		=> :string,
		:validation	=> '^[a-fA-F0-9]+$',
		:optional	=> :false,
		:maxlength	=> 12

	input	:signal,
		:description	=> "Signal to send to the container (e.g. SIGKILL)",
		:prompt => "Signal",
		:display_as	=> "Signal",
		:type		=> :string,
		:validation	=> '^SIG[A-F]+$',
		:optional	=> :false,
		:maxlength	=> 12

	output :exitcode,
		:description	=> "return code of action",
		:display_as   => "exitcode"
end

action "pause", :description => "Pause all processes within a container" do
	display :always

	input	:id,
		:description	=> "Id",
		:prompt => "Id",
		:display_as	=> "Container ID",
		:type		=> :string,
		:validation	=> '^[a-fA-F0-9]+$',
		:optional	=> :false,
		:maxlength	=> 64

	output :exitcode,
		:description	=> "return code of action",
		:display_as   => "exitcode"
end

action "ps", :description => "List containers" do

	input	:all,
		:description 	=> "Show all containers, not only running ones",
		:prompt => "Show all containers, not only running ones",
		:optional => :true,
		:type => :boolean,
		:display_as	=> "Show All"

	input	:limit,
		:description	=> "Limit result set",
		:prompt => "Limit result set",
		:display_as	=> "Limit results",
		:optional => :true,
		:type		=> :integer

	input	:sinceId,
		:description	=> "Show only containers created since containers with Id",
		:prompt => "Show only containers created since containers with Id",
		:display_as	=> "Since ID",
		:type		=> :string,
		:validation	=> '^[a-fA-F0-9]*$',
		:optional	=> :true,
		:maxlength	=> 64

	input	:beforeId,
		:description	=> "Show only containers created before containers with Id",
		:prompt => "Show only containers created before containers with Id",
		:display_as	=> "Before ID",
		:type		=> :string,
		:validation	=> '^[a-fA-F0-9]*$',
		:optional	=> :true,
		:maxlength	=> 64

	input	:size,
		:description 	=> "Show sizes",
		:prompt => "Show the containers sizes",
		:optional => :true,
		:type => :boolean,
		:display_as	=> "Show Size"

    output :containers,
	  :description => "Output from API call, map of containers with detail data",
          :display_as  => "Containers"
end

action "pull", :description => "Pull an image or a repository from the registry" do
	display :always

	input	:image,
		:description	=> "From image",
		:prompt => "From",
		:display_as	=> "From",
		:type		=> :string,
		:validation	=> '^[-\.a-zA-Z0-9_:/]+$',
		:optional	=> :false,
		:maxlength	=> 1024

	input	:tag,
		:description	=> "Tag",
		:prompt => "Tag",
		:display_as	=> "Tag",
		:type		=> :string,
		:validation	=> '^[-\.a-zA-Z0-9_]*$',
		:optional	=> :true,
		:maxlength	=> 64

	output :exitcode,
		:description	=> "return code of action",
		:display_as   => "exitcode"
end

action "push", :description => "Push an image or a repository to the registry" do
	display :always

	input	:image,
		:description	=> "Name or image id",
		:prompt => "From",
		:display_as	=> "From",
		:type		=> :string,
		:validation	=> '^[-\.a-zA-Z0-9_:/]+$',
		:optional	=> :false,
		:maxlength	=> 1024

	input	:tag,
		:description	=> "Tag",
		:prompt => "Tag",
		:display_as	=> "Tag",
		:type		=> :string,
		:validation	=> '^[-\.a-zA-Z0-9_]*$',
		:optional	=> :true,
		:maxlength	=> 64

	output :result,
		:description	=> "Result of action",
		:display_as   => "Result"
end

action "restart", :description => "Restart a running container" do
	display :always

	input	:id,
		:description	=> "Id",
		:prompt => "Id",
		:display_as	=> "Container ID",
		:type		=> :string,
		:validation	=> '^[a-fA-F0-9]+$',
		:optional	=> :false,
		:maxlength	=> 64

	input	:timeout,
		:description => "Time to wait before killing the container",
		:prompt => "Timeout",
		:display_as	=> "Timeout",
		:type		=> :integer,
		:optional	=> :true

	output :exitcode,
		:description	=> "return code of action",
		:display_as   => "exitcode"
end

action "rm", :description => "Remove a container" do
	display :always

	input	:id,
		:description	=> "Id",
		:prompt => "Id",
		:display_as	=> "Container ID",
		:type		=> :string,
		:validation	=> '^[a-fA-F0-9]+$',
		:optional	=> :false,
		:maxlength	=> 64

	input	:rmvolumes,
		:description => "Remove the associated volumes",
		:prompt => "Remove volumes",
		:display_as	=> "Remove volumes",
		:type		=> :boolean,
		:default	=> :false,
		:optional	=> :true

	input	:force,
		:description => "Force removal",
		:prompt => "Force",
		:display_as	=> "Force",
		:type		=> :boolean,
		:default	=> :false,
		:optional	=> :true

	output :exitcode,
		:description	=> "return code of action",
		:display_as   => "exitcode"
end

action "rmi", :description => "Remove an image" do
	display :always

	input	:image,
		:description	=> "Name or image id",
		:prompt => "Name",
		:display_as	=> "Name",
		:type		=> :string,
		:validation	=> '^[-\.a-zA-Z0-9_:/]+$',
		:optional	=> :false,
		:maxlength	=> 1024

	input	:noprune,
		:description => "No prune",
		:prompt => "No prune",
		:display_as	=> "No prune",
		:type		=> :boolean,
		:default	=> :false,
		:optional	=> :true

	input	:force,
		:description => "Force removal",
		:prompt => "Force",
		:display_as	=> "Force",
		:type		=> :boolean,
		:default	=> :false,
		:optional	=> :true

	output :images,
		:description	=> "Images",
		:display_as   => "Images"
end

action "start", :description => "Restart a stopped container" do
	display :always

	input	:id,
		:description	=> "Id",
		:prompt => "Id",
		:display_as	=> "Container ID",
		:type		=> :string,
		:validation	=> '^[a-fA-F0-9]+$',
		:optional	=> :false,
		:maxlength	=> 64

	output :exitcode,
		:description	=> "Exitcode",
		:display_as   => "Exitcode"
end

action "stop", :description => "Stop a running container by sending SIGTERM and then SIGKILL after a grace period" do
	display :always

	input	:id,
		:description	=> "Id",
		:prompt => "Id",
		:display_as	=> "Container ID",
		:type		=> :string,
		:validation	=> '^[a-fA-F0-9]+$',
		:optional	=> :false,
		:maxlength	=> 64

	input	:timeout,
		:description => "Time to wait before killing the container",
		:prompt => "Timeout",
		:display_as	=> "Timeout",
		:type		=> :integer,
		:optional	=> :true

	output :exitcode,
		:description	=> "return code of action",
		:display_as   => "exitcode"
end

action "tag", :description => "Tag an image into a repository" do
	display :always

	input	:image,
		:description	=> "Name or image id",
		:prompt => "Name",
		:display_as	=> "Name",
		:type		=> :string,
		:validation	=> '^[-\.a-zA-Z0-9_:/]+$',
		:optional	=> :false,
		:maxlength	=> 1024

	input	:repo,
		:description	=> "Repository",
		:prompt => "Repo",
		:display_as	=> "Repo",
		:type		=> :string,
		:validation	=> '^[-\.a-zA-Z0-9_:/]+$',
		:optional	=> :false,
		:maxlength	=> 1024

	input	:tag,
		:description	=> "Tag",
		:prompt => "Tag",
		:display_as	=> "Tag",
		:type		=> :string,
		:validation	=> '^[-\.a-zA-Z0-9_]+$',
		:optional	=> :true,
		:maxlength	=> 64

	input	:force,
		:description => "Force",
		:prompt => "Force",
		:display_as	=> "Force",
		:type		=> :boolean,
		:default	=> :false,
		:optional	=> :true

	output :exitcode,
		:description	=> "return code of action",
		:display_as   => "exitcode"
end

action "top", :description => "Display the running processes of a container" do
	display :always

	input	:id,
		:description	=> "Id",
		:prompt => "Id",
		:display_as	=> "Container ID",
		:type		=> :string,
		:validation	=> '^[a-fA-F0-9]+$',
		:optional	=> :false,
		:maxlength	=> 64

	input	:psargs,
		:description	=> "Argument to pass to ps",
		:prompt => "psargs",
		:display_as	=> "psarguments",
		:type		=> :string,
		:validation	=> '^[-\.a-zA-Z0-9]*$',
		:optional	=> :true,
		:maxlength	=> 64

	output :processes,
		:description	=> "Processes",
		:display_as   => "Processes"
end

action "unpause", :description => "Unpause all processes within a container" do
	display :always

	input	:id,
		:description	=> "Id",
		:prompt => "Id",
		:display_as	=> "Container ID",
		:type		=> :string,
		:validation	=> '^[a-fA-F0-9]+$',
		:optional	=> :false,
		:maxlength	=> 64

	output :exitcode,
		:description	=> "return code of action",
		:display_as   => "exitcode"
end
