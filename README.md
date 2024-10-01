# Project Conversation History

This is a Ruby on Rails application that allows users to create and manage projects. Users can add comments and change the project's status. The project conversation history records comments and status changes for easy tracking.

## Table of Contents
- [Tech Stack](#tech-stack)
- [Features](#features)
- [Setup and Installation](#setup-and-installation)
- [Usage](#usage)
- [Testing](#testing)
- [Deployment](#deployment)
- [Contributing](#contributing)
- [License](#license)

## Tech Stack
- **Backend:** Ruby on Rails (latest)
- **Frontend:** Tailwind CSS, Slim templates
- **Database:** PostgreSQL
- **Authentication:** Devise
- **Pagination:** Kaminari
- **JavaScript:** Stimulus, Turbo
- **Deployment:** Heroku

## Features
- User authentication using Devise.
- Projects can be created, edited, and deleted by users.
- Users can add comments to projects.
- Users can change the status of a project (e.g., Not Started, In Progress, Completed).
- Comment history with pagination using Kaminari.
- Role-based permissions (Admins can edit and delete all content, while Members have limited access).
- Real-time comment updates using Turbo.

## Setup and Installation

### Prerequisites
- Ruby (version specified in the Gemfile)
- Rails (latest version)
- PostgreSQL
- Node.js and Yarn
- Heroku CLI (for deployment)

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
- Sign up or log in as a user.
- Create a new project, add comments, and change the project's status.
- Admin users can manage all content, while regular members have limited access.

## Testing
- This application uses RSpec for testing.
- To run the tests, use:
    ```bash
    bundle exec rspec
    ```

## Deployment
To deploy this application to Heroku:

1. **Log in to Heroku:**
    ```bash
    heroku login
    ```

2. **Create a new Heroku app:**
    ```bash
    heroku create your-app-name
    ```

3. **Push to Heroku:**
    ```bash
    git push heroku main
    ```

4. **Run database migrations on Heroku:**
    ```bash
    heroku run rails db:migrate
    ```

5. **Open the application:**
    ```bash
    heroku open
    ```

## Contributing
1. Fork the repository.
2. Create your feature branch (`git checkout -b feature/YourFeature`).
3. Commit your changes (`git commit -m 'Add some feature'`).
4. Push to the branch (`git push origin feature/YourFeature`).
5. Open a pull request.

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
