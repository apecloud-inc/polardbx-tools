import csv
import json
from datetime import datetime

def convert_csv_to_json(csv_file_path, json_file_path):
    with open(csv_file_path, newline='', encoding='utf-8') as csvfile:
        reader = csv.DictReader(csvfile)
        rows = list(reader)
        json_data = []
        
        for row in reversed(rows):
            convertSqlText = row['SQL'].strip('"')
            startTime = int(datetime.strptime(row['执行时间'], "%Y-%m-%dT%H:%M:%S").timestamp())
            session = "1234"  # Placeholder, as the session ID is not available in the CSV
            execTime = int(row['时长(μs)']) / 1000  # Convert microseconds to milliseconds
            schema = row['数据库名称']
            user = row['账号'].split('[')[0]
            
            json_record = {
                "convertSqlText": convertSqlText,
                "startTime": startTime,
                "session": session,
                "execTime": execTime,
                "schema": schema,
                "user": user
            }
            
            json_data.append(json_record)
    
    with open(json_file_path, 'w', encoding='utf-8') as jsonfile:
        for entry in json_data:
            jsonfile.write(json.dumps(entry, ensure_ascii=False) + '\n')

# Example usage
convert_csv_to_json('/root/polardbx-tools/lupin60-auditLog.csv', 'outout_log2.json')
