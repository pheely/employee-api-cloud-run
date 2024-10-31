package handler

import (
	"encoding/base64"
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"
	"time"

	"github.com/gorilla/mux"
	"github.com/pheely/employee-api/internal/stores"
	"github.com/rs/zerolog/log"
)

func JsonHeader(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Add("content-type", "application/json")
		next.ServeHTTP(w, r)
	})
}

type Service struct {
	Connection stores.DataSource
	RedisStore stores.RedisStore
}

type employee struct {
	Id         string `json:"id"`
	First_Name string `json:"first_name"`
	Last_Name  string `json:"last_name"`
	Department string `json:"department"`
	Salary     int    `json:"salary"`
	Age        int    `json:"age"`
}

type PubSubNotification struct {
	Message struct {
		Attributes  map[string]interface{} `json:"attributes"`
		MessageID   string                 `json:"messageId"`
		PublishTime time.Time              `json:"publishTime"`
		Data        string                 `json:"data"`
	} `json:"message"`
	Subscription string `json:"subscription"`
}

func convertToEmployeeJson(t stores.Employee) employee {
	jsonT := employee{
		Id:         t.ID,
		First_Name: t.First_Name,
		Last_Name:  t.Last_Name,
		Department: t.Department,
		Salary:     t.Salary,
		Age:        t.Age,
	}
	return jsonT
}

func (s *Service) Help(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(http.StatusOK)
	counter, err := s.RedisStore.Increment()
	if err != nil {
		http.Error(w, "Error incrementing visitor counter", http.StatusInternalServerError)
		return
	}
	log.Info().Msg("counter: " + strconv.Itoa(counter))
	fmt.Fprintf(w, "Employee API v1. You are visitor number %d\n", counter)
}

func (s *Service) GetAllEmployees(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(http.StatusOK)
	list, err := s.Connection.GetAll()
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	result := []employee{}
	for _, t := range list {
		result = append(result, convertToEmployeeJson(t))
	}
	json.NewEncoder(w).Encode(result)
}

func (s *Service) DeleteAllEmployees(w http.ResponseWriter, r *http.Request) {
	s.Connection.DeleteAll()
	s.GetAllEmployees(w, r)
}

func (s *Service) DeleteEmployee(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	id := vars["id"]
	err := s.Connection.Delete(id)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
}

func (s *Service) UpdateEmployee(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	id := vars["id"]

	decoder := json.NewDecoder(r.Body)

	var newT stores.Employee
	err := decoder.Decode(&newT)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	res, err := s.Connection.Update(id, &newT)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	if res == nil {
		w.WriteHeader(http.StatusNotFound)
		return
	}
	json.NewEncoder(w).Encode(convertToEmployeeJson(*res))
}

func (s *Service) GetEmployee(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	t, err := s.Connection.Get(vars["id"])
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	if t != nil {
		json.NewEncoder(w).Encode(convertToEmployeeJson(*t))
		return
	}
	w.WriteHeader(http.StatusNotFound)
}

func (s *Service) CreateEmployee(w http.ResponseWriter, r *http.Request) {
	decoder := json.NewDecoder(r.Body)
	var t stores.Employee
	err := decoder.Decode(&t)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	err = s.Connection.Create(&t)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	json.NewEncoder(w).Encode(convertToEmployeeJson(t))
}

func (s *Service) ProcessCreateEvent(w http.ResponseWriter, r *http.Request) {
	// body, err := ioutil.ReadAll(r.Body)
	// if err != nil {
	// 	// just log the error and return
	// 	log.Error().Err(err).Msg("Error reading POST data")
	// 	return
	// }
	// log.Debug().Msg("POST data =" + string(body))
	// r.Body.Close()

	// if len(bytes.TrimSpace(body)) == 0 {
	// 	log.Warn().Msg("Empty request body. Expecting a PubSub message.")
	// 	return
	// }

	decoder := json.NewDecoder(r.Body)
	var notification PubSubNotification
	err := decoder.Decode(&notification)
	if err != nil {
		log.Warn().Err(err).Msg("Error unmarshalling POST data")
		return
	}

	decoded, error := base64.StdEncoding.DecodeString(notification.Message.Data)
	if error != nil {
		log.Warn().Err(error).Msg("decoding base64 encoded data: " + notification.Message.Data)
		return
	}

	log.Debug().Msg("received: " + string(decoded))

	var payload stores.Employee
	err = json.Unmarshal(decoded, &payload)
	if err != nil {
		log.Warn().Err(error).Msg("Couldn't unmarshal pub/sub message payload")
		return
	}
	err = s.Connection.Create(&payload)
	if err != nil {
		log.Error().Err(error).Msg("Failed to create employee")
		return
	}
}
