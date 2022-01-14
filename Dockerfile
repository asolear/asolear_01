
# Python image to use.
# https://cloud.google.com/run/docs/quickstarts/build-and-deploy#python
# https://dev.to/pcraig3/google-cloud-run-the-best-host-platform-for-dynamic-apps-4ma6
# https://dev.to/pcraig3/cloud-run-vs-app-engine-a-head-to-head-comparison-using-facts-and-science-1225
# https://cloud.google.com/blog/topics/developers-practitioners/3-ways-optimize-cloud-run-response-times
FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get install -y python3-pip python3-dev \
  && cd /usr/local/bin \
  && ln -s /usr/bin/python3 python \
  && pip3 install --upgrade pip

# Allow statements and log messages to immediately appear in the Knative logs
ENV PYTHONUNBUFFERED True

# Set the working directory to /app
WORKDIR /app

# copy the requirements file used for dependencies
COPY requirements.txt .

# Install any needed packages specified in requirements.txt
RUN pip install --trusted-host pypi.python.org -r requirements.txt

# Copy the rest of the working directory contents into the container at /app
# Install wkhtmltopdf
# RUN apk add --no-cache wkhtmltopdf

RUN apt-get install -y \
  wkhtmltopdf 
# pdftk

COPY . .

EXPOSE 8080

# Run app.py when the container launches
ENTRYPOINT ["python", "app.py"]
CMD exec gunicorn --bind :$PORT --workers 1 --threads 8 --timeout 0 main:app