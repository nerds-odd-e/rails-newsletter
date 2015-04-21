json.array!(@mail_templates) do |newsletter|
  json.extract! newsletter, :id, :subject, :body
  json.url newsletter_url(newsletter, format: :json)
end
