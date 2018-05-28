package main

import (
	//"bufio"
	"database/sql"
	"encoding/json"
	"fmt"
	_ "github.com/mattn/go-sqlite3"
	"log"
	"net/http"
	"time"
	//"os"
	//"reflect"
	//"regexp"
	//"strings"

	_ "github.com/lib/pq"
	"goji.io"
	"goji.io/pat"
	//"gopkg.in/mgo.v2"
	//"gopkg.in/mgo.v2/bson"
)

type article struct {
	Id           int    `json:"id"`
	Title        string `json:"title"`
	Url          string `json:"url"`
	Submitted_by string `json:"submitted_by"`
	Submitted_at string `json:"submitted_at"`
	Score        int    `json:"score"`
	Tags         string `json:"tags"`
	Teams        string `json:"teams"`
	Favicon      string `json:"favicon"`
}

type clip struct {
	Id           int    `json:"id"`
	Title        string `json:"title"`
	Url          string `json:"url"`
	Submitted_by string `json:"submitted_by"`
	Submitted_at string `json:"submitted_at"`
	Score        int    `json:"score"`
	Tags         string `json:"tags"`
	Teams        string `json:"teams"`
}

type photo struct {
	Id           int    `json:"id"`
	Title        string `json:"title"`
	Url          string `json:"url"`
	Submitted_by string `json:"submitted_by"`
	Submitted_at string `json:"submitted_at"`
	Score        int    `json:"score"`
	Tags         string `json:"tags"`
	Teams        string `json:"teams"`
	Thumb        string `json:"thumb"`
}

func ErrorWithJSON(w http.ResponseWriter, message string, code int) {
	w.Header().Set("Content-Type", "application/json; charset=utf-8")
	w.WriteHeader(code)
	fmt.Fprintf(w, "{message: %q}", message)
}

func ResponseWithJSON(w http.ResponseWriter, json []byte, code int) {
	w.Header().Set("Content-Type", "application/json; charset=utf-8")
	w.WriteHeader(code)
	w.Write(json)
}

func main() {
	//dbinfo := fmt.Sprintf("user=%s password=%s dbname=%s host=%s port=%d sslmode=disable",
	//DB_USER, DB_PASSWORD, DB_NAME, DB_HOST, DB_PORT)
	db, err := sql.Open("sqlite3", "./sports.db")
	checkErr(err)
	defer db.Close()

	mux := goji.NewMux()
	mux.HandleFunc(pat.Get("/articles"), getArticles(db))
	mux.HandleFunc(pat.Get("/clips"), getClips(db))
	mux.HandleFunc(pat.Get("/photos"), getPhotos(db))
	mux.HandleFunc(pat.Post("/post"), postArticles(db))
	http.ListenAndServe(":7005", mux)
}
func postArticles(db *sql.DB) func(w http.ResponseWriter, r *http.Request) {
	return func(w http.ResponseWriter, r *http.Request) {
		if r.Method == "POST" {
			var a article
			r.ParseForm()
			fmt.Println(r.Body)
			decoder := json.NewDecoder(r.Body)
			err := decoder.Decode(&a)
			if err != nil {
				panic(err)
			}
			defer r.Body.Close()
			fmt.Println(a)
			t := time.Now()
			query := fmt.Sprintf("INSERT INTO articles (title, url, submitted_by, submitted_at, score, tags, teams) VALUES ('%s','%s','%s','%s',%d,'%s','%s');", a.Title, a.Url, a.Submitted_by, t, 0, a.Tags, a.Teams)
			_, err = db.Exec(query)
			if err != nil {
				fmt.Println(err)
				return
			}

			fmt.Fprint(w, "POST done")
		} else {
			http.Error(w, "Invalid request method", http.StatusMethodNotAllowed)
		}
	}
}
func getArticles(db *sql.DB) func(w http.ResponseWriter, r *http.Request) {
	return func(w http.ResponseWriter, r *http.Request) {
		r.ParseForm()
		fmt.Println(r.FormValue("team"))
		articles := []article{}
		//query := fmt.Sprintf("SELECT battletag FROM QuickMatch WHERE battletag like '%s%%' and games > 10 LIMIT 10", r.FormValue("query"))
		query := fmt.Sprintf("SELECT * FROM articles WHERE teams like '%%%s%%'", r.FormValue("team"))
		fmt.Println(query)
		rows, err := db.Query(query)
		for rows.Next() {
			var row article
			err = rows.Scan(&row.Id, &row.Title, &row.Url, &row.Submitted_by, &row.Submitted_at, &row.Score, &row.Tags, &row.Teams)
			fmt.Println(row)
			row.Favicon = "https://cdn2.vox-cdn.com/uploads/blog/favicon/178/favicon-5fe18b3b.ico"
			articles = append(articles, row)
		}
		respBody, err := json.MarshalIndent(articles, "", "  ")
		if err != nil {
			log.Fatal(err)
		}
		ResponseWithJSON(w, respBody, http.StatusOK)
	}
}
func getClips(db *sql.DB) func(w http.ResponseWriter, r *http.Request) {
	return func(w http.ResponseWriter, r *http.Request) {
		r.ParseForm()
		fmt.Println(r.FormValue("team"))
		clips := []clip{}
		//query := fmt.Sprintf("SELECT battletag FROM QuickMatch WHERE battletag like '%s%%' and games > 10 LIMIT 10", r.FormValue("query"))
		query := fmt.Sprintf("SELECT * FROM clips WHERE teams like '%%%s%%'", r.FormValue("team"))
		fmt.Println(query)
		rows, err := db.Query(query)
		for rows.Next() {
			var row clip
			err = rows.Scan(&row.Id, &row.Title, &row.Url, &row.Submitted_by, &row.Submitted_at, &row.Score, &row.Tags, &row.Teams)
			clips = append(clips, row)
		}
		respBody, err := json.MarshalIndent(clips, "", "  ")
		if err != nil {
			log.Fatal(err)
		}
		ResponseWithJSON(w, respBody, http.StatusOK)
	}
}
func getPhotos(db *sql.DB) func(w http.ResponseWriter, r *http.Request) {
	return func(w http.ResponseWriter, r *http.Request) {
		r.ParseForm()
		fmt.Println(r.FormValue("team"))
		photos := []photo{}
		//query := fmt.Sprintf("SELECT battletag FROM QuickMatch WHERE battletag like '%s%%' and games > 10 LIMIT 10", r.FormValue("query"))
		query := fmt.Sprintf("SELECT * FROM photos WHERE teams like '%%%s%%'", r.FormValue("team"))
		fmt.Println(query)
		rows, err := db.Query(query)
		for rows.Next() {
			var row photo
			err = rows.Scan(&row.Id, &row.Title, &row.Url, &row.Submitted_by, &row.Submitted_at, &row.Score, &row.Tags, &row.Teams, &row.Thumb)
			fmt.Println(row)
			photos = append(photos, row)
		}
		respBody, err := json.MarshalIndent(photos, "", "  ")
		if err != nil {
			log.Fatal(err)
		}
		ResponseWithJSON(w, respBody, http.StatusOK)
	}
}
func checkErr(err error) {
	if err != nil {
		panic(err)
	}
}
