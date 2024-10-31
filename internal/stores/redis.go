package stores

import (
	"fmt"

	"github.com/gomodule/redigo/redis"
	"github.com/rs/zerolog/log"
)

type RedisParameters struct {
	Host 			string
	Port 			string
	MaxConnections 	int
}

type RedisStore struct {
	redisPool* redis.Pool
}

func NewRedisStore(p RedisParameters) RedisStore {
	redisPool := &redis.Pool {
		MaxIdle: p.MaxConnections,
		Dial: 	 func() (redis.Conn, error) {
			return redis.Dial("tcp", fmt.Sprintf("%s:%s", p.Host, p.Port))
		},
	}

	redisStore := RedisStore {
		redisPool : redisPool,
	}
	return redisStore
}

func (r *RedisStore) Increment() (int, error) {
	conn := r.redisPool.Get()
	defer conn.Close()

	log.Info().Msg("Obtained connection")
	return redis.Int(conn.Do("INCR", "visits"))
}