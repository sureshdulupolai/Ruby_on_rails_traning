# 💰 Expense Tracker

A modern, fast, and intuitive web application built with **Ruby on Rails 8** to effortlessly track, categorize, and manage personal daily expenses.

---

## 📑 Table of Contents

- [Overview](#-overview)
- [Key Features](#-key-features)
- [Tech Stack](#-tech-stack)
- [Architecture & Data Model](#-architecture--data-model)
- [Routes & Endpoints](#-routes--endpoints)
- [Getting Started](#-getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation & Setup](#installation--setup)
  - [Running the Application](#running-the-application)
- [Running Tests & Quality Checks](#-running-tests--quality-checks)
- [Docker & Containerization](#-docker--containerization)
- [Directory Structure](#-directory-structure)
- [Roadmap & Future Enhancements](#-roadmap--future-enhancements)
- [License](#-license)

---

## 🌟 Overview

**Expense Tracker** is designed to provide users with a clean, responsive, and seamless interface to record financial transactions. Built on the latest **Ruby on Rails 8.1+** stack, it utilizes **Hotwire (Turbo & Stimulus)**, **PostgreSQL**, and **Bootstrap 5** for an interactive, modern user experience without heavy client-side JavaScript frameworks.

---

## ✨ Key Features

- **Full Expense Lifecycle (CRUD)**:
  - **Create**: Add new expenses with date, amount, category, and optional detailed descriptions.
  - **Read**: View a chronological history of all recorded expenses as well as single-expense detail pages.
  - **Update**: Modify amounts, categories, dates, or notes at any time.
  - **Delete**: Remove transactions with Turbo confirmation modals.
- **Categorization**:
  - Predefined standard expense categories:
    - 🍔 `Food`
    - ✈️ `Travel`
    - 🛍️ `Shopping`
    - 💡 `Bills`
    - 🎬 `Entertainment`
    - 📦 `Other`
- **Data Validation & Integrity**:
  - Positive numeric amount validation (`> 0`).
  - Strict category whitelist validation.
  - Mandatory date selection (defaults to current date for quick entry).
  - Maximum 500-character note/description limit with user-friendly error banners.
- **Modern & Responsive UI**:
  - Styled with **Bootstrap 5.3**.
  - Formatted currency display (`₹`) and human-readable dates.
  - Category badges for visual clarity.
- **Rails 8 Modern Foundation**:
  - Asset management via **Propshaft** and **Importmap**.
  - Built-in database-backed caching, queuing, and real-time support via **Solid Cache**, **Solid Queue**, and **Solid Cable**.
  - Health check endpoint (`/up`) for uptime monitoring.

---

## 🛠️ Tech Stack

| Layer | Technology |
| :--- | :--- |
| **Language** | Ruby `3.2.9` |
| **Framework** | Ruby on Rails `8.1.3+` |
| **Database** | PostgreSQL (`pg` gem) |
| **Frontend UI** | Bootstrap `5.3`, HTML5, CSS3 |
| **JavaScript & Assets** | Turbo Rails, Stimulus Rails, Importmaps, Propshaft |
| **Caching / Queue / Cable** | Solid Cache, Solid Queue, Solid Cable |
| **Web Server** | Puma + Thruster (HTTP acceleration & asset compression) |
| **Testing** | Minitest, Capybara, Selenium WebDriver, Rails Controller Testing |
| **Security & Quality** | Brakeman, RuboCop (`rubocop-rails-omakase`), Bundler-Audit |
| **Deployment & Containers** | Docker (Multi-stage build), Kamal |

---

## 🗄️ Architecture & Data Model

The application leverages Active Record to manage persistence in PostgreSQL.

### Database Schema: `expenses`

| Column | Type | Nullable | Constraints & Validations | Description |
| :--- | :--- | :---: | :--- | :--- |
| `id` | `bigint` | No | Primary Key, Auto-increment | Unique identifier |
| `amount` | `decimal` | No | `presence: true`, `numericality: { greater_than: 0 }` | Transaction amount |
| `category` | `string` | No | `presence: true`, `inclusion: { in: VALID_CATEGORIES }` | Expense category |
| `date` | `date` | No | `presence: true` | Date when expense occurred |
| `description`| `text` | Yes | `length: { maximum: 500 }`, `allow_blank: true` | Optional transaction note |
| `created_at` | `datetime`| No | Active Record timestamp | Creation timestamp |
| `updated_at` | `datetime`| No | Active Record timestamp | Last updated timestamp |

### Model Logic (`app/models/expense.rb`)
```ruby
class Expense < ApplicationRecord
  VALID_CATEGORIES = %w[Food Travel Shopping Bills Entertainment Other].freeze

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :category, presence: true, inclusion: { in: VALID_CATEGORIES }
  validates :date, presence: true
  validates :description, length: { maximum: 500 }, allow_blank: true
end
```

---

## 🧭 Routes & Endpoints

| HTTP Method | Path | Controller#Action | Purpose |
| :--- | :--- | :--- | :--- |
| `GET` | `/expenses` | `expenses#index` | List all expenses (ordered by date descending) |
| `GET` | `/expenses/new` | `expenses#new` | Render form to create a new expense |
| `POST` | `/expenses` | `expenses#create` | Create a new expense record in database |
| `GET` | `/expenses/:id` | `expenses#show` | Show details of a specific expense |
| `GET` | `/expenses/:id/edit`| `expenses#edit` | Render form to edit an existing expense |
| `PATCH/PUT` | `/expenses/:id` | `expenses#update` | Update an existing expense record |
| `DELETE` | `/expenses/:id` | `expenses#destroy` | Delete an expense record |
| `GET` | `/up` | `rails/health#show` | Health check endpoint for uptime monitors |

---

## 🚀 Getting Started

Follow these steps to set up and run the application locally on your machine.

### Prerequisites

Ensure you have the following installed:
- **Ruby**: Version `3.2.9` (recommended to use a version manager like `rbenv`, `asdf`, or `rvm`)
- **PostgreSQL**: Version `12+` running and accepting connections
- **Bundler**: `gem install bundler`
- **Git**

### Installation & Setup

1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   cd expense_tracker
   ```

2. **Install Ruby dependencies**:
   ```bash
   bundle install
   ```

3. **Configure Database**:
   Verify your PostgreSQL connection settings in `config/database.yml`. Update username/password if required.

4. **Create & Prepare the Database**:
   ```bash
   bin/rails db:create
   bin/rails db:migrate
   bin/rails db:seed
   ```

### Running the Application

Start the Rails Puma development server:
```bash
bin/rails server
```
Or start with the development runner:
```bash
bin/dev
```

Open your browser and navigate to:
```
http://localhost:3000/expenses
```

---

## 🧪 Running Tests & Quality Checks

The application is thoroughly covered by automated test suites testing all validations, boundaries, and controller actions.

### 1. Run the Test Suite
```bash
bin/rails test
```
To run specific test files:
```bash
bin/rails test test/models/expense_test.rb
bin/rails test test/controllers/expenses_controller_test.rb
```

### 2. Static Security Scan
Run [Brakeman](https://brakemanscanner.org/) to detect security vulnerabilities:
```bash
bundle exec brakeman
```

### 3. Code Style & Linter
Run [RuboCop](https://rubocop.org/) with Rails omakase rules:
```bash
bundle exec rubocop
```

### 4. Dependency Vulnerability Audit
```bash
bundle exec bundler-audit --update
```

---

## 🐳 Docker & Containerization

A production-ready multi-stage `Dockerfile` is included with optimizations for `jemalloc` and `bootsnap` precompilation.

### Build and Run with Docker:

1. **Build the Docker image**:
   ```bash
   docker build -t expense_tracker .
   ```

2. **Run container**:
   ```bash
   docker run -d -p 80:80 \
     -e RAILS_MASTER_KEY=<your-master-key> \
     -e DATABASE_URL=postgres://user:password@host:5432/expense_tracker_production \
     --name expense_tracker expense_tracker
   ```

### Deployment with Kamal
The project includes a `.kamal/` configuration for automated zero-downtime server deployments.
```bash
kamal deploy
```

---

## 📁 Directory Structure

```text
expense_tracker/
├── app/
│   ├── controllers/         # Application & Expenses controllers
│   │   ├── application_controller.rb
│   │   └── expenses_controller.rb
│   ├── models/              # Active Record models (Expense)
│   │   ├── application_record.rb
│   │   └── expense.rb
│   ├── views/               # ERB templates & layouts
│   │   ├── expenses/        # Views for index, show, new, edit, _form
│   │   └── layouts/         # Base layout with Bootstrap 5
│   └── javascript/          # Hotwire Stimulus controllers & importmaps
├── config/
│   ├── routes.rb            # RESTful routing definition
│   ├── database.yml         # PostgreSQL configuration
│   └── environments/        # Environment-specific configs (dev, test, prod)
├── db/
│   ├── migrate/             # Active Record schema migrations
│   ├── schema.rb            # Current database schema
│   └── seeds.rb             # Initial seed data
├── test/
│   ├── controllers/         # Controller integration tests
│   ├── models/              # Model unit & validation tests
│   └── test_helper.rb       # Test setup and configuration
├── .github/workflows/       # GitHub Actions CI pipeline
├── Dockerfile               # Production Dockerfile
└── Gemfile                  # Ruby gem dependencies
```

---

## 🗺️ Roadmap & Future Enhancements

- [ ] **User Authentication & Multi-tenancy**: Integrate Devise or Rails 8 built-in authentication for multi-user support.
- [ ] **Interactive Analytics & Dashboards**: Monthly spending breakdown charts using Chart.js or ApexCharts.
- [ ] **Budget Limits & Alerts**: Set monthly category budget thresholds and email notifications.
- [ ] **Export & Reports**: Export expense records to CSV / Excel / PDF reports.
- [ ] **Receipt Uploads**: Attach receipts/invoices using Active Storage.
- [ ] **PWA & Offline Support**: Enable Service Workers and manifest for mobile installation.

---

## 📄 License

This project is open-source and available under the [MIT License](LICENSE).
