import csv
import json
from datetime import datetime
import argparse

def get_column_value(row, chinese_column, english_column):
    return row.get(chinese_column, row.get(english_column))

def convert_csv_to_json(csv_file_path, json_file_path):
    with open(csv_file_path, newline='', encoding='utf-8') as csvfile:
        reader = csv.DictReader(csvfile)
        rows = list(reader)
        json_data = []
        
        for row in reversed(rows):
            convertSqlText = row['SQL'].strip('"')
            startTime = int(datetime.strptime(get_column_value(row, '执行时间', 'Timestamp'), "%Y-%m-%dT%H:%M:%S").timestamp())
            session = "1234"  # Placeholder, as the session ID is not available in the CSV
            execTime = int(get_column_value(row, '时长(μs)', 'Time(μs)')) / 1000  # Convert microseconds to milliseconds
            schema = get_column_value(row, '数据库名称', 'DB Name')
            user = get_column_value(row, '账号', 'User').split('[')[0]
            
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

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Convert CSV to JSON')
    parser.add_argument('--csv', required=True, help='Path to the input CSV file')
    parser.add_argument('--json', required=True, help='Path to the output JSON file')
    
    args = parser.parse_args()
    
    convert_csv_to_json(args.csv, args.json)
