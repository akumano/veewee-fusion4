module Veewee
  module Provider
    module Core
      module Helper
        require 'webrick'
        include WEBrick
        module Servlet


          class FileServlet < WEBrick::HTTPServlet::AbstractServlet

            attr_reader :ui

            def initialize(server,localfile,ui)
              super(server)
              @server=server
              @localfile=localfile
              @ui=ui
            end

            def do_GET(request,response)
              response['Content-Type']='text/plain'
              response.status = 200
              ui.info "Serving file #{@localfile}"
              displayfile=File.open(@localfile,'r')
              content=displayfile.read()
              response.body=content
              #If we shut too fast it might not get the complete file
              sleep 2
              @server.shutdown
            end
          end

        end
        module Web

          def wait_for_http_request(filename,options={:timeout => 10, :web_dir => "", :port => 7125})


            # Calculate the OS equivalent of /dev/null , on windows this is NUL:
            # http://www.ruby-forum.com/topic/115472
            fn = test(?e, '/dev/null') ? '/dev/null' : 'NUL:'

            webrick_logger=WEBrick::Log.new(fn, WEBrick::Log::INFO)

            web_dir=options[:web_dir]
            filename=filename
            s= ::WEBrick::HTTPServer.new(
              :Port => options[:port],
              :Logger => webrick_logger,
              :AccessLog => webrick_logger
            )
            env.logger.debug("mounting file /#{filename}")
            s.mount("/#{filename}", Veewee::Provider::Core::Helper::Servlet::FileServlet,File.join(web_dir,filename),ui)
            trap("INT"){
              s.shutdown
              ui.info "Stopping webserver"
              exit
            }
            #s.start
	    #puts "I changed something here. Webserver doesn't start. web.rb"
          end

        end #Class
      end #Module
    end #Module
  end #Module
end #Module
