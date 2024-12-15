# README

# **Game of Life Extendi**

A Ruby on Rails web application based on Conway's *Game of Life*, enhanced with Docker support, TailwindCSS for styling, and a streamlined setup process for development and production environments.

---

## **Table of Contents**
1. [Overview](#overview)
2. [Features](#features)
3. [Code Structure](#code-structure)
4. [Setup and Installation](#setup-and-installation)
5. [Running the Project](#running-the-project)
6. [Running tests](#running-tests)
7. [Generating Documentation](#generating-documentation)
8. [Technologies Used](#technologies-used)
9. [License](#license)

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

## **Code Structure**

### **Model**

#### **GameState**
- **Responsibility**: Represents the state of the game grid for a specific user.
- **Attributes**:
  - `generation` - Tracks the current generation of the game.
  - `rows` - Number of rows in the grid.
  - `cols` - Number of columns in the grid.
  - `state` - A 2D array representing the game grid (`*` for alive, `.` for dead).
  - `alived_cells_count` - Count of alive cells in the grid.
  - `initial_file_data` - Stores the initial game state for reset functionality.
- **Key Methods**:
  - `next_generation!` - Advances the game state to the next generation using the `GameStateProgressionService`.
  - `restore_initial_state!` - Restores the game state to its original configuration.
- **Callbacks**:
  - `process_file` - Parses the uploaded file and initializes game state attributes.
  - `validate_file_type` - Ensures that the uploaded file is a `.txt` file.
  - `update_alived_cells_count` - Calculates the number of alive cells before saving.
  - `store_initial_file_data` - Saves the initial state for restoration.


### **Controller**

#### **GameStatesController**
- **Responsibility**: Manages game states for Conway's *Game of Life*.
- **Key Actions**:
  - `index` - Lists all game states.
  - `show` - Displays the details of a specific game state.
  - `new` - Renders a form to upload a new game state.
  - `create` - Processes and saves a new game state from a `.txt` file.
  - `next_generation` - Advances the game state to the next generation.
  - `reset_to_initial` - Resets the game state to its initial configuration.
  - `destroy` - Deletes a game state and redirects to the index page.

---

### **Services**

#### **GameStateUploadService**
- **Purpose**: Parses and validates uploaded `.txt` files to initialize game states.
- **Logic**:
  - Extracts the generation, grid dimensions, and cell states.
  - Ensures the file content matches expected format and structure.

#### **GameStateProgressionService**
- **Purpose**: Calculates the next generation for the *Game of Life* grid.
- **Logic**:
  - Iterates through each cell to count live neighbors.
  - Applies Conway's rules to determine the cell's next state (alive or dead).
  - Updates the game state and increments the generation counter.

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
  docker compose run -e RAILS_ENV=test app bundle exec rspec
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
