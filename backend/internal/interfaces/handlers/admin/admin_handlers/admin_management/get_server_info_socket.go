package admin_management

import (
	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/websocket/v2"
	"log"
	"time"
	"union-system/global"
	"union-system/internal/application/dto"
	"union-system/internal/application/service"
	"union-system/internal/infrastructure/repository"
)

type Subscription struct {
	conn  *websocket.Conn
	topic string
}

type Message struct {
	Topic   string      `json:"topic"`
	Content interface{} `json:"content"`
}

type PubSub struct {
	clients     map[*websocket.Conn]map[string]bool // 客户端订阅的主题映射
	subscribe   chan Subscription
	unsubscribe chan Subscription
	broadcast   chan Message
	disconnect  chan *websocket.Conn // 新增：处理断开连接
}

func NewPubSub() *PubSub {
	return &PubSub{
		clients:     make(map[*websocket.Conn]map[string]bool),
		subscribe:   make(chan Subscription),
		unsubscribe: make(chan Subscription),
		broadcast:   make(chan Message),
		disconnect:  make(chan *websocket.Conn), // 初始化disconnect通道
	}
}

func (ps *PubSub) run() {
	ticker := time.NewTicker(5 * time.Second) // 创建一个定时器，5秒触发一次
	defer ticker.Stop()

	for {
		select {
		case conn := <-ps.disconnect:
			// 从clients中移除断开的连接
			delete(ps.clients, conn)
		case <-ticker.C: // 定时触发
			// 遍历所有订阅了"ping"的客户端并发送"pong"
			for conn, topics := range ps.clients {
				if topics["ping"] { // 如果订阅了"ping"
					err := conn.WriteJSON(Message{Topic: "ping", Content: "pong"})
					if err != nil {
						log.Printf("Error sending pong: %v", err)
						conn.Close()             // 发生错误时关闭连接
						delete(ps.clients, conn) // 从订阅者列表中移除
					}
				}
				if topics["cpuInfo"] {
					adminService := service.NewAdminService(repository.NewAdminRepository(global.Database))
					cpuInfo, getCpuInfoError := adminService.GetCPUInfo()
					if getCpuInfoError != nil {
						log.Printf("failed to get cpu info: %v", getCpuInfoError)
						conn.Close()             // 发生错误时关闭连接
						delete(ps.clients, conn) // 从订阅者列表中移除
					}
					err := conn.WriteJSON(Message{
						Topic: "cpuInfo",
						Content: dto.WebsocketCpuInfoResponse{
							Code:    0,
							Channel: "cpuInfo",
							Msg:     *cpuInfo,
						},
					})
					if err != nil {
						log.Printf("Error sending cpuInfo: %v", err)
						conn.Close()             // 发生错误时关闭连接
						delete(ps.clients, conn) // 从订阅者列表中移除
					}
				}
				if topics["memInfo"] {
					adminService := service.NewAdminService(repository.NewAdminRepository(global.Database))
					memInfo, getMemInfoError := adminService.GetMemoryInfo()
					if getMemInfoError != nil {
						log.Printf("failed to get memory info: %v", getMemInfoError)
						conn.Close()             // 发生错误时关闭连接
						delete(ps.clients, conn) // 从订阅者列表中移除
					}
					err := conn.WriteJSON(Message{
						Topic: "memInfo",
						Content: dto.WebsocketMemInfoResponse{
							Code:    0,
							Channel: "memInfo",
							Msg:     *memInfo,
						},
					})
					if err != nil {
						log.Printf("Error sending memInfo: %v", err)
						conn.Close()             // 发生错误时关闭连接
						delete(ps.clients, conn) // 从订阅者列表中移除
					}
				}
			}
		case sub := <-ps.subscribe:
			// 检查这个连接是否已经订阅了该主题
			if topics, ok := ps.clients[sub.conn]; ok {
				if _, subscribed := topics[sub.topic]; !subscribed {
					topics[sub.topic] = true

					// 发送确认消息
					err := sub.conn.WriteJSON(Message{
						Topic:   "subscribed",
						Content: "Successfully subscribed to " + sub.topic,
					})
					if err != nil {
						log.Printf("Error sending subscribe confirmation: %v", err)
						return
					}

					// 特定主题订阅的额外处理逻辑...
				} else {
					sub.conn.WriteJSON(Message{
						Topic:   "subscribed",
						Content: "You are already to subscribe this topic",
					})
				}
			} else {
				// 这是该连接的第一次订阅
				ps.clients[sub.conn] = map[string]bool{sub.topic: true}

				// 发送确认消息
				err := sub.conn.WriteJSON(Message{
					Topic:   "subscribed",
					Content: "Successfully subscribed to " + sub.topic,
				})
				if err != nil {
					log.Printf("Error sending subscribe confirmation: %v", err)
					return
				}
			}

		case unsub := <-ps.unsubscribe:
			if topics, ok := ps.clients[unsub.conn]; ok {
				if _, subscribed := topics[unsub.topic]; subscribed {
					delete(topics, unsub.topic)
					// 当一个连接不再订阅任何主题时，可以选择从clients中移除该连接
					if len(topics) == 0 {
						delete(ps.clients, unsub.conn)
					}
				}
			}

		case msg := <-ps.broadcast:
			for conn, topics := range ps.clients {
				if topics[msg.Topic] {
					err := conn.WriteJSON(msg)
					if err != nil {
						log.Printf("websocket write error: %v", err)
						conn.Close()
						delete(ps.clients, conn)
					}
				}
			}
		}
	}
}

// 定义WebSocket处理函数
func handleDeviceInfoWebSocket(pubsub *PubSub) fiber.Handler {
	return websocket.New(func(c *websocket.Conn) {
		// 确保在函数退出时通知PubSub系统连接已断开
		defer func() {
			pubsub.disconnect <- c
		}()

		for {
			var msg Message
			if err := c.ReadJSON(&msg); err != nil {
				log.Println("WebSocket read error:", err)
				break
			}

			switch msg.Topic {
			case "subscribe":
				pubsub.subscribe <- Subscription{conn: c, topic: msg.Content.(string)}
			case "unsubscribe":
				pubsub.unsubscribe <- Subscription{conn: c, topic: msg.Content.(string)}
			}
		}
	})
}
