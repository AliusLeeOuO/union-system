package admin_management

import (
	"encoding/json"
	"github.com/gofiber/websocket/v2"
	"log"
	"sync"
	"time"
	"union-system/global"
	"union-system/internal/dto"
	"union-system/internal/repository"
	"union-system/internal/service"
)

// todo 未完成

type SubscriptionManager struct {
	subscriptions map[*websocket.Conn]map[string]bool
	lock          sync.RWMutex
}

func NewSubscriptionManager() *SubscriptionManager {
	return &SubscriptionManager{
		subscriptions: make(map[*websocket.Conn]map[string]bool),
	}
}

func (m *SubscriptionManager) Subscribe(conn *websocket.Conn, topic string) {
	m.lock.Lock()
	defer m.lock.Unlock()
	if _, ok := m.subscriptions[conn]; !ok {
		m.subscriptions[conn] = make(map[string]bool)
	}
	m.subscriptions[conn][topic] = true
}

func (m *SubscriptionManager) Unsubscribe(conn *websocket.Conn, topic string) {
	m.lock.Lock()
	defer m.lock.Unlock()
	if subscriptions, ok := m.subscriptions[conn]; ok {
		delete(subscriptions, topic)
	}
}

func (m *SubscriptionManager) Publish(topic string, message string) {
	m.lock.RLock()
	defer m.lock.RUnlock()
	for conn, topics := range m.subscriptions {
		if topics[topic] {
			if err := conn.WriteMessage(websocket.TextMessage, []byte(message)); err != nil {
				log.Printf("error broadcasting: %v", err)
			}
		}
	}
}

// handleWebSocket 处理WebSocket请求
func handleWebSocket(c *websocket.Conn) {
	c.EnableWriteCompression(true)
	// 订阅管理器实例
	manager := NewSubscriptionManager()

	defer func() {
		// 清理操作
		for topic := range manager.subscriptions[c] {
			manager.Unsubscribe(c, topic)
		}
	}()

	for {
		_, msg, err := c.ReadMessage()
		if err != nil {
			log.Printf("read error: %v", err)
			break
		}

		message := string(msg)
		switch message {
		case "subscribe:ping":
			manager.Subscribe(c, "ping")
		case "unsubscribe:ping":
			manager.Unsubscribe(c, "ping")
		case "subscribe:cpuInfo":
			manager.Subscribe(c, "cpuInfo")
		case "unsubscribe:cpuInfo":
			manager.Unsubscribe(c, "cpuInfo")
		case "subscribe:memInfo":
			manager.Subscribe(c, "memInfo")
		case "unsubscribe:memInfo":
			manager.Unsubscribe(c, "memInfo")
		default:
			log.Printf("unsupported message: %s", message)
		}

		// 可以在这里启动定时器发送消息，或者在其他地方全局控制
		go func() {
			for {
				manager.Publish("ping", func() string {
					websocketPingMessage, _ := json.Marshal(dto.WebsocketPingResponse{
						Code:    0,
						Channel: "ping",
						Msg:     "pong",
					})
					return string(websocketPingMessage)
				}())
				manager.Publish("cpuInfo", func() string {
					adminService := service.NewAdminService(repository.NewAdminRepository(global.Database))
					cpuInfo, getCpuInfoError := adminService.GetCPUInfo()
					if getCpuInfoError != nil {
						log.Printf("failed to get cpu info: %v", err)
						return ""
					}
					websocketCpuInfoMessage, _ := json.Marshal(dto.WebsocketCpuInfoResponse{
						Code:    0,
						Channel: "cpuInfo",
						Msg:     *cpuInfo,
					})
					return string(websocketCpuInfoMessage)
				}())
				manager.Publish("memInfo", func() string {
					adminService := service.NewAdminService(repository.NewAdminRepository(global.Database))
					memInfo, getMemInfoError := adminService.GetMemoryInfo()
					if getMemInfoError != nil {
						log.Printf("failed to get memory info: %v", err)
						return ""
					}
					websocketMemInfoMessage, _ := json.Marshal(dto.WebsocketMemInfoResponse{
						Code:    0,
						Channel: "memInfo",
						Msg:     *memInfo,
					})
					return string(websocketMemInfoMessage)
				}())
				time.Sleep(5 * time.Second)
			}
		}()
	}
}
