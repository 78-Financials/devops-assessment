# Flask API Dockerized

This repository contains a simple Python Flask application that serves as an API fetching responses from a JSON document stored in an AWS S3 bucket. The application is containerized using Docker for easy deployment and isolation.

## Getting Started

### Prerequisites

- [Docker](https://docs.docker.com/get-docker/) installed on your machine.

# Environment Variables and Application Structure

## Environment Variables

To run the Flask API Docker container, you can customize its behavior using the following environment variables:

- **S3_BUCKET_NAME:** The name of the AWS S3 bucket.
- **S3_FILE_KEY:** The key of the JSON document in the S3 bucket.

## Application Structure

The Flask API Dockerized project has the following structure:

- **app.py:** Contains the Flask application code.
- **Dockerfile:** Configures Docker for building the container.
- **requirements.txt:** Lists the Python dependencies for the application.


### Build and Run the Docker Container

1. **Clone the repository:**

   ```bash
   git clone https://github.com/adesokandijam/devops-assessment.git
   cd devops-assessment/app

2. **Build the Docker Image:**
    ```bash
    docker build -t flask-api .

3. **Run the Docker Image With Environment Variable:**
    ```bash
    docker run -p 8000:8000 -e S3_BUCKET_NAME=your-bucket -e S3_FILE_KEY=your-file.json flask-api


