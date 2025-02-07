@echo off
chcp 65001
set VERSION=2.1.0-SNAPSHOT
set REGISTRY=registry.cn-shenzhen.aliyuncs.com
set IMAGE_NAME=golfonline-im

:select_env
echo 请选择构建环境:
echo [1] 本地环境
echo [2] 开发环境
set INPUT=1
set /p INPUT="请输入选择 (1/2) [1]: "

if "%INPUT%"=="2" (
    set CONFIG_DIR=dev-config
) else (
    set CONFIG_DIR=config
)

echo 使用 %CONFIG_DIR% 目录构建镜像...
docker build -t %REGISTRY%/golfonline-cloud/%IMAGE_NAME%:%VERSION% --build-arg CONFIG_DIR=%CONFIG_DIR% .

set /p push="是否要推送镜像到远程仓库? (Y/N) [Y]: "
if /i not "%push%"=="N" (
    echo 正在登录阿里云镜像仓库...
    docker login %REGISTRY% -u mse@greenjoy -p Htx2022!
    
    echo 正在推送镜像...
    docker push %REGISTRY%/golfonline-cloud/%IMAGE_NAME%:%VERSION%
    echo 镜像推送完成
) else (
    echo 取消推送镜像
)
pause