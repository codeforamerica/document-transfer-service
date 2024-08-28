FROM ruby:${RUBY_VERSION:-3.3}

# Make sure system packages are up to date.
RUN apt-get update && apt-get upgrade -y

WORKDIR /opt/app

# Throw errors if Gemfile has been modified since Gemfile.lock.
COPY Gemfile Gemfile.lock *.gemspec ./
RUN bundle config --global frozen 1

# Install application depedencies.
RUN bundle install
RUN bundle binstubs --all

# Copy the application code.
COPY . .

CMD ["./script/api"]
