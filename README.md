<div id="top">

<!-- HEADER STYLE: CLASSIC -->
<div align="center">


# TRACKER

<em>Transforming Teams, Accelerating Success Daily</em>

<!-- BADGES -->
<img src="https://img.shields.io/github/last-commit/syntaxmage05/tracker?style=flat&logo=git&logoColor=white&color=0080ff" alt="last-commit">
<img src="https://img.shields.io/github/languages/top/syntaxmage05/tracker?style=flat&color=0080ff" alt="repo-top-language">
<img src="https://img.shields.io/github/languages/count/syntaxmage05/tracker?style=flat&color=0080ff" alt="repo-language-count">

<em>Built with the tools and technologies:</em>

<img src="https://img.shields.io/badge/Markdown-000000.svg?style=flat&logo=Markdown&logoColor=white" alt="Markdown">
<img src="https://img.shields.io/badge/Ruby-CC342D.svg?style=flat&logo=Ruby&logoColor=white" alt="Ruby">
<img src="https://img.shields.io/badge/JavaScript-F7DF1E.svg?style=flat&logo=JavaScript&logoColor=black" alt="JavaScript">
<img src="https://img.shields.io/badge/Docker-2496ED.svg?style=flat&logo=Docker&logoColor=white" alt="Docker">
<img src="https://img.shields.io/badge/GitHub%20Actions-2088FF.svg?style=flat&logo=GitHub-Actions&logoColor=white" alt="GitHub%20Actions">

</div>
<br>

---

## Table of Contents

- [Overview](#overview)
- [Getting Started](#getting-started)
    - [Prerequisites](#prerequisites)
    - [Installation](#installation)
    - [Usage](#usage)
    - [Testing](#testing)
- [Project Structure](#project-structure)

---

## Overview



---

## Project Structure

```sh
└── tracker/
    ├── .github
    │   ├── dependabot.yml
    │   └── workflows
    ├── Dockerfile
    ├── Gemfile
    ├── Gemfile.lock
    ├── Procfile.dev
    ├── README.md
    ├── Rakefile
    ├── app
    │   ├── assets
    │   ├── controllers
    │   ├── helpers
    │   ├── javascript
    │   ├── jobs
    │   ├── mailers
    │   ├── models
    │   ├── services
    │   └── views
    ├── config
    │   ├── application.rb
    │   ├── boot.rb
    │   ├── cable.yml
    │   ├── cache.yml
    │   ├── credentials.yml.enc
    │   ├── database.yml
    │   ├── deploy.yml
    │   ├── environment.rb
    │   ├── environments
    │   ├── importmap.rb
    │   ├── initializers
    │   ├── locales
    │   ├── puma.rb
    │   ├── queue.yml
    │   ├── recurring.yml
    │   ├── routes.rb
    │   └── storage.yml
    ├── config.ru
    ├── db
    │   ├── cable_schema.rb
    │   ├── cache_schema.rb
    │   ├── migrate
    │   ├── queue_schema.rb
    │   ├── schema.rb
    │   └── seeds.rb
    ├── lefthook.yml
    ├── lib
    │   └── tasks
    ├── log
    │   └── .keep
    ├── script
    │   └── .keep
    ├── spec
    │   ├── factories
    │   ├── jobs
    │   ├── mailers
    │   ├── models
    │   ├── rails_helper.rb
    │   ├── requests
    │   ├── services
    │   ├── spec_helper.rb
    │   ├── support
    │   ├── system
    │   └── views
    └── storage
        └── .keep
```

---

## Getting Started

### Prerequisites

This project requires the following dependencies:

- **Programming Language:** Ruby
- **Package Manager:** Bundler, Rake
- **Container Runtime:** Docker

### Installation

Build tracker from the source and install dependencies:

1. **Clone the repository:**

    ```sh
    ❯ git clone https://github.com/syntaxmage05/tracker
    ```

2. **Navigate to the project directory:**

    ```sh
    ❯ cd tracker
    ```

3. **Install the dependencies:**

**Using [docker](https://www.docker.com/):**

```sh
❯ docker build -t syntaxmage05/tracker .
```
**Using [bundler](https://www.ruby-lang.org/):**

```sh
❯ bundle install
```

### Usage

Run the project with:

**Using [docker](https://www.docker.com/):**

```sh
docker run -it syntaxmage05/tracker .
```
**Using [bundler](https://www.ruby-lang.org/):**

```sh
bundle exec ruby 
```

### Testing

Tracker uses the {RSPEC} test framework. Run the test suite with:


```sh
bundle exec rspec
```

---

<div align="left"><a href="#top">⬆ Return</a></div>

---
