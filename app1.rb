require 'sinatra'   # gem 'sinatra'
require 'line/bot'  # gem 'line-bot-api'

def client
  @client ||= Line::Bot::Client.new { |config|
    config.channel_secret = ENV["p0XYHyv+vaz/gu4mU2yBjOKCY7s7H/g4kvtBHJ2Ln84/oDHXPQli/UkU3y0Yli+unc+fdZB80n/8d6Ud+U3BVTf6DY71tXkmwiecDHUCTjQT/hT7R8M878XrGzE2TSbX138NGViJlhOOrK4rZm7mawdB04t89/1O/w1cDnyilFU="]
    config.channel_token = ENV["a635011dbf5f265661ea83c64d0faf52"]
  }
end

post '/callback' do
  body = request.body.read

  signature = request.env['HTTP_X_LINE_SIGNATURE']
  unless client.validate_signature(body, signature)
    error 400 do 'Bad Request' end
  end

  events = client.parse_events_from(body)

  events.each { |event|
    case event
    when Line::Bot::Event::Message
      case event.type
      when Line::Bot::Event::MessageType::Text
        message = {
          type: 'text',
          text: event.message['text']
        }
        client.reply_message(event['replyToken'], message)
      end
    end
  }

  "OK"
end
