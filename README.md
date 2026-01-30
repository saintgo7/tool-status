# Universal Project Status Display (pstatus)

범용 프로젝트 상태 표시 시스템 - 어떤 프로젝트 디렉토리든 진입 시 자동으로 프로젝트 정보를 표시합니다.

## 특징

- **범용성**: Go, Node.js, Python, Rust, Java 등 모든 프로젝트 타입 자동 감지
- **크로스 플랫폼**: macOS + Linux (Ubuntu, CentOS 등) 모두 지원
- **자동 표시**: 디렉토리 진입 시 간단 요약 자동 표시 (0.5초 이내)
- **상세 정보**: `pstatus` 명령으로 전체 정보 확인
- **확장 가능**: 새로운 언어/프레임워크 쉽게 추가 가능

## 지원하는 프로젝트 타입

| 타입 | 감지 파일 |
|------|----------|
| Go | go.mod |
| Node.js | package.json |
| Python | requirements.txt, pyproject.toml |
| Rust | Cargo.toml |
| Java | pom.xml, build.gradle |
| Git | .git/ |
| Docker | docker-compose.yml, Dockerfile |
| Dev Log | docs/dev-log/, docs/dev-logs/ |

## 설치

### 빠른 설치 (권장)

```bash
# 1. 저장소 클론
cd ~/03_TOOLS
git clone https://github.com/yourusername/project-status.git
# 또는 다운로드
curl -L https://github.com/yourusername/project-status/archive/main.tar.gz | tar xz
mv project-status-main project-status

# 2. 설치 실행
cd project-status
./install.sh

# 3. Shell 통합 (zsh)
echo 'source ~/03_TOOLS/project-status/shell/pstatus.zsh' >> ~/.zshrc
source ~/.zshrc

# 3-1. Shell 통합 (bash)
echo 'source ~/03_TOOLS/project-status/shell/pstatus.bash' >> ~/.bashrc
source ~/.bashrc
```

### 수동 설치

```bash
# 1. 디렉토리 생성
mkdir -p ~/03_TOOLS/project-status

# 2. 파일 복사
cp -r bin lib shell ~/03_TOOLS/project-status/

# 3. 실행 권한 부여
chmod +x ~/03_TOOLS/project-status/bin/*
chmod +x ~/03_TOOLS/project-status/lib/core/*.sh
chmod +x ~/03_TOOLS/project-status/lib/collectors/*.sh
chmod +x ~/03_TOOLS/project-status/lib/formatters/*.sh
```

## 사용법

### 수동 실행

```bash
# 상세 정보 표시
pstatus

# 간단 요약 표시
pstatus-brief

# 별칭 사용
pst   # pstatus와 동일
pstb  # pstatus-brief와 동일
```

### 자동 표시

Shell 통합 후 프로젝트 디렉토리로 이동하면 자동으로 표시됩니다:

```bash
$ cd ~/projects/my-go-app
[my-go-app] Go | Git: main [M2 U1] | Docker: 3/5

$ cd ~/projects/my-node-app
[my-node-app] Node.js | Git: develop | Docker: 0/3 | Log: #042 (2026-01-30)
```

## 출력 예시

### Brief 모드 (간단 요약)

```
[saas-erpmes-2601] Go | Git: feature/sprint1 [M3] | Docker: 8/8 | Log: #002 (2026-01-25)
```

### Detailed 모드 (상세 정보)

```
========================================================================
Project Status Report
========================================================================
Project: saas-erpmes-2601
Types: golang,git,docker,devlog,claude,makefile
Generated: 2026-01-31 16:45:30

[1] Git Repository
------------------------------------------------------------------------
Branch: feature/sprint1-dev-environment
Modified: 3 files
Untracked: 0 files
Remote: https://github.com/user/saas-erpmes-2601.git
Last Commit: cfa4ec0 - feat(i18n): add translation validation

[2] Go Project
------------------------------------------------------------------------
Module: github.com/user/saas-erpmes-2601
Go Version: 1.22
Dependencies: 256

[3] Docker Environment
------------------------------------------------------------------------
Services: 8
Running: 8

[4] Development Log
------------------------------------------------------------------------
Latest: #002 - i18n Complete
Date: 2026-01-25
File: 002_i18n-complete_2026-01-25_0943.md

========================================================================
Quick Actions:
  make help        - Show available commands
  npm run          - Show available scripts
========================================================================
```

