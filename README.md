# Project Conversation History

This is a Ruby on Rails application that allows users to create and manage projects. Users can add comments, change the project's status, and view a history of conversations and status updates. The application is currently hosted on [Fly.io](https://project-conversation.fly.dev/).

## Table of Contents
- [Tech Stack](#tech-stack)
- [Features](#features)
- [Setup and Installation](#setup-and-installation)
- [Usage](#usage)
- [Testing](#testing)
- [Deployment](#deployment)
- [Contributing](#contributing)
- [License](#license)
- [Notes](#notes)

## Tech Stack
- **Backend:** Ruby on Rails (latest)
- **Frontend:** Tailwind CSS, Slim templates
- **Database:** PostgreSQL
- **Authentication:** Devise
- **Pagination:** Kaminari
- **JavaScript:** Stimulus, Turbo
- **Deployment:** Fly.io

## Features
- User authentication using Devise.
- Role-based permissions (Admins can edit and delete all content, while Members have limited access).
- Projects can be created, edited, and deleted by users.
- Users can add comments to projects and change the project's status (e.g., Not Started, In Progress, Completed, On Hold).
- Comment history with pagination using Kaminari.
- Real-time comment updates using Turbo.
- Admin users have full functionality, while member accounts have limited access.

## Setup and Installation

### Prerequisites
- Ruby (version specified in the Gemfile)
- Rails (latest version)
- PostgreSQL
- Node.js and Yarn
- Fly.io CLI (for deployment)

### Installation
1. **Clone the repository:**
    ```bash
    git clone https://github.com/sebastian-siemianowski/project_conversation.git
    cd project_conversation
    ```

2. **Install dependencies:**
    ```bash
    bundle install
    yarn install
    ```

3. **Set up the database:**
   Create and migrate the database.
    ```bash
    rails db:create
    rails db:migrate
    ```

4. **Set up environment variables:**
   Create a `.env` file in the root directory to store sensitive information (e.g., Devise secret key, database credentials).
    ```dotenv
    DATABASE_USERNAME=your_db_username
    DATABASE_PASSWORD=your_db_password
    SECRET_KEY_BASE=your_secret_key_base
    ```

5. **Run the server:**
    ```bash
    rails server
    ```
   Visit `http://localhost:3000` in your web browser.

## Usage
- Visit the [hosted application](https://project-conversation.fly.dev/).
- Create an account to log in.
- Admin users have full access to manage all content, while member accounts have limited functionality.
- Create a new project, add comments, and change the project's status.
- Real-time updates are available for comments and status changes using Turbo Streams.

## Testing
- This application uses RSpec for testing.
- To run the tests, use:
    ```bash
    bundle exec rspec
    ```

## Deployment
The application is hosted on [Fly.io](https://fly.io/). To deploy it yourself, follow these steps:

1. **Log in to Fly.io:**
    ```bash
    fly auth login
    ```

2. **Create a new Fly.io app:**
    ```bash
    fly launch
    ```

3. **Deploy the application:**
    ```bash
    fly deploy
    ```

4. **Run database migrations on Fly.io:**
    ```bash
    fly ssh console -C "bin/rails db:migrate"
    ```

## Contributing
1. Fork the repository.
2. Create your feature branch (`git checkout -b feature/YourFeature`).
3. Commit your changes (`git commit -m 'Add some feature'`).
4. Push to the branch (`git push origin feature/YourFeature`).
5. Open a pull request.

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

##
