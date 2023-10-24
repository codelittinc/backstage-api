FROM ruby:3.2.0-bullseye as development

RUN echo "Running Dockerfile with the environment: DEVELOPMENT"

RUN gem install bundler

EXPOSE 3000

WORKDIR /app

# Add the app's bin directory to PATH
ENV PATH /app/bin:$PATH

# Define a path for gem caching
ENV BUNDLE_PATH /box/gems

ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock

RUN bundle config set with 'development'
RUN bundle install

# Generate binstubs for all gems
RUN bundle binstubs --all

ADD ./ /app

FROM development as production

ARG ENVIRONMENT
ARG SECRET_KEY_BASE

RUN echo "Running Dockerfile with the environment: PRODUCTION"

ENV RAILS_ENV production

CMD ["rails", "server", "-b", "0.0.0.0"]
