module Messaging

  def get_messages(page = nil)

    raise (Messaging::InvalidPageNumber).new if (page == 0)

    if page.nil?
      puts "Retrieving all messages"
      get_all_messages
    else
      puts "retrieving page ##{page}"
      retrieve_messages_from_server(page)["items"]
    end

  end

  #Leaving this as a public method as it could be useful later on for user to see total message number
  def retrieve_message_count_from_server
    response = retrieve_messages_from_server(1)
    response["count"]
  end

  private

  def retrieve_messages_from_server(page)
    response = self.class.get("/message_threads", body: { page: page }, headers: {"authorization" => auth_token} )
    JSON.parse(response.body)
  end

  def determine_messages_page_count

    #messages_per_page hardcoded in API of 10. Theoretically if this becomes variable
    #in the API we could create a method to allow changing of this variable
    messages_per_page = 10

    message_count = retrieve_message_count_from_server
    message_page_count = message_count / messages_per_page

    if message_count % 10 != 0
      message_page_count += 1
    end

    message_page_count

  end

  def get_all_messages

    all_messages = []
    page_count = determine_messages_page_count
    i = 1

    while i <= page_count
      messages = retrieve_messages_from_server(i)["items"]
      all_messages.concat(messages)
      i = i + 1
    end

   all_messages

  end

end

class Messaging::InvalidPageNumber < StandardError; end
