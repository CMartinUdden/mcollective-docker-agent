metadata    :name        => "Docker Access Agent",
            :description => "Agent to access the Docker API via MCollective",
            :author      => "Andreas Schmidt [@aschmidt75]",
            :license     => "Apache 2",
            :version     => "1.0",
            :url         => "http://github.com...",
            :timeout     => 60


action "info", :description => "Retrieve information about the docker system" do
	output :info,
		:description => "Output from /info API call",
			:display_as => "Info"
end

action "commit", :description => "Commit a container" do
	display :always

	input	:container,
		:description	=> "Container",
		:prompt => "Container",
		:display_as	=> "Container reference",
		:type		=> :string,
		:validation	=> '^[-\.a-zA-Z0-9_]+$',
		:optional	=> :false,
		:maxlength	=> 256

	input	:repo,
		:description	=> "Repository",
		:prompt => "Repo",
		:display_as	=> "Repo",
		:type		=> :string,
		:validation	=> '^[-\.a-zA-Z0-9_]*$',
		:optional	=> :true,
		:maxlength	=> 1024

	input	:tag,
		:description	=> "Tag",
		:prompt => "Tag",
		:display_as	=> "Tag",
		:type		=> :string,
		:validation	=> '^[-\.a-zA-Z0-9_]*$',
		:optional	=> :true,
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
		:description	=> "Commit author",
		:prompt => "Author",
		:display_as	=> "Author",
		:type		=> :string,
		:validation	=> '^.*$',
		:optional	=> :true,
		:maxlength	=> 1024

	input	:config,
		:description	=> "Container configuration in JSON format",
		:prompt => "Configuration",
		:display_as	=> "Configuration",
		:type		=> :string,
		:validation	=> '^.*$',
		:optional	=> :false,
		:maxlength	=> 65536

	output :id,
		:description	=> "Image id",
		:display_as   => "ID"
end
action "containers", :description => "Retrieve information about running containers" do

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

action "createcontainer", :description => "Create an container" do
	display :always

	input	:name,
		:description	=> "From image",
		:prompt => "From",
		:display_as	=> "From",
		:type		=> :string,
		:validation	=> '^[-\.a-zA-Z0-9_]*$',
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

action "inspectcontainer", :description => "Inspect container details" do
	display :always

	input	:id,
		:description	=> "Id",
		:prompt => "Id",
		:display_as	=> "Container ID",
		:type		=> :string,
		:validation	=> '^[a-fA-F0-9]*$',
		:optional	=> :false,
		:maxlength	=> 64

	output :details,
		:description	=> "Container details as map",
		:display_as   => "Details"
end

action "top", :description => "Get processes running on container" do
	display :always

	input	:id,
		:description	=> "Id",
		:prompt => "Id",
		:display_as	=> "Container ID",
		:type		=> :string,
		:validation	=> '^[a-fA-F0-9]*$',
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

action "changes", :description => "Show container changes" do
	display :always

	input	:id,
		:description	=> "Id",
		:prompt => "Id",
		:display_as	=> "Container ID",
		:type		=> :string,
		:validation	=> '^[a-fA-F0-9]*$',
		:optional	=> :false,
		:maxlength	=> 64

	output :changes,
		:description	=> "Container changes as map",
		:display_as   => "Changes"
end

action "start", :description => "Start a container" do
	display :always

	input	:id,
		:description	=> "Id",
		:prompt => "Id",
		:display_as	=> "Container ID",
		:type		=> :string,
		:validation	=> '^[a-fA-F0-9]*$',
		:optional	=> :false,
		:maxlength	=> 64

	input	:hostconfig,
		:description	=> "Host specific container configuration in JSON format",
		:prompt => "Host Configuration",
		:display_as	=> "Host Configuration",
		:type		=> :string,
		:validation	=> '^.*$',
		:optional	=> :false,
		:maxlength	=> 65536

	output :exitcode,
		:description	=> "return code of action",
		:display_as   => "exitcode"
end

action "stop", :description => "Stop a running container" do
	display :always

	input	:id,
		:description	=> "Id",
		:prompt => "Id",
		:display_as	=> "Container ID",
		:type		=> :string,
		:validation	=> '^[a-fA-F0-9]*$',
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

action "restart", :description => "Restart a running container" do
	display :always

	input	:id,
		:description	=> "Id",
		:prompt => "Id",
		:display_as	=> "Container ID",
		:type		=> :string,
		:validation	=> '^[a-fA-F0-9]*$',
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

action "kill", :description => "Kill a running container" do
	display :always

	input	:id,
		:description	=> "Id",
		:prompt => "Id",
		:display_as	=> "Container ID",
		:type		=> :string,
		:validation	=> '^[a-fA-F0-9]*$',
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

action "pause", :description => "Pause a container" do
	display :always

	input	:id,
		:description	=> "Id",
		:prompt => "Id",
		:display_as	=> "Container ID",
		:type		=> :string,
		:validation	=> '^[a-fA-F0-9]*$',
		:optional	=> :false,
		:maxlength	=> 64

	output :exitcode,
		:description	=> "return code of action",
		:display_as   => "exitcode"
