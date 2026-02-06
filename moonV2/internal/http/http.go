package http

import (
	"io"
	"moon-v2/internal/log"
	"net/http"
	"time"
)

type Header struct {
	Authorization string
}

type Client struct {
	BaseURL string
	Header  Header
}

func (c Client) Get(uri string, body io.Reader) []byte {
	req, _ := http.NewRequest("GET", c.BaseURL+uri, body)
	req.Header.Add("Authorization", c.Header.Authorization)
	return Do(req)
}

func (c Client) Put(uri string, body io.Reader) []byte {
	req, _ := http.NewRequest("PUT", c.BaseURL+uri, body)
	req.Header.Add("Authorization", c.Header.Authorization)
	return Do(req)
}

func Do(req *http.Request) []byte {
	client := &http.Client{Timeout: 10 * time.Second}
	resp, err := client.Do(req)

	if err != nil {
		log.Error(err.Error())
		return nil
	}

	if resp.StatusCode != http.StatusOK {
		log.Error("Failed HTTP: %v", resp)
		return nil
	}

	defer resp.Body.Close()
	body, err := io.ReadAll(resp.Body)

	if err != nil {
		log.Error(err.Error())
		return nil
	}

	return body
}
