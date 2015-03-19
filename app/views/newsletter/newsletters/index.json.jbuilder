json.array!(@newsletters) do |newsletter|
  json.extract! newsletter, :id, :subject, :body
  json.url newsletter_url(newsletter, format: :json)
end
