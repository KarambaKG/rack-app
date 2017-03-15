FROM ruby:2.4.0-alpine

RUN apk add --no-cache alpine-sdk postgresql-dev git

# Clone console-application
RUN git clone https://github.com/KarambaKG/rack-app.git -b omka

WORKDIR /rack-app

RUN ruby test_post.rb "192" "168" "40" "63"

RUN echo "Создал образ консольного приложения"
