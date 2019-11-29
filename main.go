package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"time"
)

func handler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Hi there, I love %s!", r.URL.Path[1:])
}

func main() {
	// kill app after certain amount of time
	time.AfterFunc(time.Second * 10, func() {
		// todo: what exit code 0? will k8s react?
		os.Exit(1)
	})

	port := ":8000"
	log.Println("starting web server on port " + port)
	http.HandleFunc("/", handler)
	log.Fatal(http.ListenAndServe(port, nil))
}