## 프로젝트 구조

```
~/03_TOOLS/project-status/
├── bin/
│   ├── pstatus              # 상세 정보 표시
│   └── pstatus-brief        # 간단 요약 표시
├── lib/
│   ├── core/
│   │   ├── detector.sh      # 프로젝트 타입 감지
│   │   └── utils.sh         # 공통 유틸리티
│   ├── collectors/
│   │   ├── git.sh           # Git 정보 수집
│   │   ├── golang.sh        # Go 프로젝트 정보
│   │   ├── nodejs.sh        # Node.js 프로젝트 정보
│   │   ├── docker.sh        # Docker 상태
│   │   └── devlog.sh        # 개발 로그 파싱
│   └── formatters/
│       ├── brief.sh         # 간단 요약 포맷
│       └── detailed.sh      # 상세 정보 포맷
├── shell/
│   ├── pstatus.zsh          # zsh 통합
│   └── pstatus.bash         # bash 통합
├── install.sh               # 설치 스크립트
└── README.md                # 이 파일
```

## 환경 변수

```bash
# 설치 경로 변경 (기본값: ~/03_TOOLS/project-status)
export PSTATUS_HOME=/path/to/custom/location
```

## 의존성

**필수**:
- bash (4.0+)
- git
- grep, sed, awk (POSIX)
- wc, head, tail

**선택** (없어도 동작):
- jq (JSON 파싱 개선)
- docker (컨테이너 상태 확인)

## 확장하기

### 새로운 언어 추가 예시 (Ruby)

1. **Collector 추가** (`lib/collectors/ruby.sh`):

```bash
#!/bin/bash

collect_ruby_info() {
    [[ ! -f "Gemfile" ]] && return 1

    local ruby_version=$(grep "^ruby" Gemfile | awk '{print $2}' | tr -d "'\"")
    local gems=$(wc -l < Gemfile.lock 2>/dev/null | tr -d ' ')

    echo "ruby_version=$ruby_version"
    echo "gems=$gems"
}
```

2. **Detector 수정** (`lib/core/detector.sh`):

```bash
[[ -f "Gemfile" ]] && types+=("ruby")
```

3. **Formatter 수정** (brief.sh, detailed.sh에 Ruby 섹션 추가)

## 문제 해결

### 자동 표시가 작동하지 않음

```bash
# Shell 설정 확인
echo $SHELL

# zsh 사용 시
cat ~/.zshrc | grep pstatus

# bash 사용 시
cat ~/.bashrc | grep pstatus

# 설정 다시 로드
source ~/.zshrc  # 또는 source ~/.bashrc
```

### 권한 오류

```bash
chmod +x ~/03_TOOLS/project-status/bin/*
chmod +x ~/03_TOOLS/project-status/lib/core/*.sh
chmod +x ~/03_TOOLS/project-status/lib/collectors/*.sh
chmod +x ~/03_TOOLS/project-status/lib/formatters/*.sh
```

### 성능 문제

대용량 저장소에서 느릴 경우:

```bash
# 자동 표시 비활성화
# ~/.zshrc 또는 ~/.bashrc에서 해당 줄 주석 처리
# source ~/03_TOOLS/project-status/shell/pstatus.zsh

# 수동으로만 사용
pstatus
```

## 라이선스

MIT License

## 기여

Pull Request와 이슈는 언제든 환영합니다!

## 작성자

Universal Project Status Display System
