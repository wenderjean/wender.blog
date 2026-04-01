FROM ruby:latest

# Install system dependencies
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libffi-dev \
  nodejs \
  yarn \
  git \
  && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /site

# Copy Gemfile first (better layer caching)
COPY Gemfile Gemfile.lock ./

# Install bundler and gems
RUN gem install bundler && bundle install

# Copy the rest of the project
COPY . .

# Expose Jekyll default port
EXPOSE 4000

# Default command to run Jekyll server
CMD ["bundle", "exec", "jekyll", "serve", "--host", "0.0.0.0", "--livereload"]
