# README

# **Game of Life Extendi**

A Ruby on Rails web application based on Conway's *Game of Life*, enhanced with Docker support, TailwindCSS for styling, and a streamlined setup process for development and production environments.

---

## **Table of Contents**
1. [Overview](#overview)
2. [Features](#features)
3. [Setup and Installation](#setup-and-installation)
4. [Running the Project](#running-the-project)
5. [Running tests](#running-tests)
6. [Generating Documentation](#generating-documentation)
7. [Technologies Used](#technologies-used)
8. [License](#license)

---

## **Overview**

**Game of Life Extendi** implements Conway's *Game of Life* in a responsive web application. It uses Rails 8 as the backend and TailwindCSS for a clean user interface. The project is pre-configured for development using **Docker Compose** and can be deployed easily in production.

---

## **Features**

- **Dynamic Simulation**: Simulate Conway's *Game of Life* with an interactive interface.
- **Responsive UI**: TailwindCSS provides a clean and adaptable design.
- **Dockerized Environment**: Simplified setup using Docker for development and production.
- **Email Integration**: Support for notifications via Gmail.

---

## **Setup and Installation**

### **1. Prerequisites**

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/)
- Git installed on your machine.

---

### **2. Clone the Repository**

Clone the project to your local machine:

```bash
  git clone https://github.com/gsimei/game-of-life-extendi.git
  cd game-of-life-extendi
```

### **3. Create Environment Variablesy**
The .env file will be send by email

---

## **Running the Project**

### **Using Docker Compose**
To run the development environment:

```bash
  docker compose up --build
```

Once the setup is complete, access the app at:
http://localhost:3000


```bash
  docker compose down
```

---

## **Running Tests**

### **1. Running RSpec**

To run the test suite with RSpec:

```bash
  docker compose -f docker-compose.test.yml run --rm app bundle exec rspec
```
This will execute all the test files located in your spec/ directory.

---

## **Generating Documentation**

### **1. Generating Yard Documentation**

To view the documentation locally:

```bash
  http://0.0.0.0:8808
```

---

## **Technologies Used**

* Backend: Ruby on Rails 8.0.0.1
* Styling: TailwindCSS
* Database: PostgreSQL
* Containerization: Docker, Docker Compose
* Email Service: Gmail SMTP

---

## **License**

This project is licensed under the [MIT License](https://opensource.org/licenses/MIT).

---

## **Author**

### **George Simei**
* GitHub: [@gsimei](https://github.com/gsimei)
* Email: georgesimei@gmail.com
