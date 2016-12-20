module Roadmap

  def get_roadmap(roadmap_id)
    response = self.class.get("/roadmaps/#{roadmap_id}", headers: { "authorization" => auth_token })
    raise (Roadmap::InvalidRoadmapIDError).new if response.code != 200

    @roadmap = JSON.parse(response.body)
    roadmap = @roadmap
    write_to_file('./generated_doc/roadmap.txt','roadmap.txt',roadmap)
  end


  def get_checkpoint(checkpoint_id)
    response = self.class.get("/checkpoints/#{checkpoint_id}", headers: { "authorization" => @auth_token })
    raise (Roadmap::InvalidCheckpointIDError).new if response.code != 200

    @checkpoint = JSON.parse(response.body)
    checkpoint = @checkpoint
    write_to_file('./generated_doc/checkpoint.txt','checkpoint.txt',checkpoint)
  end

  private

  def write_to_file(filename,file_title,text)
    File.open(filename, 'w') { |file| file.write(text)}
    puts "#{file_title} has been written to root directory"
  end

end

class Roadmap::InvalidRoadmapIDError < StandardError; end
class Roadmap::InvalidCheckpointIDError < StandardError; end
