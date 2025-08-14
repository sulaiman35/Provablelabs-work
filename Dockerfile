# Stage 1: Build the Go application
# Use a specific version for better reproducibility and security.
FROM golang:1.19.13-alpine AS builder

# Set the working directory
WORKDIR /app

# Copy go.mod and go.sum first to leverage Docker's layer caching
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

# Copy the rest of the application source code
COPY . .

# Build the Go application with security-focused flags
# - CGO_ENABLED=0 creates a statically linked binary, which is more secure.
# - -a, -installsuffix cgo, -ldflags="-s -w" remove debugging symbols and DWARF sections, reducing image size and attack surface.
RUN CGO_ENABLED=0 go build -ldflags="-s -w" -o /go-rest-api .

# ----------------------------------------------------------------------------------------------------

# Stage 2: Create the final production image
# Use a non-root user and a minimal base image for the best security.
FROM alpine:3.18.6

# Create a non-root user and group
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Set the working directory to the non-root user's home directory
WORKDIR /home/appuser

# Copy the built binary from the builder stage
# Set the binary to be owned by the non-root user
COPY --from=builder --chown=appuser:appgroup /go-rest-api .

# Switch to the non-root user
USER appuser

# Expose the application port
EXPOSE 8080

# Command to run the executable
CMD ["./go-rest-api"]