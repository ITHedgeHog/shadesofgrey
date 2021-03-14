FROM ruby:2.7.1-buster AS build
COPY . /app
WORKDIR /app
RUN gem install bundle
RUN bundle config --global jobs 4
RUN bundle config set deployment 'true' 
RUN bundle install
RUN bundle exec jekyll build -d /app/deploy

FROM nginxinc/nginx-unprivileged AS final
COPY --from=build /app/deploy /usr/share/nginx/html
RUN find /usr/share/nginx/html/assets -type f -exec chmod 644 {} \;