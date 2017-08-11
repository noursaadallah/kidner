package controllers

import (
	"encoding/json"
	"net/http"
	"sort"

	"github.com/cloudflare/cfssl/log"
	"github.com/noursaadallah/kidner/web/models"
)

func (app *Application) ListActivePairsHandler(w http.ResponseWriter, r *http.Request) {
	data := &struct {
		Pairs    []models.Pair
		Success  bool
		Response bool
	}{
		Pairs:    make([]models.Pair, 0),
		Success:  false,
		Response: false,
	}

	pairsAsBytes, err := app.Fabric.ListActivePairs()
	if err != nil {
		log.Error(err.Error())
		http.Error(w, "Unable to query the ID in the blockchain", 500)
	}

	err = json.Unmarshal(pairsAsBytes, &data.Pairs)
	if err != nil {
		log.Error(err.Error())
		http.Error(w, "Get incorrect entity", 500)
	}
	data.Success = true
	data.Response = true
	data.Pairs = sortPairs(data.Pairs)

	renderTemplate(w, r, "listActivePairs.html", data)
}

// ============================================================================================
// sorting pairs by time.Time descendant
// ============================================================================================
type slicePairs []models.Pair

func (p slicePairs) Len() int {
	return len(p)
}

func (p slicePairs) Less(i, j int) bool {
	return p[i].Recipient.CreateDate.After(p[j].Recipient.CreateDate)
}

func (p slicePairs) Swap(i, j int) {
	p[i], p[j] = p[j], p[i]
}

func sortPairs(pairs []models.Pair) []models.Pair {
	slicePairs := make(slicePairs, 0)
	for _, p := range pairs {
		slicePairs = append(slicePairs, p) // make a slicePairs object out of a slice of Pairs
	}
	sort.Sort(slicePairs) // the pairs are now sorted
	sortedPairs := make([]models.Pair, 0)
	for _, p := range slicePairs {
		sortedPairs = append(sortedPairs, p) // make a slice of Pairs out of a slicePairs object
	}
	return sortedPairs
}
