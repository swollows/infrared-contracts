package ws

import (
	"net/http"
	"sync"

	"github.com/berachain/offchain-sdk/log"
	"github.com/gorilla/websocket"
)

type WebSocketHandler interface {
	http.Handler
	Broadcast(message any)
	Close() error
}

type webSocketHandler struct {
	Upgrader    websocket.Upgrader
	ClientMutex *sync.Mutex
	Clients     map[*websocket.Conn]bool
	log.Logger
}

func NewWSHandler(logger log.Logger) WebSocketHandler {
	return &webSocketHandler{
		Upgrader: websocket.Upgrader{
			CheckOrigin: func(r *http.Request) bool {
				return true
			},
		},
		ClientMutex: &sync.Mutex{},
		Clients:     make(map[*websocket.Conn]bool),
		Logger:      logger,
	}
}

// ServeHTTP implements the `http.Handler` interface.
func (wsh *webSocketHandler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	ws, err := wsh.Upgrader.Upgrade(w, r, nil)
	if err != nil {
		wsh.Logger.Info("Error during WebSocket upgrade", "err", err)
		return
	}
	defer ws.Close()

	wsh.ClientMutex.Lock()
	wsh.Clients[ws] = true
	wsh.ClientMutex.Unlock()

	// Keep the connection alive by reading messages from the client
	for {
		messageType, _, _ := ws.ReadMessage()
		if messageType == websocket.CloseMessage {
			break
		}
		// No need to handle messages from the client for now since we only broadcast
	}

	wsh.ClientMutex.Lock()
	delete(wsh.Clients, ws)
	wsh.ClientMutex.Unlock()
}

// BroadcastToClients sends a message to all connected clients.
func (wsh *webSocketHandler) Broadcast(message any) {
	wsh.ClientMutex.Lock()
	defer wsh.ClientMutex.Unlock()

	for client := range wsh.Clients {
		err := client.WriteJSON(message)
		if err != nil {
			wsh.Logger.Error("Error during WebSocket broadcast", "err", err)
			client.Close() // #nosec G104
			delete(wsh.Clients, client)
		}
	}
}

func (wsh *webSocketHandler) Close() error {
	for conn := range wsh.Clients {
		if err := conn.Close(); err != nil {
			return err
		}
	}
	return nil
}
