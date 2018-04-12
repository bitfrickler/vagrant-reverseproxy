package main

import (
	"fmt"
	"net/http"
	"strings"
	"encoding/base64"
)

func main() {
	http.HandleFunc("/auth/", authHandler)
	http.ListenAndServe(":8080", nil)
}

func authHandler(w http.ResponseWriter, r *http.Request) {
	var authorization = r.Header.Get("Authorization")
	var include = r.Header.Get("X-Ldap-Group-Include")
	var exclude = r.Header.Get("X-Ldap-Group-Exclude")

	auth := strings.SplitN(r.Header["Authorization"][0], " ", 2)

    if len(auth) != 2 || auth[0] != "Basic" {
        http.Error(w, "bad syntax", http.StatusBadRequest)
        return
    }

    payload, _ := base64.StdEncoding.DecodeString(auth[1])
    pair := strings.SplitN(string(payload), ":", 2)

    if len(pair) != 2 /*|| !Validate(pair[0], pair[1])*/ {
        http.Error(w, "authorization failed", http.StatusUnauthorized)
        return
    }

	fmt.Println("authorization: " + authorization)
	fmt.Println("include: " + include)
	fmt.Println("exclude: " + exclude)



	http.Error(w, "authorization failed", http.StatusUnauthorized)
}

func getGroups(userID string)[] string {


}

func isMemberOfAny(userID string, groups[] string) bool {



	return false
}