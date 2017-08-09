package controllers

import (
	"encoding/json"
	"net/http"

	"github.com/cloudflare/cfssl/log"
	"github.com/noursaadallah/kidner/web/models"
)

func (app *Application) ListMatchesHandler(w http.ResponseWriter, r *http.Request) {
	data := &struct {
		Matches  []models.Match
		Success  bool
		Response bool
	}{
		Matches:  make([]models.Match, 0),
		Success:  false,
		Response: false,
	}

	matchesAsBytes, err := app.Fabric.ListMatches()
	if err != nil {
		log.Error(err.Error())
		http.Error(w, "Unable to query the ID in the blockchain", 500)
	}

	err = json.Unmarshal(matchesAsBytes, &data.Matches)
	if err != nil {
		log.Error(err.Error())
		http.Error(w, "Get incorrect entity", 500)
	}
	data.Success = true
	data.Response = true

	renderTemplate(w, r, "listMatches.html", data)
}
