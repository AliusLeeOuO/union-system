package admin_management

import (
	"log"
	"sync"

	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/websocket/v2"
)

// 订阅管理器
type SubscriptionManager struct {
	subscriptions map[*websocket.Conn]map[string]bool
	lock          sync.RWMutex
}

// 新建订阅管理器
func NewSubscriptionManager() *SubscriptionManager {
	return &SubscriptionManager{
		subscriptions: make(map[*websocket.Conn]map[string]bool),
	}
}

// 添加订阅
func (m *SubscriptionManager) Subscribe(conn *websocket.Conn, topic string) {
	m.lock.Lock()
	defer m.lock.Unlock()
	if _, ok := m.subscriptions[conn]; !ok {
		m.subscriptions[conn] = make(map[string]bool)
	}
	m.subscriptions[conn][topic] = true
}

// 取消订阅
func (m *SubscriptionManager) Unsubscribe(conn *websocket.Conn, topic string) {
	m.lock.Lock()
	defer m.lock.Unlock()
	if subscriptions, ok := m.subscriptions[conn]; ok {
		delete(subscriptions, topic)
	}
}

// 向订阅者广播消息
func (m *SubscriptionManager) Publish(topic string, message string) {
	m.lock.RLock()
	defer m.lock.RUnlock()
	for conn, topics := range m.subscriptions {
		if topics[topic] {
			if err := conn.WriteMessage(websocket.TextMessage, []byte(message)); err != nil {
				// TODO: 这里log要改
				log.Printf("error broadcasting: %v", err)
			}
		}
	}
}

func setupRoutes(app *fiber.App, manager *SubscriptionManager) {
	app.Get("/ws", websocket.New(func(c *websocket.Conn) {
		for {
			mt, msg, err := c.ReadMessage()
			if err != nil {
				log.Println("read:", err)
				break
			}

			// 假设客户端发送的是文本消息
			if mt == websocket.TextMessage {
				message := string(msg)
				switch message {
				case "subscribe:ping":
					manager.Subscribe(c, "ping")
				case "unsubscribe:ping":
					manager.Unsubscribe(c, "ping")
				case "subscribe:message":
					manager.Subscribe(c, "message")
				case "unsubscribe:message":
					manager.Unsubscribe(c, "message")
				default:
					log.Printf("unsupported message: %s", message)
				}
			}
		}
	}))
}
