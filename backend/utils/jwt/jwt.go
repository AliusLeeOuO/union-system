package jwt

import (
	"github.com/golang-jwt/jwt/v4"
	"time"
)

// TokenExpireDuration Token失效时间
const TokenExpireDuration = time.Hour * 12

// secret JWT密钥
var secret = []byte("ELfI6Ly3NAfjNCmKFXcNXgad9qHkCatCyehh2tAFJG9O0uFOYE3i6zWeKgzC0Yz7jHWMrXLyNTuK4n7NA6wQGdMBNUxW0W1C26Qn")

type UserInfo struct {
	Id       uint
	Username string
}

type MyClaims struct {
	User UserInfo
	jwt.RegisteredClaims
}

func GenerateToken(userInfo UserInfo) (string, error) {
	claims := &MyClaims{
		User: userInfo,
		RegisteredClaims: jwt.RegisteredClaims{
			ExpiresAt: &jwt.NumericDate{Time: time.Now().Add(TokenExpireDuration)},
			Issuer:    "server",
		},
	}
	// 生成Token，指定签名算法和claims
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	// 签名
	if tokenString, err := token.SignedString(secret); err != nil {
		return "", err
	} else {
		return tokenString, nil
	}

}

func ParseToken(tokenString string) (*MyClaims, error) {
	claims := &MyClaims{}
	_, err := jwt.ParseWithClaims(tokenString, claims, func(t *jwt.Token) (interface{}, error) {
		return secret, nil
	})
	// 若token只是过期claims是有数据的，若token无法解析claims无数据
	return claims, err
}
