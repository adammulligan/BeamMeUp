class BeamMeUp < Padrino::Application
  use ActiveRecord::ConnectionAdapters::ConnectionManagement
  register Padrino::Rendering
  register Padrino::Mailer
  register Padrino::Helpers

  enable :sessions

  get "/" do
    haml :index
  end

  post '/', :provides => :json do
    if params[:upload] && (tmpfile = params[:upload][:tempfile]) && (name = params[:upload][:filename])
      puts "Uploading #{name}.."
      File.open(File.join("/mnt/geiger/downloads/_watch", name), "wb") { |f| f.write(tmpfile.read) }

      return {:success => "File uploaded"}.to_json
    end

    return {:error => "File not provided"}.to_json
  end
end
