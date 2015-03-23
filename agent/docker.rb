require 'excon'
require 'json'
require 'socket'

module MCollective
  module Agent
    class Docker<RPC::Agent

      action "commit" do
        logger.debug "docker/commit" 
        options = {}
        [:container, :repo, :tag, :comment, :author].each {|o|
          options[o] = request[o] if request.include?(o)
        }

        begin
          info = JSON.parse(_request(:post, "commit?", options, request[:config]))
          reply[:id] = info["Id"]
        rescue => e
          reply.fail! "Error querying docker api (POST containers/commit), #{e}"
          logger.error e
        end
        logger.debug "docker/commit done."
      end
      action "create" do
        logger.debug "docker/create" 
        options = {}
        options[:name] = request[:name] if request[:name]

        begin
          _validateconfig(request[:config])
          info = JSON.parse(_request(:post, "containers/create?", options, request[:config]))
          logger.debug "docker/create #{info}"

          reply[:warnings] = info["Warnings"] if info["Warnings"]
          reply[:id] = info["Id"] if info["Id"]
        rescue => e
          reply.fail! "Error querying docker api (POST containers/create), #{e}"
          logger.error e
        end
        logger.debug "docker/create done."
      end
      action "diff" do
        logger.debug "docker/diff"

        begin
          reply[:processes] = _request(:get, "containers/#{request[:id]}/changes")
        rescue => e
          reply.fail! "Error querying docker api (GET containers/#{request[:id]}/changes), #{e}"
          logger.error e
        end
        logger.debug "docker/diff done."
      end
      action "history" do
        logger.debug "docker/history"

        begin
          reply[:history] = _request(:get, "images/#{request[:image]}/history")
        rescue => e
          reply.fail! "Error querying docker api (GET images/#{request[:image]}/history), #{e}"
          logger.error e
        end
        logger.debug "docker/history done."
      end
      action "images" do
        logger.debug "docker/images"

        options = {}
        [:all, :filters].each {|o|
          options[o] = request[o] if request.include?(o)
        }
        logger.debug "docker/images options=#{options}"
        begin
          reply[:images] = _request(:get, 'images/json?', options)
        rescue => e
          reply.fail! "Error querying docker api (GET images/json), #{e}"
          logger.error e
        end
        logger.debug "docker/images done."
      end
      action "info" do
        logger.debug "docker/info"

        begin
          reply[:info] = _request(:get, 'info')
        rescue => e
          reply.fail! "Error querying docker api (GET /info), #{e}"
          logger.error e
        end
        logger.debug "docker/info done."
      end
      action "inspect" do
        logger.debug "docker/inspect"

        begin
          reply[:details] = _request(:get, "containers/#{request[:id]}/json")
        rescue => e
          reply.fail! "Error querying docker api (GET containers/#{request[:id]}/json), #{e}"
          logger.error e
        end
        logger.debug "docker/inspect done."
      end
      action "inspecti" do
        logger.debug "docker/inspecti"

        begin
          reply[:details] = _request(:get, "images/#{request[:image]}/json")
        rescue => e
          reply.fail! "Error querying docker api (GET images/#{request[:image]}/json), #{e}"
          logger.error e
        end
        logger.debug "docker/inspecti done."
      end
      action "kill" do
        logger.debug "docker/kill" 
        options = {}
        options[:signal] = request[:signal] if request[:signal]

        begin
          reply[:exitcode] = _request(:post, "containers/#{request[:id]}/kill?", options)
        rescue => e
          reply.fail! "Error querying docker api (POST containers/#{request[:id]}/kill), #{e}"
          logger.error e
        end
        logger.debug "docker/kill done."
      end
      action "pause" do
        logger.debug "docker/pause" 

        begin
          reply[:exitcode] = _request(:post, "containers/#{request[:id]}/pause")
        rescue => e
          reply.fail! "Error querying docker api (POST containers/#{request[:id]}/pause), #{e}"
          logger.error e
        end
        logger.debug "docker/pause done."
      end
      action "ps" do
        logger.debug "docker/ps"

        options = {}
        [:all, :limit, :sinceId, :beforeId, :size].each {|o|
          options[o] = request[o] if request.include?(o)
        }
        logger.debug "docker/ps options=#{options}"
        begin
          reply[:containers] = _request(:get, 'containers/json?', options)
        rescue => e
          reply.fail! "Error querying docker api (GET containers/json), #{e}"
          logger.error e
        end
        logger.debug "docker/ps done."
      end
      action "pull" do
        logger.debug "docker/pull" 
        options = {}
        options[:fromImage] = request[:fromimage]
        options[:tag] = request[:tag] if request[:tag]

        begin
          dummy = _request(:post, "images/pull?", options)
          reply[:exitcode] = 200
        rescue => e
          reply.fail! "Error querying docker api (POST images/create), #{e}"
          logger.error e
        end
        logger.debug "docker/pull done."
      end
      action "push" do
        logger.debug "docker/push" 
        options = {}
        options[:tag] = request[:tag] if request[:tag]

        begin
          if request[:registry]
            reply[:exitcode] = _request(:post, "images/#{request[:registry]}/#{request[:image]}/push?", 
                                        options)
          else
            reply[:exitcode] = _request(:post, "images/#{request[:image]}/push?", options)
          end
        rescue => e
          reply.fail! "Error querying docker api (POST images/#{request[:image]}/push), #{e}"
          logger.error e
        end
        logger.debug "docker/push done."
      end
      action "restart" do
        logger.debug "docker/restart" 
        options = {}
        options[:t] = request[:timeout] if request[:timeout]

        begin
          reply[:exitcode] = _request(:post, "containers/#{request[:id]}/restart?", options)
        rescue => e
          reply.fail! "Error querying docker api (POST containers/#{request[:id]}/restart), #{e}"
          logger.error e
        end
        logger.debug "docker/restart done."
      end
      action "rm" do
        logger.debug "docker/rm" 
        options = {}
        options[:v] = request[:rmvolumes] if request[:rmvolumes]
        options[:force] = request[:force] if request[:force]

        begin
          reply[:exitcode] = _request(:delete, "containers/#{request[:id]}?", options)
        rescue => e
          reply.fail! "Error querying docker api (DELETE containers/#{request[:id]}), #{e}"
          logger.error e
        end
        logger.debug "docker/rm done."
      end
      action "rmi" do
        logger.debug "docker/rmi" 
        options = {}
        [:noprune, :force].each {|o|
          options[o] = request[o] if request.include?(o)
        }

        begin
          reply[:images] = _request(:delete, "images/#{request[:image]}?", options)
          logger.debug "docker/rmi done."
        rescue => e
          unless @errorbody.empty?
            reply[:images] = @errorbody
          end
          reply.fail!("Error querying docker api (DELETE images/#{request[:image]})")
        end
      end
      action "start" do
        logger.debug "docker/start" 

        begin
          reply[:exitcode] = _request(:post, "containers/#{request[:id]}/start")
        rescue => e
          reply.fail! "Error querying docker api (POST containers/#{request[:id]}/start), #{e}"
          logger.error e
        end
        logger.debug "docker/start done."
      end
      action "stop" do
        logger.debug "docker/stop" 
        options = {}
        options[:t] = request[:timeout] if request[:timeout]

        begin
          reply[:exitcode] = _request(:post, "containers/#{request[:id]}/stop?", options)
        rescue => e
          reply.fail! "Error querying docker api (POST containers/#{request[:id]}/stop), #{e}"
          logger.error e
        end
        logger.debug "docker/stop done."
      end
      action "tag" do
        logger.debug "docker/tag" 
        options = {}
        [:repo, :tag, :force].each {|o|
          options[o] = request[o] if request.include?(o)
        }

        begin
          reply[:exitcode] = _request(:post, "images/#{request[:image]}/tag?", options)
        rescue => e
          reply.fail! "Error querying docker api (POST images/#{request[:image]}/tag), #{e}"
          logger.error e
        end
        logger.debug "docker/tag done."
      end
      action "top" do
        logger.debug "docker/top"
        options = {}
        options[:ps_args] = request[:psargs] if request[:psargs]

        begin
          reply[:processes] = _request(:get, "containers/#{request[:id]}/top?", options)
        rescue => e
          reply.fail! "Error querying docker api (GET containers/#{request[:id]}/top), #{e}"
          logger.error e
        end
        logger.debug "docker/top done."
      end
      action "unpause" do
        logger.debug "docker/unpause" 

        begin
          reply[:exitcode] = _request(:post, "containers/#{request[:id]}/unpause")
        rescue => e
          reply.fail! "Error querying docker api (POST containers/#{request[:id]}/unpause), #{e}"
          logger.error e
        end
        logger.debug "docker/unpause done."
      end
      private
      def _request(htmethod, endpoint, options = {}, body = "")
        @errorbody = ""
        timeout = 3600
        rs = endpoint
        unless options == {}
          options.each {|r| rs += "&" + URI.escape(r[0].to_s) + "=" + URI.escape(r[1].to_s) }
        end
        logger.debug "docker/_request htmethod=#{htmethod} endpoint=#{endpoint}, request=unix:///#{rs}, body=#{body}"
        connection = Excon.new("unix:///#{rs}", 
                               :socket => '/var/run/docker.sock', 
                                 :body => body, 
                                 :headers => {'Content-Type' => 'application/json'},
                                 :read_timeout => timeout,
                                 :method => htmethod)
        response = connection.request

        logger.debug "docker/_request status=#{response.status}"
        @htstatus = response.status
        case @htstatus
        when 200, 201, 204
          return response.body || ""
        else
          @errorbody = response.body if response.body
          logger.debug "docker/_request else case status=#{response.status}"
          raise "Unable to fulfill request. HTTP status #{response.status}"
        end
      end
      def _validateconfig(config)
        return true
      end
    end
  end
end
# vi:tabstop=2:expandtab:ai
