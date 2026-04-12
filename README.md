# Social Media App

An example application built with Ruby on Rails, React, and Relay.

Frontend Application: https://github.com/DennisMartinez/social-media-app

You can view the demo at https://social-media.dennismartinez.io/. The sign in credentials are below.

```bash
email: admin@example.com
password: password
```

_Note:_ The demo database resets every hour.

---

---

## Getting Started

### Prerequisites

1. **Ruby on Rails** — https://guides.rubyonrails.org/install_ruby_on_rails.html
   1. Good video on installing Rails https://www.youtube.com/watch?v=oEDkhfsFMTg

### Running the Backend App

After install Ruby on Rails, install the dependencies and start the development server:

```bash
bundle install
bin/rails s
```

The app will be available at:
```bash
http://localhost:3000
```

The GraphQL url will be available at:
```bash
http://localhost:3000/graphql
```

#### Seeding Data
You can generate fake data by running the following command in a Rails console. By default, it'll generate 100 users with various posts, comments, and likes. If you'd like more or less than 100 users, you can pass a number as the first parameter.

```bash
GenerateFakeDataJob.perform_now(100)
```

### Running the Frontend App

See setup instructions here: https://github.com/DennisMartinez/social-media-app
