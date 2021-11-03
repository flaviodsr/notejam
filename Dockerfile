FROM tiangolo/uwsgi-nginx-flask:python3.8-alpine

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

ENV STATIC_PATH /app/notejam/static

COPY ./app /app
