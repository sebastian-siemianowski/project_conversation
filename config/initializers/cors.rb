Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # Replace with your Fly.io domain
    origins 'https://project-conversation.fly.dev'

    resource '*',
             headers: :any, # Allow any headers (this will handle Turbo's custom headers)
             methods: [:get, :post, :put, :patch, :delete, :options, :head], # Allow all relevant HTTP methods
             expose: ['Accept', 'Content-Type', 'X-CSRF-Token', 'ETag', 'Location'], # Expose headers used in Turbo responses
             max_age: 600
  end
end
