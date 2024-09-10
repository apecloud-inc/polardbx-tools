import json
import argparse
from datetime import datetime

def get_column_value(row, chinese_key, english_key):
    # 判断 JSON 字段存在并返回相应值
    return row.get(chinese_key, row.get(english_key))

def convert_json_to_json(input_json_path, output_json_path):
    with open(input_json_path, 'r', encoding='utf-8') as jsonfile:
        data = json.load(jsonfile)
        items = data["items"]
        json_data = []

        for item in reversed(items):
            convertSqlText = item['command'].strip('"')
            startTime = int(datetime.strptime(item['extra']['startTime'], "%Y-%m-%dT%H:%M:%SZ").timestamp())
            session = item['extra'].get('queryID', "1234")  # 使用 queryID 作为 session，或使用默认值
            execTime = item['executionTime']  # 这里直接取执行时间，不需要转换单位
            schema = item['dbName']
            user = item['user'].split('[')[0]  # 提取 user 并去掉 []

            json_record = {
                "convertSqlText": convertSqlText,
                "startTime": startTime,
                "session": session,
                "execTime": execTime,
                "schema": schema,
                "user": user
            }

            json_data.append(json_record)

    # 写入输出的 JSON 文件
    with open(output_json_path, 'w', encoding='utf-8') as outfile:
        for entry in json_data:
            outfile.write(json.dumps(entry, ensure_ascii=False) + '\n')

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Convert JSON to JSON')
    parser.add_argument('--input_json', required=True, help='Path to the input JSON file')
    parser.add_argument('--output_json', required=True, help='Path to the output JSON file')

    args = parser.parse_args()

    convert_json_to_json(args.input_json, args.output_json)
