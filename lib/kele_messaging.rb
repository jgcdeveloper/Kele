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

  #Leaving this as a public method as it could be useful later on for user to see total message number.
  #Set to retrieve first page to reduce data usage.
  def retrieve_message_count_from_server
    response = retrieve_messages_from_server(1)
    response["count"]
  end

  def create_message(token = nil, recipient_id = @current_user_mentor_id)

    raise (Kele::NoUserDefined).new if @current_user.nil?

    display_create_message_header(@current_user["email"], recipient_id, token)

    #only require a new subject if token is undefined
    (message_subject = set_message_subject) if token == nil

    message_body = set_message_body

    options = {
      body: {
        "sender": current_user["email"],
        "recipient_id": recipient_id,
        "subject": message_subject,
        "stripped-text": message_body
      },

      headers: {
        :authorization => auth_token
      }
    }

    (options[:body][:token] = token) if token != nil

    self.class.post("/messages", options )

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

  def display_create_message_header(user, recipient, token)

    print "Sending Message From: "
    puts user

    print "Recipient ID "
    print "(User Mentor)" if (recipient == @current_user_mentor_id)
    print ": "
    puts recipient

    if token == nil
      puts "Creating new message!"
    else
      print "Creating message on token thread: "
      puts token
    end

  end

  def set_message_subject
    print "Enter Message Subject (Max Length: 128): "
    message_subject = gets.chomp
    raise (Messaging::BlankMessageSubject).new if message_subject == ""
    raise (Messaging::SubjectTooLong).new if message_subject.length >= 128
    message_subject
  end

  def set_message_body
    print "Enter Message: "
    message_body = gets.chomp
    raise (Messaging::BlankMessageBody).new if message_body == ""
    message_body
  end

end

class Messaging::InvalidPageNumber < StandardError; end
class Messaging::BlankMessageSubject < StandardError; end
class Messaging::BlankMessageBody < StandardError; end
class Messaging::SubjectTooLong < StandardError; end
