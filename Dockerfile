# Use a base image suitable for your application
FROM python:3.7

# Set the working directory inside the container
WORKDIR /app

# Copy the application files to the container's working directory
COPY . /app

# Install dependencies, including Django
RUN pip install -r requirements.txt

# Expose the port your application is listening on (if not already specified in the application code)
EXPOSE 8000

# Command to run your application (modify as needed based on your application)
CMD ["uwsgi", "--http", "0.0.0.0:8000", "--module", "my_app.wsgi:application"]
