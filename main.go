package main

import (
	"fmt"
	"net/http"
)

func main() {
	http.ListenAndServe("0.0.0.0:8787", http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		fmt.Println(r.URL.String())
	}))
}