end

action "unpause", :description => "Un-pause a container" do
	display :always

	input	:id,
		:description	=> "Id",
		:prompt => "Id",
		:display_as	=> "Container ID",
		:type		=> :string,
		:validation	=> '^[a-fA-F0-9]*$',
		:optional	=> :false,
		:maxlength	=> 64

	output :exitcode,
		:description	=> "return code of action",
		:display_as   => "exitcode"
end

action "deletecontainer", :description => "Delete a container" do
	display :always

	input	:id,
		:description	=> "Id",
		:prompt => "Id",
		:display_as	=> "Container ID",
		:type		=> :string,
		:validation	=> '^[a-fA-F0-9]*$',
		:optional	=> :false,
		:maxlength	=> 64

	input	:rmvolumes,
		:description => "Remove the accociated volumes",
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

action "images", :description => "Retrieve information about all images on a host" do
	input	:all,
		:description => "Get all images",
		:prompt => "All",
		:display_as	=> "All",
		:type		=> :boolean,
		:default	=> :false,
		:optional	=> :true

	input	:filters,
		:description	=> "Filters to apply",
		:prompt => "Filters",
		:display_as	=> "Filters",
		:type		=> :string,
		:optional	=> :true,
		:validation	=> '.*',
		:maxlength	=> 1024

    output :images,
	  :description => "Output from API call, map of images with detail data",
          :display_as  => "Images"
end

action "createimage", :description => "Create an image" do
	display :always

	input	:fromimage,
		:description	=> "From image",
		:prompt => "From",
		:display_as	=> "From",
		:type		=> :string,
		:validation	=> '^[-:\.a-zA-Z0-9_/]+$',
		:optional	=> :false,
		:maxlength	=> 64

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

action "inspectimage", :description => "Retrieve information about an image" do
	input	:name,
		:description	=> "Name or image id",
		:prompt => "Name",
		:display_as	=> "Name",
		:type		=> :string,
		:optional	=> :true,
		:validation	=> '^/?[-\.a-zA-Z0-9_]*$',
		:maxlength	=> 64

    output :details,
	  :description => "Output from API call, map of image details",
          :display_as  => "Details"
end

action "history", :description => "Retrieve history of an image" do
	input	:name,
		:description	=> "Name or image id",
		:prompt => "Name",
		:display_as	=> "Name",
		:type		=> :string,
		:optional	=> :true,
		:validation	=> '^/?[-\.a-zA-Z0-9_]*$',
		:maxlength	=> 64

    output :history,
	  :description => "Output from API call, map of image history",
          :display_as  => "History"
end

action "push", :description => "Push an image to the registry" do
	display :always

	input	:name,
		:description	=> "Image Name or id",
		:prompt => "From",
		:display_as	=> "From",
		:type		=> :string,
		:validation	=> '^/?[-\.a-zA-Z0-9_/]+$',
		:optional	=> :false,
		:maxlength	=> 64

	input	:tag,
		:description	=> "Tag",
		:prompt => "Tag",
		:display_as	=> "Tag",
		:type		=> :string,
		:validation	=> '^[-\.a-zA-Z0-9_]*$',
		:optional	=> :true,
		:maxlength	=> 64

	input	:registry,
		:description	=> "Registry",
		:prompt => "Registry",
		:display_as	=> "Registry",
		:type		=> :string,
		:validation	=> '^[-\.a-zA-Z0-9_\.:/]*$',
		:optional	=> :true,
		:maxlength	=> 64

	output :exitcode,
		:description	=> "return code of action",
		:display_as   => "exitcode"
end


action "tag", :description => "Tag an image" do
	display :always

	input	:name,
		:description	=> "Name or image id",
		:prompt => "Name",
		:display_as	=> "Name",
		:type		=> :string,
		:optional	=> :true,
		:validation	=> '^/?[-\.a-zA-Z0-9_]*$',
		:maxlength	=> 64

	input	:repo,
		:description	=> "Repository",
		:prompt => "Repo",
		:display_as	=> "Repo",
		:type		=> :string,
		:validation	=> '^[-\.a-zA-Z0-9_]*$',
		:optional	=> :true,
		:maxlength	=> 64

	input	:tag,
		:description	=> "Tag",
		:prompt => "Tag",
		:display_as	=> "Tag",
		:type		=> :string,
		:validation	=> '^[-\.a-zA-Z0-9_]+$',
		:optional	=> :false,
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

action "deleteimage", :description => "Delete a image" do
	display :always

	input	:name,
		:description	=> "Name or image id",
		:prompt => "Name",
		:display_as	=> "Name",
		:type		=> :string,
		:optional	=> :true,
		:validation	=> '^/?[-\.a-zA-Z0-9_]*$',
		:maxlength	=> 64

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

	output :exitcode,
		:description	=> "return code of action",
		:display_as   => "exitcode"
end
