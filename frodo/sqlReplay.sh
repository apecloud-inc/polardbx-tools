#!/bin/bash

# 确保这些环境变量已经定义
if [[ -z "$ADMIN_AUTH_NAME" || -z "$ADMIN_AUTH_PASSWORD" || -z "$Endpoint" || -z "$OrgName" || -z "$SourceClusterName" || -z "$StartTime" || -z "$EndTime" || -z "$Limit" || -z "$SortType" || -z "$Uid" ]]; then
    echo "Error: One or more required environment variables are not set."
    exit 1
fi

# 执行 curl 请求
curl -X 'GET' -u "$ADMIN_AUTH_NAME:$ADMIN_AUTH_PASSWORD" \
    "http://apiserver:$Endpoint/internal/v1/organizations/$OrgName/clusters/$SourceClusterName/logs/audit?startTime=$StartTime&endTime=$EndTime&limit=$Limit&sortType=$SortType&uid=$Uid" \
    -H 'accept: application/json' -o result2.json

# # 检查 curl 是否成功
# if [ $? -ne 0 ]; then
#     echo "Error: Curl command failed."
#     exit 1
# fi

# 执行 python 脚本，处理日志文件
python3 frodo-core/cloud_log_transfer.py --input_json result.json --output_json output.json

# 检查 python 脚本是否成功执行
if [ $? -ne 0 ]; then
    echo "Error: Python script failed."
    exit 1
fi

# 执行 Java 程序，传入环境变量参数
java -Xms512M -Xmx2G -jar frodo-core/target/frodo-core-1.1.33.jar \
    --file=output.json \
    --source-db="$SourceDb" \
    --replay-to="$TargetDb" \
    --host="$TargetHost" \
    --port="$TargetPort" \
    --username="$TargetUserName" \
    --password="$TargetPassword" \
    --log-level=info \
    --database="$TargetDatabase" \
    --concurrency="$Concurrency" \
    --time="$Time" \
    --task="$Task" \
    --rate-factor="$RateFactor"

# 检查 Java 程序是否成功执行
if [ $? -ne 0 ]; then
    echo "Error: Java program execution failed."
    exit 1
fi

echo "Process completed successfully."
