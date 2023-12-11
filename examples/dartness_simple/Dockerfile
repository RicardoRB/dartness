# An example of using a custom Dockerfile with Dart Frog
# Official Dart image: https://hub.docker.com/_/dart
# Specify the Dart SDK base image version using dart:<version> (ex: dart:2.17)
FROM dart:stable AS build

WORKDIR /app

# Resolve app dependencies.
COPY pubspec.* ./
RUN dart pub get

# Copy app source code and AOT compile it.
COPY . .

# Ensure packages are still up-to-date if anything has changed.
RUN dart pub get --offline
RUN dart compile exe /app/bin/example.dart -o /app/bin/example

# Build minimal serving image from AOT-compiled `/example` and required system
# libraries and configuration files stored in `/runtime/` from the build stage.
FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/bin/example /app/bin/
# Uncomment the following line if you are serving static files.
# COPY --from=build /app/build/public /public/

# Expose the port that your Dart server will listen on
EXPOSE 8080

# Start the server.
CMD ["/app/bin/example"]