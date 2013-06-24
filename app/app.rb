class BeamMeUp < Padrino::Application
  use ActiveRecord::ConnectionAdapters::ConnectionManagement
  register Padrino::Rendering
  register Padrino::Mailer
  register Padrino::Helpers

  require 'httparty'

  before do
    response.headers['Access-Control-Allow-Origin'] = '*'
  end

  get "/" do
    haml :index
  end

  post '/', :provides => :json do
    if params[:upload] && (tmpfile = params[:upload][:tempfile]) && (name = params[:upload][:filename])
      puts "Uploading #{name}.."
      File.open(File.join(BeamMeUp.watch_dir, name), "wb") { |f| f.write(tmpfile.read) }

      return {:success => "File uploaded"}.to_json
    end

    if !params["url"].empty?
      puts "Getting #{params["url"]}.."
      torrent_bin = HTTParty.get(
        params["url"],
        {
          :headers => {'Cookie' => "uid=#{BeamMeUp.ipt_uid}; pass=#{BeamMeUp.ipt_pass}; PHPSESSID=#{BeamMeUp.ipt_phpsessid}"}
        }
      )

      file_name   = File.basename(params["url"])
      puts "Writing to #{file_name}.."

      File.open(File.join(BeamMeUp.watch_dir, file_name), "wb") { |f| f.write(torrent_bin) }

      return {:success => "Fetched URL successfully"}.to_json
    end

    return {:error => "No file or URL provided"}.to_json
  end
end
