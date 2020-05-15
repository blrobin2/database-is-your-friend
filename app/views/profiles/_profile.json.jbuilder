json.extract! profile, :id, :bio, :birth, :death, :created_at, :updated_at
json.url profile_url(profile, format: :json)
