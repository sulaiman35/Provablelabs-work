package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"time"
)

// PingPong responds with "pong"
func PingPong(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "pong")
}

// HelloRequest represents the JSON payload for the /hello endpoint.
type HelloRequest struct {
	Name string `json:"name"`
}

// HelloResponse represents the JSON response for the /hello endpoint.
type HelloResponse struct {
	Message   string `json:"message"`
	Timestamp string `json:"timestamp"`
}

// HelloHandler handles the /hello endpoint
func HelloHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method != "POST" {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	var req HelloRequest
	err := json.NewDecoder(r.Body).Decode(&req)
	if err != nil {
		http.Error(w, "Invalid JSON", http.StatusBadRequest)
		return
	}

	timestamp := time.Now().Format(time.RFC3339)
	message := fmt.Sprintf("Hello, %s!", req.Name)

	res := HelloResponse{
		Message:   message,
		Timestamp: timestamp,
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(res)
}

func main() {
	http.HandleFunc("/ping", PingPong)
	http.HandleFunc("/hello", HelloHandler)

	fmt.Println("Server listening on port 8080...")
	log.Fatal(http.ListenAndServe(":8080", nil))
}
