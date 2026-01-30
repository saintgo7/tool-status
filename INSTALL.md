# 설치 가이드 (Installation Guide)

다른 서버에 설치하는 방법을 안내합니다.

## 방법 1: 배포 패키지 사용 (권장)

### 1-1. 패키지 생성 (현재 서버)

```bash
cd ~/03_TOOLS/project-status
./package.sh
```

생성된 파일: `pstatus-1.0.0.tar.gz` (약 12KB)

### 1-2. 다른 서버로 전송

```bash
# SCP로 전송
scp pstatus-1.0.0.tar.gz user@remote-server:/tmp/

# 또는 USB, 공유 폴더 등으로 복사
```

### 1-3. 원격 서버에서 설치

```bash
ssh user@remote-server

# 압축 해제
cd /tmp
tar xzf pstatus-1.0.0.tar.gz
cd pstatus-1.0.0

# 설치 실행
./install.sh

# Shell 통합 (zsh)
echo 'source ~/03_TOOLS/project-status/shell/pstatus.zsh' >> ~/.zshrc
source ~/.zshrc

# Shell 통합 (bash)
echo 'source ~/03_TOOLS/project-status/shell/pstatus.bash' >> ~/.bashrc
source ~/.bashrc
```

## 방법 2: Git Clone (GitHub 사용 시)

### 2-1. Git 저장소 푸시 (현재 서버)

```bash
cd ~/03_TOOLS/project-status

# GitHub 저장소
# https://github.com/saintgo7/tool-status
```

### 2-2. 다른 서버에서 Clone

```bash
cd ~/03_TOOLS
git clone https://github.com/saintgo7/tool-status.git project-status

cd project-status
./install.sh

# Shell 통합
echo 'source ~/03_TOOLS/project-status/shell/pstatus.zsh' >> ~/.zshrc
source ~/.zshrc
```

## 방법 3: 수동 복사

### 3-1. 필요한 파일만 복사

```bash
# 현재 서버에서
cd ~/03_TOOLS/project-status
tar czf pstatus-minimal.tar.gz bin/ lib/ shell/ install.sh

# 다른 서버로 전송 후
tar xzf pstatus-minimal.tar.gz -C ~/03_TOOLS/
cd ~/03_TOOLS
./install.sh
```

## 방법 4: 직접 다운로드 (인터넷 연결 시)

```bash
# Quick install
curl -fsSL https://raw.githubusercontent.com/saintgo7/tool-status/main/quick-install.sh | bash

# 또는 wget
wget -qO- https://raw.githubusercontent.com/saintgo7/tool-status/main/quick-install.sh | bash
```

## 설치 확인

```bash
# 버전 확인
cat ~/03_TOOLS/project-status/VERSION

# 테스트
cd ~/your-project
pstatus
```

## 다중 서버 일괄 설치

### Ansible 사용

```yaml
# playbook.yml
---
- name: Install pstatus on multiple servers
  hosts: all
  tasks:
    - name: Copy pstatus package
      copy:
        src: pstatus-1.0.0.tar.gz
        dest: /tmp/

    - name: Extract package
      unarchive:
        src: /tmp/pstatus-1.0.0.tar.gz
        dest: /tmp/
        remote_src: yes

    - name: Run installer
      command: /tmp/pstatus-1.0.0/install.sh

    - name: Add to zshrc
      lineinfile:
        path: ~/.zshrc
        line: 'source ~/03_TOOLS/project-status/shell/pstatus.zsh'
        create: yes
```

실행:
```bash
ansible-playbook -i inventory playbook.yml
```

### SSH 반복문 사용

```bash
#!/bin/bash

SERVERS=(
    "server1.example.com"
    "server2.example.com"
    "server3.example.com"
)

for server in "${SERVERS[@]}"; do
    echo "Installing on $server..."

    # 패키지 전송
    scp pstatus-1.0.0.tar.gz "$server:/tmp/"

    # 원격 설치
    ssh "$server" << 'EOF'
        cd /tmp
        tar xzf pstatus-1.0.0.tar.gz
        cd pstatus-1.0.0
        ./install.sh
        echo 'source ~/03_TOOLS/project-status/shell/pstatus.zsh' >> ~/.zshrc
EOF

    echo "Completed on $server"
done
```

## 환경별 설정

### Docker 컨테이너

```dockerfile
FROM ubuntu:22.04

# 패키지 복사
COPY pstatus-1.0.0.tar.gz /tmp/

# 설치
RUN cd /tmp && \
    tar xzf pstatus-1.0.0.tar.gz && \
    cd pstatus-1.0.0 && \
    ./install.sh && \
    echo 'source ~/03_TOOLS/project-status/shell/pstatus.bash' >> ~/.bashrc
```

### 사용자별 설치

```bash
# 특정 사용자 계정에만 설치
sudo -u username bash << 'EOF'
    cd /tmp
    tar xzf pstatus-1.0.0.tar.gz
    cd pstatus-1.0.0
    ./install.sh
EOF
```

## 업데이트

### 기존 설치 업데이트

```bash
# 백업
cp -r ~/03_TOOLS/project-status ~/03_TOOLS/project-status.backup

# 새 버전 설치
cd /tmp
tar xzf pstatus-2.0.0.tar.gz
cd pstatus-2.0.0
./install.sh

# 확인
pstatus --version  # 또는 cat ~/03_TOOLS/project-status/VERSION
```

## 제거

```bash
# Shell 통합 제거
sed -i '/pstatus/d' ~/.zshrc  # 또는 ~/.bashrc

# 디렉토리 삭제
rm -rf ~/03_TOOLS/project-status

# Shell 재로드
source ~/.zshrc  # 또는 source ~/.bashrc
```

## 문제 해결

### 권한 문제

```bash
chmod +x ~/03_TOOLS/project-status/bin/*
chmod +x ~/03_TOOLS/project-status/lib/core/*.sh
chmod +x ~/03_TOOLS/project-status/lib/collectors/*.sh
chmod +x ~/03_TOOLS/project-status/lib/formatters/*.sh
```

### PATH 문제

```bash
# 직접 경로로 실행
~/03_TOOLS/project-status/bin/pstatus

# 또는 PATH에 추가
echo 'export PATH="$PATH:$HOME/03_TOOLS/project-status/bin"' >> ~/.zshrc
```

### Shell Hook 작동 안 함

```bash
# 설정 확인
cat ~/.zshrc | grep pstatus

# 수동으로 다시 추가
echo 'source ~/03_TOOLS/project-status/shell/pstatus.zsh' >> ~/.zshrc
source ~/.zshrc
```
