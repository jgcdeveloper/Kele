module Roadmap

  def get_roadmap(roadmap_id)
    response = self.class.get("/roadmaps/#{roadmap_id}", headers: { "authorization" => auth_token })
    roadmap = JSON.parse(response.body)
    write_to_file('roadmap.txt',roadmap)
  end

  def get_checkpoint(checkpoint_id)
    response = self.class.get("/checkpoints/#{checkpoint_id}", headers: { "authorization" => @auth_token })
    checkpoint = JSON.parse(response.body)
    write_to_file('checkpoint.txt',checkpoint)
  end

  private

  def write_to_file(filename,text)
    File.open(filename, 'w') { |file| file.write(text)}
    puts "#{filename} has been written to root directory"
  end

end
