package service

import (
	"union-system/internal/model/domain"
	"union-system/internal/repository"
)

type LogService struct {
	Repo *repository.LogRepository
}

func NewLogService(repo *repository.LogRepository) *LogService {
	return &LogService{Repo: repo}
}

// AddLoginLog 现在接受单独的参数，并将它们传递到repository的AddLogLogin方法
func (s *LogService) AddLoginLog(ua string, ip string, loginStatus bool, username string) error {
	log := &domain.LogLogin{
		UA:          ua,
		IP:          ip,
		LoginStatus: loginStatus,
		Username:    username,
	}

	return s.Repo.AddLoginLog(log)
}

// AddAdminLog 添加新的管理员操作日志
func (s *LogService) AddAdminLog(userId uint, ip, actionDetail string, moduleID uint) error {
	log := &domain.LogAdmin{
		UserId:       userId,
		ModuleID:     moduleID,
		IP:           ip,
		ActionDetail: actionDetail,
	}

	return s.Repo.InsertAdminLog(log)
}

// AddMemberLog 添加新的会员操作日志
func (s *LogService) AddMemberLog(userId uint, ip, actionDetail string, moduleID uint) error {
	log := &domain.LogMember{
		UserID:       userId,
		ModuleId:     moduleID,
		Ip:           ip,
		ActionDetail: actionDetail,
	}

	return s.Repo.InsertMemberLog(log)
}
