# Use an official Python Alpine image as a parent image
FROM python:3.10.9-alpine

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container
COPY . /app

# Install any needed packages specified in requirements.txt
RUN apk --no-cache add gcc musl-dev libffi-dev openssl-dev && \
    pip install --no-cache-dir -r requirements.txt && \
    apk del gcc musl-dev libffi-dev openssl-dev

# Make port 8000 available to the world outside this container
EXPOSE 8000

# Set environment variables
ENV FLASK_APP=app.py
ENV FLASK_ENV=production

# Run Gunicorn
CMD ["gunicorn", "-b", "0.0.0.0:8000", "app:app"]
