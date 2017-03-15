FROM ruby:2.4.0-alpine

RUN apk add --no-cache alpine-sdk postgresql-dev git

# Clone console-application
RUN git clone https://github.com/KarambaKG/rack-app.git -b console

WORKDIR /rack-app

CMD ruby test_post.rb

RUN echo "Создал образ консольного приложения"
