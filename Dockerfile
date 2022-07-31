FROM ruby:3.0

# Install app
RUN mkdir /myapp
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
# COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle config set force_ruby_platform true
RUN bundle install
COPY . /myapp