@echo off
setlocal enabledelayedexpansion

REM 检查images.txt文件是否存在
if not exist "images.txt" (
    echo 错误: images.txt 文件不存在
    pause
    exit /b 1
)

REM 读取images.txt文件的每一行
for /f "usebackq tokens=*" %%i in ("images.txt") do (
    REM 跳过空行
    if not "%%i"=="" (
        set "original_image=%%i"
        set "new_image=registry.cn-hangzhou.aliyuncs.com/xrj4j/%%i"

        echo 正在处理镜像: !original_image!

        REM 拉取镜像
        echo 拉取镜像: !new_image!
        docker pull "!new_image!"

        if !errorlevel! equ 0 (
            REM 重新标记镜像
            echo 标记镜像: !new_image! 为 !original_image!
            docker tag "!new_image!" "!original_image!"

            if !errorlevel! equ 0 (
                echo 成功处理镜像: !original_image!
                docker rmi "!new_image!"
            ) else (
                echo 错误: 无法标记镜像 !original_image!
            )
        ) else (
            echo 错误: 无法拉取镜像 !new_image!
        )

        echo ----------------------------------------
    )
)

echo 所有镜像处理完成
pause
