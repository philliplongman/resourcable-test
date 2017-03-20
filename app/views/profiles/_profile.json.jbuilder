json.extract! profile, :id, :display_name, :created_at, :updated_at
json.url profile_url(profile, format: :json)
