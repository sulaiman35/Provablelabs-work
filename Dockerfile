# Use the official Golang image to create a build artifact.
FROM golang:1.19-alpine AS builder

WORKDIR /app

COPY . .

RUN go mod init myapp
RUN go mod tidy
RUN CGO_ENABLED=0 go build -o /go-rest-api .

# Use a minimal image for the final container.
FROM alpine:latest

WORKDIR /root/

# Copy the build artifact from the previous stage.
COPY --from=builder /go-rest-api .

# Expose port 8080 to the outside world.
EXPOSE 8080

# Command to run the executable.
CMD ["./go-rest-api"]
