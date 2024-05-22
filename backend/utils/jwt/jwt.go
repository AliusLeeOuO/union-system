package jwt

import (
	"github.com/golang-jwt/jwt/v4"
	"time"
	"union-system/internal/infrastructure/config"
)

// TokenExpireDuration Token失效时间
const TokenExpireDuration = time.Hour * 24

// secret JWT密钥
var secret = []byte(config.Secret)

type UserInfo struct {
	Id       uint
	Username string
	Role     uint
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
