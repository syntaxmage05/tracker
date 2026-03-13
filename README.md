# Tracker

**Tracker** is a modern SaaS web application built with **Ruby on Rails 8**, **PostgreSQL**, and **Hotwire**. It helps users manage and track tasks, accounts, and other resources in a responsive, real-time interface.

---

## Features

- ✅ User authentication and account management  
- ✅ Role-based permissions (normal users vs admins)  
- ✅ Real-time updates using **Hotwire** (Turbo & Stimulus)  
- ✅ Task, account, or data tracking with full CRUD operations  
- ✅ PostgreSQL database for reliable data storage  
- ✅ Responsive design for desktop and mobile  

---

## Getting Started

### Prerequisites

Ensure the following are installed:

- Ruby 3.x (compatible with Rails 8)  
- Rails 8  
- PostgreSQL 15+    
- Git  

---

### Installation

1. Clone the repository:

```bash
git clone https://github.com/syntaxmage05/tracker.git
cd tracker

Install Ruby gems:

bundle install

Set up the database:

rails db:create
rails db:migrate
rails db:seed   

Start the Rails server:

rails server

Visit http://localhost:3000 in your browser.
