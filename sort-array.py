import os
import json
import argparse
from typing import Any

# 優先的にソートするキー
PREFERRED_KEYS = ['Identifier', 'ErrorType', 'Operator', 'id', 'text']

def sort_array(arr: list) -> list:
    if not arr:
        return arr
    # 配列の要素が全てdictの場合、共通のキーを探す
    if all(isinstance(x, dict) for x in arr):
        for key in PREFERRED_KEYS:
            if all(key in x for x in arr):
                return sorted(arr, key=lambda x: x[key])
        # フォールバック: dictを文字列化してソート
        return sorted(arr, key=lambda x: json.dumps(x, sort_keys=True, ensure_ascii=False))
    # 配列の要素が全て文字列、数値、floatの場合
    if all(isinstance(x, (str, int, float)) for x in arr):
        return sorted(arr)
    # 混合型、不明な型: 文字列に変換してソート
    return sorted(arr, key=lambda x: str(x))

def recursive_sort(obj: Any) -> Any:
    if isinstance(obj, dict):
        return {k: recursive_sort(v) for k, v in obj.items()}
    elif isinstance(obj, list):
        sorted_arr = [recursive_sort(x) for x in obj]
        return sort_array(sorted_arr)
    else:
        return obj

def process_file(filepath: str):
    with open(filepath, 'r', encoding='utf-8') as f:
        data = json.load(f)
    sorted_data = recursive_sort(data)
    with open(filepath, 'w', encoding='utf-8') as f:
        json.dump(sorted_data, f, indent=2, ensure_ascii=False)
    print(f"Processed: {filepath}")

def main():
    parser = argparse.ArgumentParser(description='Recursively sort arrays in contact flow definition files.')
    parser.add_argument('--flow-def-dir', type=str, required=True, help='Directory containing contact flow definition .tfpl files')
    args = parser.parse_args()
    flow_def_dir = args.flow_def_dir
    for filename in os.listdir(flow_def_dir):
        if filename.endswith('.tfpl'):
            filepath = os.path.join(flow_def_dir, filename)
            process_file(filepath)

if __name__ == '__main__':
    main() 