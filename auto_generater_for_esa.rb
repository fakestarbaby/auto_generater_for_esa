require "active_support/time"
require "esa"
require "slack-notifier"

client = Esa::Client.new(access_token: ENV["ESA_ACCESS_TOKEN"], current_team: ENV["ESA_TEAM"])
posts = client.posts(q: "in:#{ENV["SEARCH_QUERY_CATEGORY"]} title:#{ENV["SEARCH_QUERY_TITLE"]} created:>#{Time.current.prev_week.strftime("%Y-%m-%d")}")
parent_post_number = posts.body["posts"].first["number"]
post = client.create_post(parent_post_id: parent_post_number)

Slack::Notifier.new(ENV['SLACK_WEBHOOK_URL']).ping("#{ENV["SLACK_MESSAGE_TEMPLATE"]} #{post.body["url"]}")
