#!/bin/bash

# 检查images.txt文件是否存在
if [ ! -f "images.txt" ]; then
    echo "错误: images.txt 文件不存在"
    exit 1
fi

# 读取images.txt文件的每一行
while IFS= read -r line; do
    # 跳过空行
    if [ -z "$line" ]; then
        continue
    fi

    # 原始镜像名称
    original_image="$line"

    # 拼接新的镜像名称
    new_image="registry.cn-hangzhou.aliyuncs.com/xrj4j/$line"

    echo "正在处理镜像: $original_image"

    # 拉取镜像
    echo "拉取镜像: $new_image"
    docker pull "$new_image"

    if [ $? -eq 0 ]; then
        # 重新标记镜像
        echo "标记镜像: $new_image 为 $original_image"
        docker tag "$new_image" "$original_image"

        if [ $? -eq 0 ]; then
            echo "成功处理镜像: $original_image"
            docker rmi "$new_image"
        else
            echo "错误: 无法标记镜像 $original_image"
        fi
    else
        echo "错误: 无法拉取镜像 $new_image"
    fi

    echo "----------------------------------------"
done < "images.txt"

echo "所有镜像处理完成"
